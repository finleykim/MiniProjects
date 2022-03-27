//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Finley on 2022/03/25.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject{
    func didSelectDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: DiaryDetailViewDelegate?
    
    //일기장디테일데이터를 전달받을 프로퍼티
    var diary: Diary?
    var indexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

    }
    
    //프로퍼티를 통해 전달받은 다이어리객체를 뷰에 초기화
    private func configureView(){
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        
        
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
        //dictionary로 보낸
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
    }
    
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        //delegate에서 정의한 didSelectDelete메서드 호출
        self.delegate?.didSelectDelete(indexPath: indexPath)
        //삭제버튼이 눌려지면 전 화면으로 이동
        self.navigationController?.popViewController(animated: true)
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
