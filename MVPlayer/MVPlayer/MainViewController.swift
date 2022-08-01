//
//  ViewController.swift
//  MVPlayer
//
//  Created by Finley on 2022/07/27.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController{
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: MainViewModel){
        
    }
    
    private func attribute(){
        navigationItem.title = "MVPlayer"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
    }
    
    private func layout(){
        [tableView].forEach{
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaInsets)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension MainViewController{
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else { return UITableViewCell() }
        cell.thumbnail.image = UIImage(systemName: "music.note")
        cell.thumbnail.backgroundColor = .lightGray
        cell.singerName.text = "BTS"
        cell.songTitle.text = "Butter"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PlayerViewController()
        self.present(viewController, animated: true)
    }
}

