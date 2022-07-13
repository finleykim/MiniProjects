//
//  DetailListBackgroundViewModel.swift
//  FindCVS
//
//  Created by Finley on 2022/07/13.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    //viewModel -> view
    let isStatusLabelHidden: Signal<Bool> //리스트에 데이터가 있다면 숨겨져야하고, 데이터가 없다면 숨겨져야하는 이벤트전달
    
    //외부에서 전달받을 값
    let shouldHideStatusLabel = PublishSubject<Bool>() //리스트에 데이터가 있는지 없는지를 알려줄 값
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel //외부에서 전달된 값을 통해 가져올것이고,
            .asSignal(onErrorJustReturn: true) // 만약 에러가 생겼을 경우, hidden값을 true로 전달할 것이다.
    }
}
