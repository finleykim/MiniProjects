//
//  detailListCell.swift
//  FindCVS
//
//  Created by Finley on 2022/07/13.
//

import UIKit
import SnapKit

class detailListCell: UITableViewCell{
    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel() //중심에서의 거리 표시
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: DetailListCellData){
        //각각의 네임을 받았을 때 텍스트형식으로 표시할 수 있도록 설정
        placeNameLabel.text = data.placeName
        addressLabel.text = data.address
        distanceLabel.text = data.distance
    }
    
    private func attribute(){
        backgroundColor = .white
        placeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .gray
        
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .darkGray
    }
    
    private func layout(){
        [placeNameLabel, addressLabel, distanceLabel]
            .forEach { contentView.addSubview($0) }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(18)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(placeNameLabel)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
