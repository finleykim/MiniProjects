//
//  Diary.swift
//  Diary
//
//  Created by Finley on 2022/03/26.
//

import Foundation


struct Diary{
    var uuidString: String //일기를 생성할 때 마다 일기를 특정할 때 마다 고유한 uuid값을 넣을 프로퍼티
    var title: String //일기에 제목을 저장
    var contents: String //일기에 내용을 저장
    var date: Date //일기가 작성된 날짜를 저장
    var isStar: Bool //즐겨찾기여부를 저장
}
