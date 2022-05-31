//
//  Repository.swift
//  GitHubRepository
//
//  Created by Finley on 2022/05/31.
//

import Foundation

struct Repository: Decodable{
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    //json데이터의 이름과 내가 정해둔 이름 맞추기
    enum CodingKeys: String, CodingKey{
        case id, name, description, language //내가 정한 변수명과 json데이터 내 키값이 동일함
        case stargazersCount = "stargazers_url"
          // ㄴ 내가 정한 변수명   // ㄴ json데이터 내 키값
    }
}
