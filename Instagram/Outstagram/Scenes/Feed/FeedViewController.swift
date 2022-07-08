//
//  ViewController.swift
//  Outstagram
//
//  Created by Finley on 2022/05/08.
//

import UIKit
import SnapKit



class FeedViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none //separator없음으로 설정
        tableView.dataSource = self
        
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")

        return tableView
    }()
    
    //imagePicker
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary //camera로도 설정 가능
        imagePickerController.allowsEditing = true //수정권한추가
        imagePickerController.delegate = self

        return imagePickerController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        
    }
}


extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //didFinishPickingMediaWithInfo - 사진을 선택한 뒤에 작동하는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectImage: UIImage?

        //수정된 이미지가 존재할 때는 수정된이미지 적용, 수정되지 않았을 경우 원본이미지적용
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImage = originalImage
        }

        picker.dismiss(animated: true) { [weak self] in
            let uploadViewController = UploadViewController(uploadImage: selectImage ?? UIImage())
            let navigationController = UINavigationController(rootViewController: uploadViewController)
            navigationController.modalPresentationStyle = .fullScreen

            self?.present(navigationController, animated: true)
        }
    }
}

extension FeedViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //임의
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell
        cell?.selectionStyle = .none
        cell?.setup()
        
        return cell ?? UITableViewCell()
    }
    
    
}

private extension FeedViewController{
    func setupNavigationBar(){
        navigationItem.title = "Instagram"
        
        let uploadButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(didTapUploadButton))
        navigationItem.rightBarButtonItem = uploadButton
    }
    
    
    @objc func didTapUploadButton(){
        //picker present
        present(imagePickerController, animated: true)
    }
    
    //addSubView
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
