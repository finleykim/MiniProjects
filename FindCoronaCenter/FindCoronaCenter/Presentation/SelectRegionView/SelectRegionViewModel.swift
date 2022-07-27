//
//  SelectRegionViewModel.swift
//  FindCoronaCenter
//
//  Created by Finley on 2022/07/27.
//

import Foundation
import Combine

class SelectRegionViewModel: ObservableObject{ //ObservableObject는 Combine에서 제공하는 기능이며. 외부에서 바라볼 수 있는 오브젝트임을 의미한다.
    @Published var centers = [Center.Sido: [Center]]() //어떤객체를 내보낼지 표현 -> Sido이름, 접종센터갯수를 딕셔너리로 표현한다
    private var cancellables = Set<AnyCancellable>() //disposeBag
    
    init(centerNetwork: CenterNetwork = CenterNetwork()) { //CenterNetwork를 받아 통신을 통해 데이터를 받아온다
        centerNetwork.getCenterList()
            .receive(on: DispatchQueue.main) //뷰에 표시되어야하기때문에 메인에 receive한다
            .sink( //sink(subScribe의 역할)
                receiveCompletion: {[weak self] in
                    guard case .failure(let error) = $0 else { return } //실패할 경우 (실패가아니라면 return)
                    print(error.localizedDescription) //localDescription을 출력하고
                    self?.centers = [Center.Sido: [Center]]() //받은딕셔너리(비어있는딕셔너리)그대로 가져옴
                },
                receiveValue: {[weak self] centers in //정상적으로 값을 받았을 경우
                    self?.centers = Dictionary(grouping: centers) { $0.sido }
                    //grouping키워드를 사용해 받은 값의 sido별 데이터를 centers라는 이름으로 그룹핑한다.
                }
            )
            .store(in: &cancellables)   //disposed(by: disposeBag)
    }

}
