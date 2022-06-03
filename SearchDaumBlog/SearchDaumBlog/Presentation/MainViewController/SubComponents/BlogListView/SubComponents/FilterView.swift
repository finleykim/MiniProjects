//
//  FilterView.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/03.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class FilterView: UITableViewHeaderFooterView{
    let disposBag = DisposeBag()
    
    let sortButton = UIButton()
    let bottomBorder = UIView()
    
    //FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        sortButton.rx.tap //sortButton을 tap했을 때
            .bind(to: sortButtonTapped) ////PublishRelay에 bind
            .disposed(by: disposBag)
    }
    
    private func attribute(){
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        bottomBorder.backgroundColor = .lightGray
    }
    
    private func layout(){
        [sortButton, bottomBorder]
            .forEach{
                addSubview($0)
            }
        
        sortButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(28)
        }
        
        bottomBorder.snp.makeConstraints{
            $0.top.equalTo(sortButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
