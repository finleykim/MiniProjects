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
    
    //viewModel -> view
    let setMapCenter: Signal<MTMapPoint> //지도 중앙 위치잡기
    let errorMessege: Signal<String> //에러메시지
    
    //view -> viewModel (view의 extension에 델리게이트 메서드로부터 전달 받을것들과, 버튼누름 이벤트)
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>() //'현재위치를 확인하는 버튼을 누름' 이벤트를 수신한다.
    
    init(){
        //MARK: 지도 중심점 설정
        //현재위치 확인버튼이 눌렸음을 정의
        let moveToCurrentlocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation) //트리거 발생 직전 가장 최신의 값만 내뱉는다.
        
        
        let currentMapCenter = Observable
            .merge(
                currentLocation.take(1),//현위치를 받았을 때 최초 한 번
                moveToCurrentlocation//현위치 확인버튼이 눌렸을 때
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty()) //setMapCenter를 currentMapCenter에 연결시켜 시그널로 전달
        
        //MARK: 에러메시지 전달
        errorMessege = mapViewError.asObservable() //mapViewError를 옵저버블로 전환하고
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요") //시그널로 전달
}
}
