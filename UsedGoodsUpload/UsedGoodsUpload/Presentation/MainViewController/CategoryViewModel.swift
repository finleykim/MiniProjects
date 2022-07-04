//
//  CategoryViewModel.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/04.
//

import RxSwift
import RxCocoa

struct CategoryViewModel{
    let disposeBag = DisposeBag()
    
    let cellData: Driver<[Category]> //카테고리를 나타낼 데이터를 뷰에 전달한다.
    let pop: Signal<Void> // Pop이벤트를 인지한다.
    let itemSelected = PublishRelay<Int>() //어떤 카테고리를 선택했는지 row값을 받아낸다.
    
    let selectedCategory = PublishRelay<Category>() //MainViewController에서 선택된 카테고리를 표시할 수 있도록 전달한다.
    
    init(){ //카테고리 데이터
        let categories = [
        Category(id: 1, name: "디지털/가전"),
        Category(id: 2, name: "게임"),
        Category(id: 3, name: "스포츠/레저"),
        Category(id: 4, name: "유아/아동용품"),
        Category(id: 5, name: "여성패션/잡화"),
        Category(id: 6, name: "뷰티/미용"),
        Category(id: 7, name: "남성패션/잡화"),
        Category(id: 8, name: "생활/식품"),
        Category(id: 9, name: "가구"),
        Category(id: 10, name: "도서/티켓/취미"),
        Category(id: 11, name: "기타"),
        ]
        
        self.cellData = Driver.just(categories) //이렇게 만들어둔 데이터는 cellData에 Driver로 전달한다.
        
        self.itemSelected
            .map { categories[$0] } //categories형식으로 전달된 row에 해당하는 카테고리가 무엇인지로 변환한다.
            .bind(to: selectedCategory) //값을 외부로 전달하는 selectedCategory에 바인드하면 외부에서는 selectedCategory만 확인해도 선택된 최신값의 카테고리를 알 수 있다.
            .disposed(by: disposeBag)
        
        self.pop = itemSelected
            .map { _ in Void() } //어떤 값이 선택되었든 Void값으로 변환해서
            .asSignal(onErrorSignalWith: .empty()) //이 값을 또 Signal로 변환한다. 에러가 생겼을 경우 empty를 내보낸다.
    }
}
