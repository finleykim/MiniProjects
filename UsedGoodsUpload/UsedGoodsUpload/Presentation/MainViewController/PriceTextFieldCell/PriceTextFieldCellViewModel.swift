//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/05.
//

import RxSwift
import RxCocoa

class PriceTextFieldCellViewModel {
    //ViewModel -> View
    let showFreeShareButton: Signal<Bool> //무료나눔버튼이벤트
    let resetPrice: Signal<Void> //가격리셋이벤트
    
    //View -> ViewModel
    let priceValue = PublishRelay<String?>() //가격텍스트 받아냄
    let freeShareButtonTapped = PublishRelay<Void>() //무료나늠 버튼이 눌렸는지 이벤트받아냄
    
    //각각의 이벤트들이 어떻게 작용하게할지
    init() {
        self.showFreeShareButton = Observable//showFreeShareButton은 언제 표시할지
            .merge( //priceValue와 freeShareButtonTapped는 옵저버블의 merge로 합쳐서 세팅
                priceValue.map { $0 ?? "" == "0" }, //무료나눔
                freeShareButtonTapped.map { _ in false } //버튼이 눌렸다면, 숨겨라(false)
            )
            .asSignal(onErrorJustReturn: false) //만약에러가나면 숨겨
        
        self.resetPrice = freeShareButtonTapped //resetPrice세팅
            .asSignal(onErrorSignalWith: .empty()) //에러나면 그냥 숨겨라(.empty)
    }
    
}
