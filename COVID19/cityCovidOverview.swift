//
//  CityCovidOverview.swift
//  COVID19
//
//  Created by Finley on 2022/04/05.
//

import Foundation

struct CovidOverview: Codable{
    let countryName: Int
    let newCase: Int
    let totalCase: Int
    let recovered: Int
    let death: Int
    let percentage: Double
    let newCcase: Int
    let newFcase: Int
}


struct CityCovidOverView: Codable{
    let korea: CovidOverview
    let seoul: CovidOverview
    let busan: CovidOverview
    let daegu: CovidOverview
    let inchen: CovidOverview
    let gwangju: CovidOverview
    let daejeon: CovidOverview
    let ulsan: CovidOverview
    let sejong: CovidOverview
    let gyeonggi: CovidOverview
    let gangwon: CovidOverview
    let chungbuk: CovidOverview
    let chungnam: CovidOverview
    let jeonbuk: CovidOverview
    let jeonnam: CovidOverview
    let gyeongbuk: CovidOverview
    let gyeongnam: CovidOverview
    let jeju: CovidOverview
}
