//
//  BlogList.swift
//  SearchDaumBlog
//
//  Created by Finley on 2022/06/03.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class BlogListView: UITableView{
    let disposeBag = DisposeBag()
    
    let headerView = FilterView( //FilterView불러오기
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        )
    )
    
    //MainViewController의 네트워크 작업을 통해 받아온 데이터를 BlogListView로 받아와야 셀과 뷰에 표현할 수 있다.
    let cellData = PublishSubject<[BlogListCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items){ tv, row, data in
                let index = IndexPath(row: row, section: 0) //첫번째 섹션에 전달받는 row에 따라 index가 만들어진다
                let cell = tv.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as!
                BlogListCell
                cell.setData(data) //PublishSubject가 Array형태로 데이터를 전달하면 row에 따라 그 데이터를 하나씩 꺼낸다.
                
                return cell
            }
    }
    
    private func attribute(){
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell") //cell레지스터
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
         
    }
    
}
