
import UIKit

class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
private var diaryList = [Diary]()
    
   
    override func viewDidLoad() {
            super.viewDidLoad()
            self.configureCollectionView()
        self.loadStarDiaryList()
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
    
    //데이터가 동기화되면 데이터를 불러오는시점
  
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
       
        self.collectionView.reloadData()
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification){
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
                self.diaryList.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let diary = starDiary["dairy"] as? Diary else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        if isStar{
            self.diaryList.append(diary)
            self.diaryList = self.diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        } else{
            guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
            self.diaryList.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    
    
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    

    
    
    private func loadStarDiaryList(){
        //UserDefaults에 접근
        let userDefaults = UserDefaults.standard
        //일기장리스트가져오기
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String : Any]] else { return }
                                            // ㄴ object메서드는 Any타입으로 리턴되기 때문에 String으로 타입캐스팅하고 바인딩한다
        //불러온 데이터 다이어리 리스트에 추가
        self.diaryList = data.compactMap{
                        // compactMap메서드로 diary타입이 되도록 매핑
            //축약인자로 딕셔너리에접근
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
                                // ㄴ title키로 딕셔너리의 값을 가져온다
                                         // ㄴ 딕셔너리가 any타입이기 때문에 string으로 타입변환
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            //diary타입이되도록 인스턴스화
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        }//불러온 다이어리 리스트를 filter고차함수을 이용해서 즐겨찾기된 일기만 가져오게한다
        .filter({
            $0.isStar == true
        })//최신순으로 정렬
        .sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
}


extension StarViewController: UICollectionViewDataSource{
    // 필수메서드 numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //즐겨찾는 일기의 갯수만큼 셀 표시
        return self.diaryList.count
        
    }
//필수메서드 cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //스토리보드에 구성한 셀 가져와서 재활용 dequeueReusableCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath)
                as? StarCell else { return UICollectionViewCell() }
            // ㄴ StarCell로 다운캐스팅하고 캐스팅에 실패할경우 비어있는 셀(UICollectionViewCell)로 반환
        //일기들이 저장되어있는 배열에 indexPath.row으로 접근해 일기를 가져온다
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }

}

extension StarViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
                        // ㄴ 아이폰의 너비값 = 셀의 너비값   // ㄴ 양옆 여백간격만큼 제외
    }
}


extension StarViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
  
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}



