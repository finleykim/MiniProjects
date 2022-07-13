//
//  LocationInformationViewController.swift
//  FindCVS
//
//  Created by Finley on 2022/07/12.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

class LocationInformationViewController: UIViewController{
    let disposdBag = DisposeBag()
    
    let locationManager = CLLocationManager() //위치정보제공 권한설정
    let mapView = MTMapView() //지도 SDK에서 제공하는 MTMapView를 추가하여 화면에 지도를 표시한다
    let currentLocationButton = UIButton() //현재 나의 위치를 표시할 버튼
    let detailList = UITableView() //지도에 표시된 편의점 리스트
    let viewModel = LocationInformationViewModel() //viewModel직접주입
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView와 locationManager 델리게이트설정
        mapView.delegate = self
        locationManager.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
    private func bind(_ viewModel: LocationInformationViewModel) {
        viewModel.setMapCenter //뷰모델에서 받은 값으로 map뷰에 센터를 두라는 명령
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposdBag)
        viewModel.errorMessege
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposdBag)
        
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposdBag)
    }
    
    private func attribute(){
        title = "내 주변 편의점 찾기"
        view.backgroundColor = .white
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
    }
    
    private func layout() {
        [mapView, currentLocationButton, detailList]
            .forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        currentLocationButton.snp.makeConstraints{
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints{
            $0.center.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
}



extension LocationInformationViewController: CLLocationManagerDelegate{
    //didChangeAuthorization: 사용자가 허용한 위지정보제공 범위(매번허용, 앱사용중에만 허용 등)에 대한 처리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status { //각각의 status에 맞는 상황을 만든다
            //매번허용, 앱 사용중에허용 또는 별도의 언급이 없는 경우에는 그냥 둔다.
        case .authorizedAlways,
                .authorizedWhenInUse,
                .notDetermined :
            return
        default : //비허용(사용획득하지 못한 경우) 에러처리
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDenied.errorDescription)  //뷰모델에 에러를 만들어 처리.
            return //아직 뷰모델에 에러처리코드를 작성하지 않은 상태이므로 임의의 값으로 처리해둔다.
            
        }
    }
    
}

extension LocationInformationViewController: MTMapViewDelegate{
    //updateCurrentLocation : 현재의 위치를 매번 업데이트해주는 메서드
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        //CLLocation는 현재위치정보를 사용하기때문에 시뮬레이터에서 정상적인 테스트를 할 수 없다.(시뮬레이터는 자신의 현재위치를 받아올 수 없기때문) 테스트를위해 디버그일 때와 그렇지 않은 경우를 나누어 임의의 좌표값을 입력해야한다.
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341))) //디버그환경에서의 활동을 설정. 임의의 좌표값설정
        #else
//        viewModel.currentLocation.accept(location) //파라메터를 통해 좌표값을 받아올 것
        #endif
    }
    
    //finishedMapMoveAnimation: 지도의 마지막 센터포인트를 전달하는 메서드(지도를 이리저리 움직이다가 멈췄을 때의 화면중앙 MTMapPoint)
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
         viewModel.mapCenterPoint.accept(mapCenterPoint) //마찬가지로 viewModel에서 처리
    }
    
    //selectedPOIItem: POIItem이란 지도상에서 핀표시된 아이템을 가리키는데, 이 POIItem을 탭할 때 마다 MTMapPoint값을 전달한다.
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    //failedUpdatingCurrentLocationWithError: 제대로된 현재위치를 불러오지 못했을 때 에러처리
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}

extension Reactive where Base : MTMapView{
    //좌표 센터값이 없을 때를 대비해 setMapCenter를 이쪽으로 이어준다.
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
    
}

extension Reactive where Base: LocationInformationViewController {
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "문제가 발생했어요", message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            base.present(alertController, animated: true, completion: nil)
        }
    }
}
