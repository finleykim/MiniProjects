//
//  BeerListCell.swift
//  Brewery
//
//  Created by Finley on 2022/04/23.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell{
    let beerImageVIew = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageVIew,nameLabel,taglineLabel].forEach{
            //3개의 오브젝트를 cell의 contentview에 추가
            contentView.addSubview($0)
        }
        //각 오브젝트들의 속성
        beerImageVIew.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        taglineLabel.font = .systemFont(ofSize: 14, weight:.light)
        taglineLabel.textColor = .systemBlue
        taglineLabel.numberOfLines = 0
        
        //각 오브젝트들의 오토레이아웃
        beerImageVIew.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
            
        }
        
        nameLabel.snp.makeConstraints{
            $0.leading.equalTo(beerImageVIew.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageVIew.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints{
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    
    
    //* 각 컴포넌트들과 데이터연결
    func configure(with beer: Beer){
        //image가져오기
        let imageURL = URL(string: beer.imageURL ?? "")
        //kingfisher를 통해 가져온 정보를 imageView에 전달
        beerImageVIew.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon"))
                                // ㄴwith: 이미지소스, placeholder: image가 전달되지 않았을 경우 띄울 기본이미지
        //nameLabel에 표시할 텍스트, nil값일 경우 전달할 문자열
        nameLabel.text = beer.name ?? "이름없는 맥주"
        //taglineLabel에 표시할 텍스트
        taglineLabel.text = beer.tagLine
        
        //화살표추가
        accessoryType = .disclosureIndicator
        //셀 클릭시 회색음영 발생 방지
        selectionStyle = .none
    }
}
