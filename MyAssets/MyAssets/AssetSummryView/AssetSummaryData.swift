//
//  AsstSummaryData.swift
//  MyAssets
//
//  Created by Finley on 2022/04/29.
//

import SwiftUI

class AessetSummaryData: ObservableObject {
    //디코딩된 에셋을 내보낸다.
    @Published var assets: [Asset] = load("assets.json")

}

//디코딩과정

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError(filename + "을 찾을 수 없습니다")
    }
    
    //통과해서 파일을 찾은 경우 or 파일을 찾지 못한 경우
    do{
        data = try Data(contentsOf: file)
                       //  ㄴ 가져올 위치
    }catch{
        fatalError(filename + "을 찾을 수 없습니다.")
    }
    
    //파일을 찾아서 데이터를 가지고 온 경우 or 찾았지만 데이터를 가지고오지 못 한 경우
    do{
         let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError(filename + "을 \(T.self)로 파싱할 수 없습니다.")
    }
    
}

