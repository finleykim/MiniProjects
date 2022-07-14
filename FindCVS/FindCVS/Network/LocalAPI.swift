//
//  LocalAPI.swift
//  FindCVS
//
//  Created by Finley on 2022/07/14.
//

import Foundation

//API를 어떤방식으로 전달할지 작성한다
struct LocalAPI {
    //문서에서 확인한 정보를 참고로 작성한다
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/local/search/category.json"
    
    func getLocation(by mapPoint: MTMapPoint) -> URLComponents {
        var components = URLComponents()
        components.scheme = LocalAPI.scheme
        components.host = LocalAPI.host
        components.path = LocalAPI.path
        
        components.queryItems = [ //문서에서 필수로 전달해야하한다고 지정해둔 값
            URLQueryItem(name: "category_group_code", value: "CS2"),
            URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
            URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
            URLQueryItem(name: "radius", value: "500"),
            URLQueryItem(name: "sort", value: "distance")
        ]
        
        return components
    }
}
