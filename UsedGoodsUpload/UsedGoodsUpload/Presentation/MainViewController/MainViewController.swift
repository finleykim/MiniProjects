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
    
    func bind(_ viewModel: MainViewModel){ //뷰모델에서 전달받은 cellData, presentAlert, push에 대한 바인드
        //MARK: ViewModel -> View
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in //테이블 로우 데이터로 전달한다.
                switch row { //로우에따라 보여질 셀이 다 다르기때문에 스위치문을 사용한다
                case 0:
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: "TitleTextFieldCell", //MainViewModel에 각각의 셀을 정의해두었다. ( 그 셀을 dequeueReusable하는것.
                        for: IndexPath(row: row, section: 0)
                    ) as! TitleTextFieldCell
                    cell.selectionStyle = .none
                    cell.titleInputField.placeholder = data
                    cell.bind(viewModel.titleTextFieldCellViewModel)
                    return cell
                case 1:
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: "CategorySelectCell",
                        for: IndexPath(row: row, section: 0)
                    )
                    cell.selectionStyle = .none
                    cell.textLabel?.text = data
                    cell.accessoryType = .disclosureIndicator
                    return cell
                case 2:
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: "PriceTextFieldCell",
                        for: IndexPath(row: row, section: 0)
                    ) as! PriceTextFieldCell
                    cell.selectionStyle = .none
                    cell.priceInputField.placeholder = data
                    cell.bind(viewModel.prieTextFieldCellViewModel)
                    return cell
                case 3:
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: "DetailWriteFormCell",
                        for: IndexPath(row: row, section: 0)
                    ) as! DetailWriteFormCell
                    cell.selectionStyle = .none
                    cell.contentInputView.text = data
                    cell.bind(viewModel.detailWriteFormCellViewModel)
                    return cell
                default:
                    fatalError() //또다른 셀이 보여진다면 fataError를 낸다.
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.presentAlert //뷰모델이 뷰에게 지금알럿을 띄워! 라고하면 emit으로 알럿띄우는 이벤트를 방출한다.
            .emit(to: self.rx.setAlert) //extension에 만들어둔 알럿셋팅
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { viewModel in //드라이브의 onNext를 통해 구현한다. 뷰모델을받는다.
                let viewController = CategoryListViewController()
                viewController.bind(viewModel)
                self.show(viewController, sender: nil)
            })
            .disposed(by: disposeBag)
        
        //MARK: View -> ViewModel
        tableView.rx.itemSelected //테이블뷰의 셀이 선택되었는지여부
            .map { $0.row } //로우값전달
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap //submitButton이 탭되었는지 여부
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: disposeBag)
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
        //index row 0
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "TitleTextFieldCell")
        //index row 1
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategorySelectCell")
        //index row 2
        tableView.register(PriceTextFieldCell.self, forCellReuseIdentifier: "PriceTextFieldCell")
        //index row 3
        tableView.register(DetailWriteFormCell.self, forCellReuseIdentifier: "DetailWriteFormCell")
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
