//
//  LocalNetworkStub.swift
//  FindCVSTests
//
//  Created by Finley on 2022/07/16.
//

import Foundation
import RxSwift
import Stubber

@testable import FindCVS

class LocalNetworkStub : LocalNetwork{
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return Stubber.invoke(getLocation, args: mapPoint) //Stubber의 invoke메서드를 사용하여 getLocation이라는 함수를 실행하고 mapPoint를 argument로 갖는다는 선언
    }
} 
