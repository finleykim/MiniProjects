//
//  PriceTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PriceTextFieldCell: UITableViewCell{
    let disposeBag = DisposeBag()
    let priceInputField = UITextField()
    let freeShareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldCellViewModel){
        //ViewModel -> View로 받는 이벤트들을 정리
        viewModel.showFreeShareButton //showFreeShareButton라는 이벤트를 전달받으면
            .map{ !$0 } //true값을 false로 바꿔서
            .emit(to: freeShareButton.rx.isHidden) //isHidden이 false가 되어 버튼을 보여준다.
            .disposed(by: disposeBag)
        
        viewModel.resetPrice
            .map { _ in "" }
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        //view -> ViewModel로 전달할 이벤트들을 정리
        priceInputField.rx.text
            .bind(to: viewModel.priceValue) //viewModel에 있는 priceValue에 바인드걸어준다
            .disposed(by: disposeBag)
        
        freeShareButton.rx.tap
            .bind(to: viewModel.freeShareButtonTapped) //viewModel에 있는 freeShareButtonTapped에 바인드걸어준다
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        freeShareButton.setTitle("무료나눔 ", for: .normal)
        freeShareButton.setTitleColor(.orange, for: .normal)
        freeShareButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeShareButton.titleLabel?.font = .systemFont(ofSize: 18)
        freeShareButton.tintColor = .orange
        freeShareButton.backgroundColor = .white
        freeShareButton.layer.borderColor = UIColor.orange.cgColor
        freeShareButton.layer.borderWidth = 1.0
        freeShareButton.layer.cornerRadius = 10.0
        freeShareButton.clipsToBounds = true
        freeShareButton.isHidden = true
        freeShareButton.semanticContentAttribute = .forceRightToLeft
        
        priceInputField.keyboardType = .numberPad //가격 입력이기때문에 키보드타입을 숫자타입으로
        priceInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout(){
        [priceInputField, freeShareButton].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeShareButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
    }
}


