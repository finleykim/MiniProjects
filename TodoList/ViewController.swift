//
//  ViewController.swift
//  TodoList
//
//  Created by Finley on 2022/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task](){
    didSet{
        self.saveTasks() //tasks배열에 할 일이 추가될 때 마다 userDefaults에 저장된다.
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.loadTasks()
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        //알럿을 표시
        let alert = UIAlertController(title: "할 일 등록", message: nil , preferredStyle: .alert)
        //알럿버튼을 눌렀을 때 파라미터에 정의된 클로저함수가 호출되기 때문에 사용자가 알럿버튼을 눌렀을 때 실행해야할 행동을 handler 클로저에 정의
                                                                                //[weak self]강한순환참조를 방지하기위해 weak 키워드를 사용해 캡쳐목록을 작성하는 작업
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: {[weak self] _ in
            //등록버튼을 눌렀을 때 텍스트필드의 텍스트를 가져올 수 있게 만드는 클로저를 registerButton handler 클로저에 입력
            guard let title = alert.textFields?[0].text else { return }//0번째 인덱스로 배열에 접근해서 텍스트필드에 접근되도록하고, 텍스트 프로퍼티를 이용해서 텍스트필드에 입력된 값이 무엇인지 가져오도록 코드작성하였음. & textField가 옵셔널이므로 guard구문을 사용해 옵셔널 바인딩으로 title프로퍼티 생성하여 작성한코드alert.textFields?[0].text를 할당
            //debugPrint("\(alert.textFields?[0].text)") 제대로 작동하는지 출력해서 확인해볼 수 있음
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
       //취소버튼생성
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil) //취소버튼을 누르면 별다른 액션을 취하지 않을 것이기 떄문에 handler : nil
        
        //함수호출 후 정의한 불변프로퍼티를 매개변수로 넣어준다
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        
        //알럿에 할일을 입력할 텍스트필드 삽입           //알럿을 표시하기 전에 텍스트필드를 구성하기위한 클로저(반환값없음, 텍스트필드의 객체에 해당하는 단일 매개변수를 사용)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "할 일을 입력해주세요 "})
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveTasks(){
        //할 일들(tasks 배열)을 Dictionary형태로 userDefaults에 저장한다
        let data = self.tasks.map{
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks(){       //UserDefaults에 접근
        let userDefaults = UserDefaults.standard
        //UserDefaults에 저장된 할일들을 불러오기  .object : 저장된 데이터를 로드하는 키워드
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        // ㄴ forkey파라미터에는 데이터를 저장할 때 설정한 키 값을 입력한다
        // ㄴ object메서드는 Any타입으로 반환되기때문에 Dictionary배열형태로 타입캐스팅한다
        // ㄴ 타입캐스팅에 실패하면 nil값이 반환될 수 있기때문에 guard문으로 작성한다.
    
        self.tasks = data.compactMap{
            // ㄴ 데이터를 배열에 저장한다  ㄴ Task타입의 배열이 되도록 매핑
            guard let title = $0["title"] as? String else { return nil }
                            // ㄴ 축약인자로 Dictionary에 접근
                                            // ㄴ 타입캐스팅을 사용해 String 타입으로 변환
            
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done) // Task타입으로 인스턴스화하는 반환
        }
       
    }
}





extension ViewController: UITableViewDataSource{
    //numberOfRowsInSection : 표시할 행의 갯수를 묻는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    //특정 섹션의 n번째 row를 그리는데 필요한 셀을 반환하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //dequeueReusableCell: 지정된 재사용 식별자(withIdentifier파라미터)에대한 재사용 가능한 테이블뷰 셀 객체를 반환하고 이를 테이블뷰에 추가하는 역할을 하는 메서드. 메모리낭비 방지
        //for: indexPath : 필요에의해 재사용을 계속한다는 의미
      
        //배열에 저장되어있는 할일 요소들을 가져온다
        let task = self.tasks[indexPath.row]
        //cellForRawAt의 파라미터인 indexPath는 tableview에서 cell위치를 나타내는 인덱스이다. 섹션과 로우 속성으로 지정되어있다.
        //indexPath에서 섹션이 0이고 로우도 0이라면 가장위에 보이는 셀의 위치를 의미하는데, numberOfRowsInSection에 tasks의 갯수만큼 row가 있다고 정의했으므로,indexPath.row는 0 ~ tasks의 갯수를 의미한다.
        cell.textLabel?.text = task.title //cell의 텍스트라벨 텍스트에 task.title을 보여준다
        return cell
    }
}
