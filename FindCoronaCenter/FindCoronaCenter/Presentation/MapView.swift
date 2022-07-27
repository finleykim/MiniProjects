//
//  MapView.swift
//  FindCoronaCenter
//
//  Created by Finley on 2022/07/27.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable{
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    //CLLocationCoordinate2D : 지도 위 핀표시를 하기위해 필요한 고유 struct 아이템
}

struct MapView: View {
    var coordination: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    //@State: 상태표현. observableObject와 달리 외부의 영향을 받지 않는다.
    @State private var annotationItems = [AnnotationItem]()
    var body: some View {
        Map(
            coordinateRegion: $region,//state로 표현한 경우에는 $를 붙여 state를 계속해서 주시할 것이라고 표현할 수 있다.
            annotationItems: [AnnotationItem(coordinate: coordination)],
            annotationContent: {
                MapMarker(coordinate: $0.coordinate) //MapMarker: 핀표시
            }
        )
        .onAppear{
            setRegion(coordination)
            setAnnotationItems(coordination)
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D){
        region = MKCoordinateRegion(
        center: coordinate, //center: 맵의 가운데좌표 지정
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) //열마나 가깝고 크게표시할것인지 1에 가까울수록 넓은범위를 보여준다.
        )
    }
    
    private func setAnnotationItems(_ coordinate: CLLocationCoordinate2D){
        annotationItems = [AnnotationItem(coordinate: coordinate)]
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, facilityName: "실내빙상장 앞", address: "경기도 뫄뫄시 뫄뫄구", lat: "37.404476", lng: "126.9491998", centerType: .central, phoneNumber: "010-0000-0000")
        MapView(
            coordination: CLLocationCoordinate2D(
                latitude: CLLocationDegrees(center0.lat) ?? .zero,
                longitude: CLLocationDegrees(center0.lng) ?? .zero
            )
        )
    }
}
