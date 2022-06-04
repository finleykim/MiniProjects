//
//  DKBlog.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/04.
//

import Foundation


struct DKBlog: Decodable{
    let documetns: [DKDocument]
}

struct DKDocument: Decodable{
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum Codingkeys: String, CodingKey {
        case title, thumnail, datetime
        case name = "blogname"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        
        self.title = try? values.decode(String?.self, forKey: .title)
        self.name = try? values.decode(String?.self, forKey: .name)
        self.thumbnail = try? values.decode(String?.self, forKey: .thumnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}


//Date포멧 (Date라는 타입이 JSON에 없기 때문에 이해할 수 있도록 별도의 함수를 만들어야한다)
extension Date{
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else{
                  return nil
              }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy=MM-dd'T'HHLmm:ss.SSSXXX" //JSON데이터의 날짜표시형식
        dateFormatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
}
