//
//  DetailWriteFormCell.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailWriteFormCell: UITableViewCell{
    let disposeBag = DisposeBag()
    let contentInputView = UITextView() //멀티라인의 텍스트를 입력하기때문에 field가 아닌 view로 생성
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailWriteFormCellViewModel){
        contentInputView.rx.text //뷰모델에 보낼 이벤트 - 텍스트가 입력되었음을 알리는 이벤트
            .bind(to: viewModel.contentValue) //뷰모델의 contentValue에 바인드걸어준다
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        contentInputView.font = .systemFont(ofSize: 17)
    }
    
    private func layout(){
        contentView.addSubview(contentInputView)
        
        contentInputView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
    }
    }
}
