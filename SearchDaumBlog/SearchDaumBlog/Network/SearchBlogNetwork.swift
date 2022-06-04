//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/04.
//

import Foundation
import RxSwift


//에러케이스 열거
enum SearchNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}


class SearchBlogNetwork{
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared){ //init으로 세션받기
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>> { //네트워크는 성공,실패 두가지밖에없기때문에 Single로 받는다
        guard let url = api.searchBlog(query: query).url else{ //url선언 (쿼리는 내가 SearchBlogAPI의 함수에서 정해둔 값)
            return .just(.failure(.invalidURL))
            
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 3c05890eebbbf878cf76b4dd7332228a", forHTTPHeaderField: "Authorization")
                        // ㄴ plist에 넣은 API관련값(item0)
        
        //rx의 data에서 request를 핸들링하여 반환
        return session.rx.data(request: request as URLRequest)
            .map{ data in
                do{
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                }catch{
                    return .failure(.invalidJSON) //invalidJSON에러
                }
            }
            .catch{ _ in //에러발생시 핸들링
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}
