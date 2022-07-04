//
//  TitleTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class TitleTextFieldCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let titleInputField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TitleTextFieldCellViewModel){
        titleInputField.rx.text //titleInputField가 입력된 텍스트를 뱉으면
            .bind(to: viewModel.titleText) //뷰모델의 titleText(PublishRelay)로 바인드
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        titleInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout(){
        contentView.addSubview(titleInputField)
        titleInputField.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(20)
        }
    }
}

