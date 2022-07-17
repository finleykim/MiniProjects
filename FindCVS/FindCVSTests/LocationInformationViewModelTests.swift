//
//  LocationViewModelTests.swift
//  FindCVSTests
//
//  Created by Finley on 2022/07/17.
//

import XCTest
import Nimble
import RxSwift
import RxTest

@testable import FindCVS

class LocationInformationViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    let stubNetwork  = LocalNetworkStub()
    var model: LocationInformationModel!
    var viewModel: LocationInformationViewModel!
    var doc: [KLDocument]!
    
    override func setUp() {
        self.model = LocationInformationModel(localNetwork: stubNetwork)
        self.viewModel = LocationInformationViewModel(model: model)
        self.doc = cvsList
    }
    
    //MARK: 지도중심점에 대한 테스트
    func testSetMapCenter() {
        let scheduler = TestScheduler(initialClock: 0) //Rxtest에서 제공하는 TestScheduler선언, 0부터 시작
        
        //더미데이터 이벤트 - 더미데이터가 어떠한 네트워크를 통해 cvsList형태로 내뱉는 형태
        let dummyDataEvent = scheduler.createHotObservable([ //dummyDataEvent를 스케쥴러의 핫옵저버블로 만든다.
            .next(0, cvsList) //0초에(최초에)cvsList를 뱉는다
        ])
        
        let documentData = PublishSubject<[KLDocument]>()
        dummyDataEvent
            .subscribe(documentData)
            .disposed(by: disposeBag)
        
        //지도중심점이벤트(1) : DetailList 아이템(셀) 탭 이벤트 
        let itemSelectedEvent = scheduler.createHotObservable([
            .next(1, 0) //1초가 지난 시점에 0번째 아이템을 눌렀다고 가정
        ])
        
        let itemSelected = PublishSubject<Int>()
        itemSelectedEvent
            .subscribe(itemSelected)
            .disposed(by: disposeBag)
        
        let selectedItemMapPoint = itemSelected
            .withLatestFrom(documentData) { $1[0] }
            .map(model.documentToMTMapPoint)
        
        //지도중심점 이벤트(2) : 최초 현재 위치 이벤트
        let initialMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(37.394225), longitude: Double(127.110341)))! //MTMapPointGeo를 사용해 MTMapPoint를 가상에서 만들어준다
        let currentLocationEvent = scheduler.createHotObservable([
            .next(0, initialMapPoint) //0초에 initialMapPoint이벤트(가상 MTMapPoint이벤트)가 나온다.
        ])
        
        let initialCurrentLocation = PublishSubject<MTMapPoint>()
        
        currentLocationEvent
            .subscribe(initialCurrentLocation)
            .disposed(by: disposeBag)
        
        //현재 위치 버튼 탭 이벤트
        let currentLocationButtonTapEvent = scheduler.createHotObservable([
            .next(2, Void()), //2초에 탭함
            .next(3, Void()) //3초에 탭함
        ])
        
        let currentLocationButtonTapped = PublishSubject<Void>() //옵저버
        
        currentLocationButtonTapEvent
            .subscribe(currentLocationButtonTapped)
            .disposed(by: disposeBag)
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(initialCurrentLocation) //탭 버튼이 눌리고, 실제로 initialCurrentLocation를 받았을 때
        
        //Merge
        let currentMapCenter = Observable
            .merge(
                selectedItemMapPoint,
                initialCurrentLocation.take(1),
                moveToCurrentLocation
            )
        
        let currentMapCenterObserver = scheduler.createObserver(Double.self) //currentMapCenter를 관찰할 옵저버
        
        currentMapCenter
            .map { $0.mapPointGeo().latitude }
            .subscribe(currentMapCenterObserver)
            .disposed(by: disposeBag)
        
        scheduler.start() //스케줄러 시작
        
        let secondMapPoint = model.documentToMTMapPoint(doc[0]) //secondMapPoint는 documentToMTMapPoint를 통해 doc[0]가 MTMapPoint값으로 변환된 값
        
        expect(currentMapCenterObserver.events).to( 
            equal([
                .next(0, initialMapPoint.mapPointGeo().latitude),
                .next(1, secondMapPoint.mapPointGeo().latitude),
                .next(2, initialMapPoint.mapPointGeo().latitude),
                .next(3, initialMapPoint.mapPointGeo().latitude)
            ])
        )
    }
}
 
