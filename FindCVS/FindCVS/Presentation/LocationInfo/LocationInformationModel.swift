//
//  LocationInformationModel.swift
//  FindCVS
//
//  Created by Finley on 2022/07/14.
//

import Foundation
import RxSwift

struct LocationInformationModel {
    let localNetwork: LocalNetwork
    
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    //네트워크의 MTMapPoint를 전달받아 Single로 반환하는 메서드
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return localNetwork.getLocation(by: mapPoint)
    }
    
    //LocationData(Entity)의 Document를 받기위해 Document의 타입인 KLDocument로 data를 받아, 이를 DetailListCellData로 한번 더 변환하는 함수를 작성한다.
    func documentsToCellData(_ data: [KLDocument]) -> [DetailListCellData] {
        return data.map { //데이터를 받아 변환한다
            //KLDocument에는 roadAddressName가 있다. 기본적으로 이 데이터를 반환하지만 만약 없다면(isEmpty가 true일 경우), addressName을 받는다. 즉, 도로명주소가 없는경우 구주소를 반환한다.
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = documentToMTMapPoint($0)
            return DetailListCellData(placeName: $0.placeName, address: address, distance: $0.distance, point: point)
        }
    }
    
    //KLDocument를 MTMapPoint로 변환하는 함수작성
    func documentToMTMapPoint(_ doc: KLDocument) -> MTMapPoint {
        let longitude = Double(doc.x) ?? .zero //x값과y값은 String으로 전달되기 때문에 Double로 변환해야한다.
        let latitude = Double(doc.y) ?? .zero
        
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        //geoCoord: 위경도 좌표시스템
        //geoCoord은 MTMapPointGeo을 통해 구현할 수 있고,latitude와 longitude를 각각 설정하는 방식이다.
    }
}


