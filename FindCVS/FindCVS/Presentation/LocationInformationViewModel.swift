//
//  LocationInformationViewModel.swift
//  FindCVS
//
//  Created by Finley on 2022/07/12.
//

import RxSwift
import RxCocoa

struct LocationInformationViewModel{
    let diaposeBag = DisposeBag()
    
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
    
    let documentData = PublishSubject<[KLDocument?]>() //KLDocument(Entity참고)형태로 documentData를 받는다
    
    init(){
        //MARK: 지도 중심점 설정
        //뷰에서 뷰모델로 전달된 detailListItemSelected(리스트의 셀을 선택함)이벤트를 받아 이를 제어한다.
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] } //documentData(KLDocument)를 리스트로받아 선택한 row에 해당하는 값을 뽑아 셀에 표시한다.
            .map { data -> MTMapPoint in  //뽑아낸 데이터를 MTMapPoint로 전환한다
                guard let data = data,
                      let longtitue = Double(data.x), //위도경도값은 String으로 전달되기 때문에 Double타입으로 변환한다.
                      let latitude = Double(data.y) else {
                    return MTMapPoint() //만약 데이터가 변환되지않거나, 전달되지 않았다면 제로값을 갖는 MTMapPoint를 반환한다.
                }
                let geoCoord = MTMapPointGeo(latitude: latitude, longitude: longtitue) //데이터를 받았다면 MTMapPoitnGeo라는 객체로 전환하여
                return MTMapPoint(geoCoord: geoCoord) //MTMapPoint값으로 반환한다.
            }
        
        //현재위치 확인버튼이 눌렸음을 정의
        let moveToCurrentlocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation) //트리거 발생 직전 가장 최신의 값만 내뱉는다.
        
        
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                currentLocation.take(1),//현위치를 받았을 때 최초 한 번
                moveToCurrentlocation//현위치 확인버튼이 눌렸을 때
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty()) //setMapCenter를 currentMapCenter에 연결시켜 시그널로 전달
        
        //MARK: 에러메시지 전달
        errorMessege = mapViewError.asObservable() //mapViewError를 옵저버블로 전환하고
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요") //시그널로 전달
        
        detailListCellData = Driver.just([]) //추후 API통신을 구현한 후 재설정할 것. (현재 임의의 값)
        
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag } //tag라는 고유의 값으로 전환한 후
            .asSignal(onErrorJustReturn: 0) //signal로 전달
        
}
}
