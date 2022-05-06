//
//  DetailHeaderSectionView.swift
//  AppStrore
//
//  Created by Finley on 2022/05/05.
//

import UIKit
import SnapKit

class DetailViewController : UIViewController{
    var detailHeaderView = DetailHeaderView()
    private let today: Today


    init(today: Today) {
        self.today = today

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        view.backgroundColor = .systemBackground
        self.detailHeaderView.setupLayout()
        self.detailHeaderView.titleLabel.text = "today.title"
        self.detailHeaderView.subTitleLable.text = "today.title"
        
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var stackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        let headerView = DetailHeaderView(frame: .zero)
        let descriptionView = UIView()
        

        descriptionView.backgroundColor = .blue
        
        [headerView,descriptionView].forEach{
            //$0.snp.makeConstraints{ $0.height.equalTo(400) }
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
   
    //Layout
    func setupLayout(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()

            
        }
    }
    
    
}
