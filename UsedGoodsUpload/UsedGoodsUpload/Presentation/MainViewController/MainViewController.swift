//
//  MainViewController.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController{
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: MainViewModel){
        
    }
    
    private func attribute(){
        title = "중고거래 글쓰기"
        view.backgroundColor = .white
        
        submitButton.title = "제출"
        submitButton.style = .done
        
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView() //셀이 끝났을 때 더이상 세퍼레이터가 보이지 않게 푸터뷰를 만든다
        
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "TitleTextFieldCell")
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}


//알럿
typealias Alert = (title: String, message: String?) //이 알럿은 타이틀과 메시지를 갖는다
extension Reactive where Base: MainViewController{ //Base는 MainViewcontroller임
    var setAlert: Binder<Alert>{ //Alert을 전달받는 Binder를 setAlert이라는 이름으로 선언한다.
        return Binder(base) { base, data in //base는 곧 MainViewController고 Alert에 대한 데이터를 받는다
            //받은 base와 data는 아래와 같이 처리한다.
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert) //alertController는 이러한 형태의 UIAlertContoller임
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil) //handler에는 알럿을 클릭했을 때의 액션을 정의하는데 이 부분이 nil이면 그냥 꺼지는걸로 끝.
            alertController.addAction(action) //alertController에 위 정의한 액션을 추가한다.
            base.present(alertController, animated: true, completion: nil)//base(=MainViewController)가 alertController를 띄울 수 있게한다.
        }
    }
}
