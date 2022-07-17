//
//  LocationInformationViewModel.swift
//  FindCVS
//
//  Created by Finley on 2022/07/12.
//

import RxSwift
import RxCocoa

struct LocationInformationViewModel{
    let disposeBag = DisposeBag()
    
    //subViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel() //detailListBackgroundViewModel불러오기
    
    //viewModel -> view
    let setMapCenter: Signal<MTMapPoint> //지도 중앙 위치잡기
    let errorMessege: Signal<String> //에러메시지
    let detailListCellData: Driver<[DetailListCellData]> //추후 API통신을 통해 데이터를 받아왔을 때 뷰에 전달할 데이터. (placeName,address 등)
    let scrollToSelectedLocation: Signal<Int> //맵 내에서 핀을 탭했을 때 테이블뷰의 스크롤을 움직여, 탭한 핀에 해당되는 셀을 보여준다. 테이블의 row로 스크롤을 이동시킬 것이기 때문에 Int값을 전달한다.
    
    //view -> viewModel (view의 extension에 델리게이트 메서드로부터 전달 받을것들과, 버튼누름 이벤트)
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>() //핀을 선택했을 때 발생하는 이벤트
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>() //'현재위치를 확인하는 버튼을 누름' 이벤트를 수신한다.
    let detailListItemSelected = PublishRelay<Int>() //리스트(셀)이 선택되었을 때 해당 셀의 row값을 전달받는다.
    
    private let documentData = PublishSubject<[KLDocument]>() //KLDocument(Entity참고)형태로 documentData를 받는다
    
    init(model: LocationInformationModel = LocationInformationModel()){ //이니셜라이저에 모델선언
        //MARK: 네트워크 통신으로 데이터 불러오기
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation) //flatMapLatest로 model의 getLocation함수를 전달한다 getLocation함수는 네트워크의 MTMapPoint를 전달받아 Single로 반환하는 메서드이다. mapCenterPoint가 뷰에서 뷰모델로 전달될 때 마다 flatMapLatest로 받아서 API통신을 진행한다.
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
        //nil을 내보내지 않기위해 compactMap을 사용한다.
            .compactMap { data -> LocationData? in //Error를 뱉을수도, LocationData을 뱉을 수도 있기때문에 옵셔널로 표현한다.
                guard case let .success(value) = data else {
                    return nil //success의 value값을 반환하고 그렇지 않으면 nil을 반환한다.
                }
                return value //정상적이라면 value를 반환
            } //cvsLocationDataValue가 갖는 값은 Observable<LocationData>이 되었다.
        
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap{ data -> String? in
                switch data{
                case let .success(data) where data.documents.isEmpty: //빈 값이 왔는데 성공이라면(사실상 에러)
                    return """
                    500m 근처에 이용할 수 있는 편의점이 없어요.
                    지도 위치를 옮겨서 재검색해주세요.
                    """
                case let .failure(error): //URLError를 담아서 온다면
                    return error.localizedDescription //해당 에러의 디스크립션을 반환한다.
                default: //success이지만 isEmpty가 아닌경우(성공)
                    return nil //성공일 경우 에러메시지를 반환할 필요가 없으므로 nil반환
                }
                
            }
        
        cvsLocationDataValue
            .map { $0.documents } //documents만 뽑아서
            .bind(to: documentData) //documentData에 바인드. documentData는 viewModel로 불러온 KLDocument데이터임.
            .disposed(by: disposeBag)
        
        //MARK: 지도 중심점 설정
        //뷰에서 뷰모델로 전달된 detailListItemSelected(리스트의 셀을 선택함)이벤트를 받아 이를 제어한다.
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] } //documentData(KLDocument)를 리스트로받아 선택한 row에 해당하는 값을 뽑아 셀에 표시한다.
            .map(model.documentToMTMapPoint)
        
        //현재위치 확인버튼이 눌렸음을 정의
        let moveToCurrentlocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation) //트리거 발생 직전 가장 최신의 값만 내뱉는다.
        
        
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem, //디테일 리스트(셀)탭 했을 때
                currentLocation.take(1),//현위치를 받았을 때 최초 한 번
                moveToCurrentlocation//현위치 확인버튼이 눌렸을 때
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty()) //setMapCenter를 currentMapCenter에 연결시켜 시그널로 전달
        
        //MARK: 에러메시지 전달
        errorMessege = Observable
            .merge(
                cvsLocationDataErrorMessage, //네트워크로 에러메시지가 발생했을 때와
                mapViewError.asObservable() //mapViewError가 이벤트를 받았을 때(이때는 옵저버블로 전환하고)
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요") //시그널로 전달
        
        detailListCellData = documentData
            .map(model.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map { !$0.isEmpty } //documentData가 비었는지 확인하고, 비어있지 않다면
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel) //shouldHideStatusLabel에 바인드 (shouldHideStatusLabel: 리스트에 데이터가 있는지 없는지를 알려줄 값)
            .disposed(by: disposeBag)
        
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag } //tag라는 고유의 값으로 전환한 후
            .asSignal(onErrorJustReturn: 0) //signal로 전달
        
}
}
