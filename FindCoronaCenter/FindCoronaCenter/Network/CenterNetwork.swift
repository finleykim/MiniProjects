//
//  CenterNetwork.swift
//  FindCoronaCenter
//
//  Created by Finley on 2022/07/26.
//

import Foundation
import Combine

class CenterNetwork{
    private let session: URLSession
    let api = CenterAPI()
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func getCenterList() -> AnyPublisher<[Center], URLError>{
        guard let url = api.getCenterListComponents().url else{ //url선언
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } //만약 url없으면 Fail반환. (기존 Failure와 동일한기능)
        var request = URLRequest(url: url)
        request.setValue("Infuser 0eKp2qUdRZ4/Gys/qs1buJfEDqRWF8tZtib+cWd4lRGm1S2S24iib5E3JwHEYj+zNvuwck2FXzQQoh77Fvd3DA==", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request) //URLSession에서 기본으로 제공하는dataTaskPublisher에 request를 넣어 반환
            .tryMap { data, response in //데이터(data), 응답 처리(response)
                guard let httpResponse = response as? HTTPURLResponse else{
                    throw URLError(.unknown) //httpResponse선언 response(HTTPURLResponse) 응답없을경우 unknown에러반환
                }
                switch httpResponse.statusCode{
                case 200..<300: //정상응답
                    return data
                case 400..<500: //클라이언트에러처리
                    throw URLError(.clientCertificateRejected)
                case 500..<599: //서버에러처리
                    throw URLError(.badServerResponse)
                default: //그밖에 알수없는에러
                    throw URLError(.unknown)
                }
            }
            .decode(type: CenterAPIResponse.self, decoder: JSONDecoder()) //publish로 반환할 경우 decode기능으로 간단하게 디코딩가능하다. type에 전환하고자하는 타입을 입력하고 전환형태(JSONDecoder)를 입력하면 제이슨디코딩 끝 ~ 대박이뉑 ~~*
            .map { $0.data } //처음 CenterAPIResponse에서 data만 선택추출
            .mapError { $0 as! URLError } //에러가났을 때 어떤식으로 전환할지설정
            .eraseToAnyPublisher()
        
    }
}
