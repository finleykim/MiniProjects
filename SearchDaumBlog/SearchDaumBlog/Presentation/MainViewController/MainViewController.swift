//
//  MainViewController.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/03.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit





class MainViewController: UIViewController{
    let disposeBag = DisposeBag()
    let searchBar = SearchBar() //서치바 불러오기
    let listView = BlogListView() //테이블뷰 불러오기
    let alertAcitonTapped = PublishRelay<AlertAction>()
    //어떤 알럿액션이 선택되었고, 그 액션을 눌렀을 때 어떤 스타일을 취하는지 설명하고있는 AlertAction을 담는다.
    
    //let listView
    //let searchBar
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind() //이벤트바인딩
        attribute() //view커스텀
        layout() //snapkit 레이아웃
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind(){ //필터링버튼을 알럿으로 전환
        let alertSheetForSorting = listView.headerView.sortButtonTapped //filter버튼이 탭되었을 때,
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
                // ㄴ presentAlertControll의 파라메터
            }
        
        alertSheetForSorting
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest{ alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertControll(alertController, actions: alert.actions)
            }
            .emit(to: alertAcitonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        
        title = "다음 블로그 검색"
        view.backgroundColor = .white
    }
    
    private func layout(){
        [searchBar, listView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide) //navigationbar아래에 위치
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


//Alert

extension MainViewController{
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible{
        case title, datetime, cancel
        case confirm
        
        var title: String{
            switch self{
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        var style: UIAlertAction.Style{
            switch self{
            case .title, .datetime:
                return .default
                
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    func presentAlertControll<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action>{ //프로토콜 부여. AlertActionConvertible로 무엇인가를 하고, Signal로 반환
        if actions.isEmpty { return .empty() }
        return Observable
            .create {[weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions { //action을 받을 때 마다 alertController가 addAction한다
                    alertController.addAction(
                        UIAlertAction(title: action.title, style: action.style, handler: { _ in
                            observer.onNext(action)
                            observer.onCompleted()
                        })
                    )
                }
                self.present(alertController, animated: true, completion: nil)
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty()) //signal로 변환
    }
}
