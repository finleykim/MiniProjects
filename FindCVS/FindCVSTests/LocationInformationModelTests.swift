//
//  LocationInformationModelTests.swift
//  FindCVSTests
//
//  Created by Finley on 2022/07/16.
//

import XCTest
import Nimble

@testable import FindCVS

class LocationInformationModelTests: XCTestCase {
    let stubNetwork = LocalNetworkStub()
    
    var doc: [KLDocument]! //도큐먼트가 발생할 것이고 KLDocument인 리스트가 나올 것이다.
    var model: LocationInformationModel! //모델은 LocationInformationModel이다
    
    override func setUp() { //setup메서드를 통한기초설정
        self.model = LocationInformationModel(localNetwork: stubNetwork) //model은 LocationInformationModel이고 네트워크는 실제네트워크가 아닌 stubNetwork로 받는다.
        self.doc = cvsList //doc는 cvsList를 그대로 가져온다.
    }
    
    //기본적으로 getLocation을 하지않고 stub을 통해 도큐먼트가 뿌려졌다고 가정하고 두번째 함수인 documentsToCellData를 테스트한다.
    func testDocumentsToCellData() {
        let cellData = model.documentsToCellData(doc) //cellData를 모델에 documentsToCellData doc을 넣었을 때의 결과값이다. (실제 모델에서실행. 즉, 실제 모델의 값)
        let placeName = doc.map { $0.placeName }  //placeName은 doc의 placeName만 가져올 수 있다 (더미데이터에서 가져온 값. 즉,dummy 값)
        
        let address0 = cellData[1].address  //address0는 cellData 첫번째 값의 adress(셀 데이터에서 adress를 가져왔고 이는 모델의 실제값)
        let roadAddressName = doc[1].roadAddressName    //roadAddressName는 doc의 첫번째 roadAddressName(더미데이터에서 가져온 값인 doc에서 가져온 값.즉, dummy 값)
        

        expect(cellData.map { $0.placeName }).to(
            equal(placeName), //가져온 값은 placeName과 같아야한다
            description: "DetailListCellData의 placeName은 document의 PlaceName이다."
        ) //모델에서의 documentsToCellData함수는 documents에 있는 것들을 cellData형식으로 전환하는데, 전환을 했다고해서 내부의 순서나 값 자체가 변경되어서는 안된다는 것을 테스트
        
        expect(address0).to(
            equal(roadAddressName),
            description: "KLDocument의 RoadAddressName이 빈 값이 아닐 경우 roadAdderss가 cellData에 전달된다."
        ) // documentsToCellData함수는 documentToMTMapPoint함수를 이용하고, 간단한 수식을 포함한다(구주소 도로명수소 adress를 비교해서 선택하는 수식). 따라서 이 테스트는 더미데이터에 도로명주소가 있다면 도로명주소가 나와야함을 테스트
    }
}
