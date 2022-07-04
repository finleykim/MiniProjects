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
        let blogResult = searchBar.shouldLoadResult //searchBar의 텍스트를 밖으로 전달하는 
            .flatMapLatest{ query in
                SearchBlogNetwork().searchBlog(query: query) //searchBlog는 검색텍스트로 네트워크를 수행하는 메서드
            } //searchBar의 텍스트가 클로저의 매개변수 query를 통해 searchBlog의 매개변수 query를 채운다.
            //즉, searchBar의 텍스트를 네트워크수행 메서드에 넣어서 통신한다.
            .share() //스트림을 계속해서 새로만들지 않고 공유할 수 있게 함
        
        
            //BlogResult는 제대로된 값을 내보내거나 애러를 내보낼 것이기 때문에 그 두가지 경우를 아래와 같이 정의한다.
        let blogValue = blogResult
            .compactMap{ data -> DKBlog? in
                guard case .success(let value) = data else { //result
                    return nil
                }
                return value //성공하면 value를 꺼내온다.
            }
        
        let blogError = blogResult
            .compactMap{ data -> String? in
                guard case .failure(let error) = data else{
                    return nil
                }
                return error.localizedDescription //실패하면 스트링으로 에러를 뱉는다
            }
        
        //네트워크를 통해 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map{ blog -> [BlogListCellData] in //받아온 blog값을 BlogListCellData로 만든다
                return blog.documetns //DKBlog의 documents
                    .map{ doc in //매개변수는 documetns
                        let thumbnailURL = URL(string: doc.thumbnail ?? "")
                        return BlogListCellData(thumbnailURL: thumbnailURL, name: doc.name, title: doc.title, detetime: doc.datetime)
                    }
                
            }

        
        //FilterView를 선택했을 때 나오는 alertsheet를 선택했을 때 type
        let sortedType = alertAcitonTapped
            .filter{
                switch $0{
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        //MainViewController -> ListView
        //cellData와 sortedType 두 옵저버블을 합쳐야한다.
        Observable
            .combineLatest(
                sortedType, //가장 최신의 Type을 받아서
                cellData //가장 최신의 cellData를 조합해 정렬한다
            ) { type, data -> [BlogListCellData] in
                switch type {
                case .title:
                    return data.sorted { $0.title ?? "" < $1.title ?? "" }
                case .datetime:
                    return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
                case .cancel, .confirm:
                    return data
                }
            }
            .bind(to: listView.cellData) //cellData에 바인드한다
            .disposed(by: disposeBag)
        
        
        let alertSheetForSorting = listView.headerView.sortButtonTapped //filter버튼이 탭되었을 때,
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
                // ㄴ presentAlertControll의 파라메터
            }
        //에러메시지가 알럿에 뜨도록
        let alertForErrorMessage = blogError
            .map { message -> Alert in
                return (
                    title: "앗",
                    message: "예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요. \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        //알럿을 정렬할 때, 에러가 발생했을 때 두가지 경우 모두 설정한 알럿이 뜨도록 설정
        Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
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
