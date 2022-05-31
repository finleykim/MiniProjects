//
//  RepositoryListCell.swift
//  GitHubRepository
//
//  Created by Finley on 2022/05/31.
//

import UIKit
import SnapKit

class RepositoryListCell: UITableViewCell{
    var repository: Repository?
    
    //컴포넌트 생성, addSubview
    let nameLabel = UILabel() //repository이름
    let descriptionLabel = UILabel() //repository설명
    let starImageView = UIImageView() //별모양표현
    let starLabel = UILabel() // 별갯수
    let languageLabel = UILabel() //어떤 언어를 사용했는지
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [nameLabel,descriptionLabel,
         starImageView, starLabel, languageLabel].forEach{
            contentView.addSubview($0)
        }
        
        //컴포넌트 설정 (폰트, 내용, constraints 등)
        guard let repository = repository else { return } // repository가 nil이면 return하도록 옵셔널처리
        nameLabel.text = repository.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        descriptionLabel.text = repository.description
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 2 //라벨 몇줄
        
        starImageView.image = UIImage(systemName: "star")
        starLabel.text = "\(repository.stargazersCount)"
        starLabel.font = .systemFont(ofSize: 16)
        starLabel.textColor = .gray
        
        languageLabel.text = repository.language
        languageLabel.font = .systemFont(ofSize: 16)
        languageLabel.textColor = .gray
        
        nameLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        starImageView.snp.makeConstraints{
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(descriptionLabel) //descriptionLabel.snp.leading을 descriptionLabel로 퉁칠 수 있다.
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        starLabel.snp.makeConstraints{
            $0.centerY.equalTo(starImageView) //starImageView의 센터와 맞춤
            $0.leading.equalTo(starImageView.snp.trailing).offset(5) //starImageView의 trailing에서 5띄움
        }
        
        languageLabel.snp.makeConstraints{
            $0.centerY.equalTo(starLabel)
            $0.leading.equalTo(starLabel.snp.trailing).offset(12)
        }
    }
}
