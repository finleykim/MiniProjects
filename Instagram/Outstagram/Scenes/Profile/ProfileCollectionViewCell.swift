//
//  ProfileCollectionViewCell.swift
//  Outstagram
//
//  Created by Finley on 2022/05/09.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    func setup(with image: UIImage){
        addSubview(imageView)
        imageView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        imageView.backgroundColor = .red
    }
}
