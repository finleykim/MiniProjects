//
//  ViewController.swift
//  MLKit
//
//  Created by Finley on 2022/07/20.
//

import UIKit

class MainViewController: UIViewController {

    let image = UIImageView()
    let label = UILabel()
    let button = UIButton()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(buttonTapped))
        
        label.text = "인식된 텍스트가 없습니다"
        label.textColor = .black
        
        button.setTitle("텍스트추출", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        
        imagePicker.delegate = self
    }
    
    @objc func buttonTapped(){
        present(imagePicker, animated: true)
    }
    
    private func layout(){
        
        [image,label,button].forEach{
            view.addSubview($0)
        }
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: 150).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension MainViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                   selectImage = editedImage
               } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   selectImage = originalImage
               }
        
        picker.dismiss(animated: true)
        image.image = selectImage
    }
}
