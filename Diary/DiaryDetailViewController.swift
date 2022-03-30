//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Finley on 2022/03/25.
//

import UIKit



class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    var starButton: UIBarButtonItem?
    
    //일기장디테일데이터를 전달받을 프로퍼티
    var diary: Diary?
    var indexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil
        )

    }
    
    //프로퍼티를 통해 전달받은 다이어리객체를 뷰에 초기화
    private func configureView(){
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
        
        
    }

    
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        //수정할 다이어리객체 전달 DiaryDetailViewController -> WriteDiaryViewController
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else { return }
        //guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
    }
    
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        if diary.uuidString == uuidString{
            self.diary?.isStar = isStar
            self.configureView()
        }
        
    }
    
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        //guard let indexPath = self.indexPath else { return }
        //삭제버튼이 눌려지면 전 화면으로 이동
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"),
                                        object: uuidString,
                                        //object: indexPath,
                                        userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapStarButton(){
        guard let isStar = self.diary?.isStar else { return }
        if isStar{
            self.starButton?.image = UIImage(systemName: "star")
        } else{
                self.starButton?.image = UIImage(systemName: "star.fill")
            }
            //ture이면false, false이면 true대입
            self.diary?.isStar = !isStar
        NotificationCenter.default.post(name: NSNotification.Name("starDiary"),
                                        object: [
                                            "diary": self.diary,
                                            "isStar": self.diary?.isStar ?? false,
                                            "uuidString": diary?.uuidString
                                            //"indexPath": indexPath
                                        ],
                                        userInfo: nil)
        //self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
      
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}




