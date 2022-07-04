//
//  CategoryListViewController.swift
//  UsedGoodsUpload
//
//  Created by Finley on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CategoryListViewController: UIViewController{
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CategoryViewModel){
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in //items를 사용하면 tableView의 escaping클로저를 구현할 수 있다(함수실행이 종료된 후 어떻게 표현할지). tv(tableView), row, data의 표현을 정의한다.
                let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0)) //CategoryListCell은 그냥 내가 지금 여기서 이름을 정한 셀임(기본 UITableViewCell.self 정도로 생각해도 됨). row값만 전달할 것이기 때문에 section은 하나. 즉, 0
                
                cell.textLabel?.text = data.name
                return cell
            }
            .disposed(by: disposeBag)
        
        //itemSelected(뷰모델에있는 애. 어떤 카테고리를 선택했는지 row값을 받아낸다)연결.
        tableView.rx.itemSelected //row값 불러오기
            .map { $0.row } //로우 하나의 값만 필요하기때문에 row의 Int값만 받도록 변환
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    private func layout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
