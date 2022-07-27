//
//  CenterAPIResponse.swift
//  FindCoronaCenter
//
//  Created by Finley on 2022/07/26.
//

import Foundation

struct CenterAPIResponse: Decodable{
    let data: [Center]
}
