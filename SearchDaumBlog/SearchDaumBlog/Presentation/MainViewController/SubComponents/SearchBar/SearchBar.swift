//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/03.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

class SearchBar: UISearchBar{
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    //searchBar 버튼탭이벤트
    let searchButtonTapped = PublishRelay<Void>() //PublishRelay는 error를 받지않고 onNext만 받는다
    
    //SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        Observable
            .merge( //두가지 경우를 Observable로 변환하여 merge
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped) //PublishRelay에 bind
            .disposed(by: disposeBag)
        
        //탭 이벤트가 발생했을 때(endEditing 컨트롤)
        searchButtonTapped //searchButtonTapped가 발생하면,
            .asSignal() //이 것을 signal로 변환하고
            .emit(to: self.rx.endEditing) //endEditing에 연결
            .disposed(by: disposeBag)
        
        self.shouldLoadResult = searchButtonTapped //외부로 내보낼 이벤트 = PublishRelay
            .withLatestFrom(self.rx.text) {$1 ?? ""}//가장 최신의 서치바텍스트를 전달. 만약 없다면 ""
            .filter{!$0.isEmpty} //비어있는 값을 거른다
            .distinctUntilChanged() //동일한조건 검색방지
    }
    
    private func attribute(){
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout(){
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        searchButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
}


//바인더 (endEditing) 커스텀
extension Reactive where Base: SearchBar{
    var endEditing: Binder<Void>{
        return Binder(base){base, _ in
            base.endEditing(true)
            
        }
    }
}
