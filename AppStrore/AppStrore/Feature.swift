//
//  Feature.swift
//  AppStrore
//
//  Created by Finley on 2022/05/06.
//

import Foundation

struct Feature: Decodable{
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}
