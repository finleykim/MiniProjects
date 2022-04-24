//
//   Beer.swift
//  Brewery
//
//  Created by Finley on 2022/04/23.
//

import Foundation

struct Beer: Decodable{
    let id : Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
    //stirng형태 변경(각각의 문자열을 해쉬태그 방식으로 변경)
    var tagLine: String{
        let tags = taglineString?.components(separatedBy: ". ")
        let hashtags = tags?.map{
            //#붙이고 띄어스기 공백 삭제
            "#" + $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
                                    // ㄴ of: 삭제할대상 , with: 삭제한대상의 자리에 새로 들어갈 대상
                .replacingOccurrences(of: ",", with: "#")
                
        }
        return hashtags?.joined(separator: "") ?? ""
    }
    
    
    //서버에서 사용하는 key값 설명
    enum CodingKeys: String, CodingKey{
        case id, name, description
        case taglineString = "tagline"
        case imageURL = "image_url"
        case brewersTips = "brewers_tips"
        case foodPairing = "food_pairing"
    }
}
