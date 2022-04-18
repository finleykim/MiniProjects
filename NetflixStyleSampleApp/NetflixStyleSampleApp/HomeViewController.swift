//
//  HomeViewController.swift
//  NetflixStyleSampleApp
//
//  Created by Finley on 2022/04/18.
//

import UIKit

class HomeViewController: UICollectionViewController{
    var content : [Content] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //네비게이션바 설정
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
    }
    
    
}
