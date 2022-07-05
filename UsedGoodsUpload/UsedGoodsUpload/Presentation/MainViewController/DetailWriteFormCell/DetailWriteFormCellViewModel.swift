//
//  DetailWriteFormCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/05.
//

import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel{
    //View -> ViewModel
    let contentValue = PublishRelay<String?>() //셀의 텍스트를 전달받음
}
