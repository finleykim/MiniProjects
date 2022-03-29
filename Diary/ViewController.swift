//
//  ViewController.swift
//  Diary
//
//  Created by Finley on 2022/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary](){
        //다이어리리스트배열에 변경이 일어날 때 마다(추가,삭제 등) UserDefaults에 저장
        didSet{
            self.saveDiaryLiest()
            
        }
        
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name("starDiary"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteDiaryNotification(_:)),
                                               name: NSNotification.Name("deleteDiary"),
                                               object: nil)
    }

    
    //diaryList에 일기가 추가되었으니 그 일기리스트를 collectionView에 보여주는 작업
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let indexPath = starDiary["indexPath"] as? IndexPath else { return }
        self.diaryList[indexPath.row].isStar = isStar

    }
    
    @objc func deleteDiaryNotification(_ notification: Notification){
            guard let indexPath = notification.object as? IndexPath else { return }
            self.diaryList.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wireDiaryViewController = segue.destination as? WriteDiaryViewController {
            wireDiaryViewController.delegate = self
        }
    }
    
    //saveDiaryLiest라는 메소드를 생성하여
    private func saveDiaryLiest(){
        //.map키워드를 이용하여 diaryList구조체의 값을 딕셔너리형태로 저장한다
        let date = self.diaryList.map{
                       // ㄴ Diary구조체를 할당받은 프로퍼티
            [
                "title" : $0.title,
                "contents" : $0.contents,
                "date" : $0.date,
                "isStar" : $0.isStar
            ]
        }
        //userDefaults에 접근할 수 있도록한다
        let userDefaults = UserDefaults.standard
        //userDefults의 set메서드호출
        userDefaults.set(date, forKey: "diaryList")
                        // ㄴ 위에 설정해둔 일기구조체가 저장되어있는 프로퍼티
    }
    
    
    private func loadDiaryList(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
                                              // ㄴ object는 Any타입으로 리턴되기때문에 dictionary타입으로 타입캐스팅하고, 타입캐스팅에 실패할 경우를 대비해 guard문으로 작성한다.
        //불러온 데이터를 다이어리 리스트 배열에 넣어준다
        self.diaryList = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
         
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

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

extension ViewController : WriteDiaryViewDelegate{
    func didSelectReigster(diary: Diary) {
        //일기리스트(diaryList프로퍼티)에 diary(작성한일기)를 추가한다
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        //일기를 추가할 때 마다 리스트에 리로드시킨다
        self.collectionView.reloadData()
    }
    
}










