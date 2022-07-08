//
//  KLDocument.swift
//  FindCVS
//
//  Created by Finley on 2022/07/08.
//

import Foundation

struct KLDocument: Decodable{
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let distance: String
    
    enum CodingKeys: String, CodingKey{
        case x,y,distance
        case placeName = "place_name"
        case addressName = "adress_name"
        case roadAddressName = "road_address_name"
    }
}
