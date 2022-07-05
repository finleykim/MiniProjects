//
//  MainModel.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/05.
//

import Foundation

struct MainModel{
    func setAlert(errorMessage: [String]) -> Alert { //errorMessage를 Alert으로 바꿀것이다. 여기서 Alert은 (title: String, message: String?)임.
        let title = errorMessage.isEmpty ? "성공" : "실패"
        let message = errorMessage.isEmpty ? nil : errorMessage.joined(separator: "\n")
        return (title: title, message: message)
    }
}
