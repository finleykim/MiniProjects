//
//  ViewController.swift
//  Diary
//
//  Created by Finley on 2022/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }

    
    //diaryList에 일기가 추가되었으니 그 일기리스트를 collectionView에 보여주는 작업
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wireDiaryViewController = segue.destination as? WriteDiaryViewController {
            wireDiaryViewController.delegate = self
        }
    }
    
    //CollectionView(다이어리리스트)에 날짜를 문자열로 넘겨주기 위한 포메터
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}

extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        //셀에 일기의 제목과 날짜가 표시되게한다
        let diary = self.diaryList[indexPath.row]
        //일기제목표시
        cell.titleLabel.text = diary.title
        //날짜는 피커뷰선택으로 표시되기 때문에 이를 DateFormatter를 이용해 문자열로 만들어주어야한다.
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}


//CollectionView의 레이아웃 구성
extension ViewController: UICollectionViewDelegateFlowLayout{
    //sizeForItemAt메서드는 셀의 사이즈를 결정하는역할을하는 메서드. 표시할 셀의 사이즈를CGSize로 정의를하고 리턴하면 설정한 사이즈대로 표시된다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
                             // ㄴ UIScreen.main.bounds.width: 화면의 너비. 셀을 행당 2개씩 표시할 것이기때문에 나누기 2 그리고 UIEdgeInsets 에 설장한 left,right간격만큼 -20
    }
}



extension ViewController : WriteDiaryViewDelegate{
    func didSelectReigster(diary: Diary) {
        //일기리스트(diaryList프로퍼티)에 diary(작성한일기)를 추가한다
        self.diaryList.append(diary)
        //일기를 추가할 때 마다 리스트에 리로드시킨다
        self.collectionView.reloadData()
    }
}
