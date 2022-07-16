//
//  Dummy.swift
//  FindCVSTests
//
//  Created by Finley on 2022/07/16.
//

import Foundation

@testable import FindCVS //FindCVS를 볼 것이다.

var cvsList: [KLDocument] = Dummy().load("networkDummy.json") //cvsList는 KLDocument의 배열이고 Dummy의 load메서드를 통해 만들어지고, networkDummy.json을 관찰한다.

class Dummy {
    func load<T: Decodable>(_ filename: String) -> T { //load는 제너럴로 Decodable한 값을 받으며 filename을 스트링으로 받는다
        let data: Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: filename, withExtension: nil) else {
            fatalError("\(filename)을 main bundle에서 불러올 수 없습니다.")
        } //file은 bundle에서 url을 갖는데, 이 url은 filename을 리소스로 갖고 익스텐션은 nil이다. 만약 없을경우 fatalError발생지정
        
        do { //위 과정을 잘 통과했다면
            data = try Data(contentsOf: file) //data는 Data
        } catch { //do의 과정을 실패했다면
            fatalError("\(filename)을 main bundle에서 불러올 수 없습니다.\(error)") //fatalError발생지정
        }
        
        do { //위 과정을 잘 통과했다면
            let decoder = JSONDecoder() //decoder는 JSONDecoder이고
            return try decoder.decode(T.self, from: data) //data로부터 decoder를 쓸 수 있게한다.
        } catch { //do의 과정을 실패했다면
            fatalError("\(filename)을 \(T.self)로 파싱할 수 없습니다.") //fatalError발생지정
        }
    }
}

