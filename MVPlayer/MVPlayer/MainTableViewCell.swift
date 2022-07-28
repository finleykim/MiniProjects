//
//  MainTableViewCell.swift
//  MVPlayer
//
//  Created by Finley on 2022/07/27.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell{
    let thumbnail = UIImageView()
    let songTitle = UILabel()
    let singerName = UILabel()
    let labelStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute(){
        thumbnail.backgroundColor = .clear
        
        songTitle.font = .systemFont(ofSize: 16, weight: .bold)
        songTitle.textColor = .label
        
        singerName.font = .systemFont(ofSize: 12, weight: .light)
        singerName.textColor = .secondaryLabel
        
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing
        labelStack.spacing = 5
    }
    
    private func layout(){
        [songTitle, singerName].forEach{
            labelStack.addArrangedSubview($0)
        }
        [thumbnail, labelStack].forEach{
            contentView.addSubview($0)
        }
        
        thumbnail.snp.makeConstraints{
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        labelStack.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().offset(10)
            $0.leading.equalTo(thumbnail.snp.trailing).inset(20)
            $0.trailing.equalToSuperview()
        }
    }
}


