//
//  LocalNetwork.swift
//  FindCVS
//
//  Created by Finley on 2022/07/14.
//

import RxSwift

class LocalNetwork {
    private let session: URLSession
    let api = LocalAPI() //LocalAPI불러오기
    
    //이니셜라이징
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> { //네트워크는 성공또는 실패의 값만 내보내기때문에 Single 트레잇을 사용하고, Result를 통해 LocationData와 URLError를 받도록한다.
        guard let url = api.getLocation(by: mapPoint).url else { //url은 api(LocalAPI)의 getLocation(by: mapPoint)라는 것을 받았을 때의 url이다.
            return .just(.failure(URLError(.badURL))) //만약없다면 이렇게 표현한다. URLError는 스위프트의 기본에러값이다. URL을 다뤘을 때 생길 수 있는 대부분의 에러케이스들을 가지고있다.
        }
        //성공해서 통과했다면 아래 코드가 실행된다
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 0888ca89830a9806516c748e48443b64", forHTTPHeaderField: "Authorization") //카카오 문서 내 REST API키를 붙여넣는다. 이 때 주의해야할 점은 값을 헤더에 넣고싶다면 forKey가 아닌 forHTTPHeaderField로 입력해야 해당하는 키 값(Authorization)으로 헤더에 밸류(REST API)가 적용된다.
        
        return session.rx.data(request: request as URLRequest)
            .map { data in //위 코드가 실행되었다면 data가 내려오게 될 것이고, 그 데이터를 JSON디코더링을 한다.
                do { //에러가아니라면
                    //locationData은 JSONserialization을 이용해서 디코드한다 형태는 LocationData.self임을 알린다.
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData) //locationData를 담은 success형태로 반환한다.
                } catch { //실패 에러발생
                    return .failure(URLError(.cannotParseResponse)) //cannotParseResponse: 파싱할 수 없다는 에러
                }
            }
        //에러가 발생한 경우 Result의 failure를 내보내고 cannotLoadFromNetwork방식으로 에러를 표현한다
            .catch { _ in .just(Result.failure(URLError(.cannotLoadFromNetwork))) }
            .asSingle() //Single로 변환
    }
}

