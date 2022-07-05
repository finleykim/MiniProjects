//
//  MainViewModel.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

struct MainViewModel{
    let titleTextFieldCellViewModel = TitleTextFieldCellViewModel()
    let prieTextFieldCellViewModel = PriceTextFieldCellViewModel()
    let detailWriteFormCellViewModel = DetailWriteFormCellViewModel()
    
    //ViewModel -> View
    let cellData: Driver<[String]> //MainViewController가 가진 셀데이터를 전달
    let presentAlert: Signal<Alert> //알럿이 띄워짐을 전달
    let push: Driver<CategoryViewModel> //카테고리셀을 누르면 CategoryViewController로 푸쉬(이동)되는 이벤트를 CategoryViewModel에 전달해서 바인딩
    
    //View -> ViewModel
    let itemSelected = PublishRelay<Int>() //아이템이 선택되었다
    let submitButtonTapped = PublishRelay<Void>() //제출버튼이 선택되었다
    
    init(model: MainModel = MainModel()){
        //MARK: 셀에 맨처음 표시되는 스트링 전달 (어떤것은 placeholder로, 어떤것은 title로 표시될것이다)
        let title = Observable.just("글제목")
        let categoryViewModel = CategoryViewModel()
        //카테고리는 카테고리 셀이 따로없고 뷰와 뷰모델이있다.
        let category = categoryViewModel //뷰모델선언
            .selectedCategory //선택된 카테고리를 표시할 수 있도록 데이터(Category)를 받아둔 뷰모델의 selectedCategory에서
            .map { $0.name } //그 데이터(Category)의 이름을 변환해 받아온다.
            .startWith("카테고리선택") //맨처음 시작엔 이 문자열로 표시
        let price = Observable.just("￦ 가격 (선택사항)")
        let detail = Observable.just("내용을 입력하세요")
        // title, category, price, detail을 combineLatest로 묶어서 cellData로 넘겨준다
        self.cellData = Observable
            .combineLatest(title,
                           category,
                           price,
                           detail) { [$0, $1, $2, $3] } //받은다음에는 어레이로 묶는다
            .asDriver(onErrorJustReturn: []) //드라이버로 전달하고 만약 에러가난다면 빈 어레이 표시
        
        //MARK: 알럿을 어느시점에 띄울지 세팅. 어떤 셀의 내용이 비어있느냐에 따라 알럿의 내용이 달라진다.
        let titleMessage = titleTextFieldCellViewModel
            .titleText
            .map { $0?.isEmpty ?? true } //아무 값도 입력하지 않았을 때는 true
            .startWith(true) //맨처음에는 아무값도 입력되어있지 않았을 것이기 때문에 true
            .map { $0 ? ["- 글 제목을 입력해주세요."] : [] } //true가 전달된다면 "글제목 .." false가 전달된다면(셀에 내용이있다면 비워둔다
        
        let categoryMessage = categoryViewModel
            .selectedCategory
            .map { _ in false }
            .startWith(true)
            .map { $0 ? ["- 카테고리를 선택해주세요."] : []}
        
        let detailMessage = detailWriteFormCellViewModel
            .contentValue
            .map { $0?.isEmpty ?? true }
            .startWith(true)
            .map { $0 ? ["- 내용을 입력해주세요."] : [] }
        
        let errorMessage = Observable
            .combineLatest(titleMessage, //가장최신(combineLatest)의 에러메시지를 받는다
                           categoryMessage,
                           detailMessage
            ) { $0 + $1 + $2 }
        
        self.presentAlert = submitButtonTapped
            .withLatestFrom(errorMessage) //withLatestFrom으로 errorMessage를 받는다.
        //errorMessage를 (title: String, message: String?)로 변환
            .map(model.setAlert)
            .asSignal(onErrorSignalWith: .empty())
        
        //MARK: 카테고리셀 탭했을 때 다른 뷰로 넘어가도록 세팅
        self.push = itemSelected //셀을 눌렀을 때(itemSelected)를 트리거로하여 push에 전달한다.
            .compactMap { row -> CategoryViewModel? in //여러가지 row가 선택될 때 마다 이벤트가 전달되지만, 이 row를 CategoryViewModel로 변경한다.
                guard case 1 = row else { //1이 row라면 받고 그렇지않다면 nil
                    return nil
                }
                return categoryViewModel //1번째 인덱스 즉, 2번째 셀이 맞다면 categoryViewModel을 전달
            }
            .asDriver(onErrorDriveWith: .empty()) //asDriver로 전달하고 에러가 있다면 empty
    }
}
