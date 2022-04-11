//
//  CreditCard.swift
//  CreditCardList
//
//  Created by Finley on 2022/04/11.
//

import Foundation


struct CreditCard: Codable{
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    
    //객체안의 객체
    let promotionDetail: PromotionDetail
    
    //사용자가 카드를 선택했을 때 생성될 것. 그 전까지는 nil값을 가질것이기 때문에 옵셔널
    let isSelected: Bool?
    
}


struct PromotionDetail: Codable{
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
