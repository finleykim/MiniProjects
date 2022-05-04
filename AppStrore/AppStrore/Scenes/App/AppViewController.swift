//
//  AppViewController.swift
//  AppStrore
//
//  Created by Finley on 2022/05/04.
//

import SnapKit
import UIKit


final class AppViewcontroller : UIViewController{
    //뷰 프로퍼티 선언뷰
    //1.scrollView
    private let scrollView = UIScrollView()
    //2.contentView
    private let contentView = UIView()
    //3.contentView가 표시해야하는 StackView
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        //세로스크롤
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        
        let featureSectionView = FeatureSectionView(frame: .zero)
        let rankingFeatureSectionView = RankingFeatureSectionView(frame: .zero)
        let exchangeCodeButtonView = ExchangeCodeButtonView(frame: .zero)
        
        let spacingView = UIView()
        spacingView.snp.makeConstraints{
            $0.height.equalTo(100.0)
        }


        
        [
            featureSectionView,
            rankingFeatureSectionView,
            exchangeCodeButtonView,
            spacingView
            
        ].forEach {
            
            stackView.addArrangedSubview($0)
        }
        
        
        return stackView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
    }
}

private extension AppViewcontroller{
    func setupNavigationController(){
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //autoLayout
    func setupLayout(){
        view.addSubview(scrollView)//view의 subView로 scrollView추가
        scrollView.snp.makeConstraints{ //scrollView의 레이아웃
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top) //네비게이션은 감안해서 safeAreaLayoutGuid의 top에 맞춘다
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        scrollView.addSubview(contentView) //scrollView의 subView로 contentView추가
        contentView.snp.makeConstraints{ //contentView의 레이아웃
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() //가로가 고정되어야 가로스크롤이 아닌 세로스크롤만 작동된다. 반대로 height를 설정하면 높이는 고정된 가로스크롤이 작동된다.
            
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            //height은 subView에 의해 결정되기때문에 지정하지 않는다.
            
        }
    }
}
