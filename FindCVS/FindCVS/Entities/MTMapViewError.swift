//
//  MTMapViewError.swift
//  FindCVS
//
//  Created by Finley on 2022/07/12.
//

import Foundation

enum MTMapViewError: Error{
    case failedUpdationCurrentLocation
    case locationAuthorizationDenied
    
    var errorDescription: String{
        switch self{
        case .failedUpdationCurrentLocation:
            return "현재 위치를 불러오지 못했습니다. 잠시 후 다시 시도해주세요"
        case . locationAuthorizationDenied:
            return "위치 정보를 활성화해주세요"
        }
    }
}
