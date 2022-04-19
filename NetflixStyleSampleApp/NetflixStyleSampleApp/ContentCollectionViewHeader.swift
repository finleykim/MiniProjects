//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by Finley on 2022/04/19.
//

import UIKit
import SnapKit

class ContentCollectionViewHeader: UICollectionReusableView{
    //라벨생성
    let sectionNameLabel = UILabel()
    
   //라벨설정
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 7, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        //라벨추가
        addSubview(sectionNameLabel)
        
        //오토레이아웃(스냅킷)
        sectionNameLabel.snp.makeConstraints{
            //Y축은 부모뷰와 동일하게
            $0.centerY.equalToSuperview()
            //constraints: 탑,바텀,리딩 : 10
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
        
    }
}
