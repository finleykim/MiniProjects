//
//  DetailHeaderView.swift
//  AppStrore
//
//  Created by Finley on 2022/05/05.
//

import UIKit
import SnapKit

 class DetailHeaderView : UIView {
    var todayList : [Today] = []
    static var height: CGFloat { 170.0 }

    
    

    
    private lazy var mainImage : UIImageView = {
       let mainImage = UIImageView()
        mainImage.backgroundColor = .yellow
        mainImage.layer.cornerRadius = 8
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
        
        
        return mainImage
    }()


   public let titleLabel : UILabel = {
        let titleLable = UILabel()
        
        titleLable.textColor = .label
        titleLable.font = .systemFont(ofSize: 20, weight: .bold)
      
       
        
        return titleLable
    }()
    
    
    public let subTitleLable : UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        
        return subTitleLabel
    }()
    
    private lazy var downloadButton : UIButton = {
        let downloadButton = UIButton()
        downloadButton.backgroundColor = .systemBlue
        downloadButton.layer.cornerRadius = 12
        downloadButton.setTitle("받기", for: .normal)
        downloadButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        downloadButton.setTitleColor(.white, for: .normal)
        
        return downloadButton
    }()
    
    private lazy var shareButton : UIButton = {
       let shareButton = UIButton()
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .systemBlue
//        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        
        return shareButton
    }()
    
//     @objc func didTapShareButton() {
//         let actityItems: [Any] = [today.title]
//         let activityViewController = UIActivityViewController(activityItems: actityItems, applicationActivities: nil)
//         present(activityViewController, animated: true)
//     }
//
    private let separatorView = SeparatorView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}






extension DetailHeaderView{
    func setupLayout(){
        [
            mainImage,
            titleLabel,
            subTitleLable,
            downloadButton,
            shareButton,
            separatorView
        ].forEach{ addSubview($0) }
        
        mainImage.snp.makeConstraints{
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(100.0)
            $0.width.equalTo(mainImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(mainImage.snp.top)
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
         
        subTitleLable.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            
        }
        
        downloadButton.snp.makeConstraints{
            $0.width.equalTo(60)
            $0.height.equalTo(32)
            $0.leading.equalTo(subTitleLable.snp.leading).offset(16)
            $0.bottom.equalTo(mainImage.snp.bottom)
        }
        
        shareButton.snp.makeConstraints{
            $0.height.equalTo(32)
            $0.width.equalTo(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(downloadButton.snp.bottom)
            
        }

        
        separatorView.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(shareButton.snp.bottom).offset(32)
            
        }
        
    }
}

