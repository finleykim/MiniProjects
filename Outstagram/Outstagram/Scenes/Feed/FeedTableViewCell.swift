//
//  FeedTableViewCell.swift
//  Outstagram
//
//  Created by Finley on 2022/05/08.
//

import SnapKit
import UIKit


class FeedTableViewCell: UITableViewCell{
    //프로퍼티정의
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiaryLabel
        
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(systemName: "heart")
        
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "message"), for: .normal)
        button.setImage(systemName: "message")
        
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "papaerPlane"), for: .normal)
        button.setImage(systemName: "paperPlane")
        
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(systemName: "bookmark")
        
        return button
    }()
    
    private lazy var currentLikedCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        label.text = "bbabye_y님 외 32명이 좋아합니다."
        
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.numberOfLines = 5 //최대 라인 수 지정
        label.text = "동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라만세 ."
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 11.0, weight: .medium)
        label.text = "1일 전"
        
        return label
    }()
    
    
    //셋업(오토레이아웃)
    func setup(){
        [
        postImageView,
        likeButton,
        commentButton,
        messageButton,
        bookmarkButton,
        currentLikedCountLabel,
        contentLabel,
        dateLabel
        ].forEach{ addSubview($0) }
        
        postImageView.snp.makeConstraints{ //정방형
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width)
        }
        
        let buttonWidth: CGFloat = 24
        let buttonInset: CGFloat = 16
        
        likeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(buttonInset)
            $0.top.equalTo(postImageView.snp.bottom).offset(buttonInset)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth)
        }

        let buttonSpacing: CGFloat = 12.0

        commentButton.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(buttonSpacing)
            $0.top.equalTo(likeButton.snp.top)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth)
        }

        messageButton.snp.makeConstraints {
            $0.leading.equalTo(commentButton.snp.trailing).offset(buttonSpacing)
            $0.top.equalTo(likeButton.snp.top)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(buttonInset)
            $0.top.equalTo(likeButton.snp.top)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth)
        }

        currentLikedCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.leading)
            $0.trailing.equalTo(bookmarkButton.snp.trailing)
            $0.top.equalTo(likeButton.snp.bottom).offset(14.0)
        }

        let labelVerticalSpacing: CGFloat = 8.0

        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.leading)
            $0.trailing.equalTo(bookmarkButton.snp.trailing)
            $0.top.equalTo(currentLikedCountLabel.snp.bottom).offset(labelVerticalSpacing)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.leading)
            $0.trailing.equalTo(bookmarkButton.snp.trailing)
            $0.top.equalTo(contentLabel.snp.bottom).offset(labelVerticalSpacing)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
}
