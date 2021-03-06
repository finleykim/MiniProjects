//
//  DiaryCell.swift
//  Diary
//
//  Created by Finley on 2022/03/25.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    //3. 타이틀, 탈짜라벨 아울렛변수선언
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    

    
}

