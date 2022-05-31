//
//  RepositoryListViewController.swift
//  GitHubRepository
//
//  Created by Finley on 2022/05/31.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryListViewController: UITableViewController{
    private let organization = "Apple"
    
    //private let repositories = [Repository] //기존방식
    private let repositories = BehaviorSubject<[Repository]>(value:[]) //Repository타입 , 초기값 비워둠
    private let disposeBag = DisposeBag() //DisposeBag선언
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = organization + "Repositories"
        
        //refreshControl 설정
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침") //indicator아래 문자
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) //refreshcontrol실행 시 액션
        
        //cell register
        tableView.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
        tableView.rowHeight = 140
    }
    @objc func refresh(){
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else { return }
            self.fetchRepositories(of: self.organization)
            
        }
    }
    
    func fetchRepositories(of organization: String){ //원활한 유지보수를 위해 따로 빼둔 organization을 받는다
        Observable.from([organization])
        //파라미터를 받아 적용
            .map { organization -> URL in //organization값이 들어오면 URL로 바꾼다
                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
        //url을 URLRequest로 변환
            .map{ url -> URLRequest in //url타입을 받아 URLRequest로 반환한다
                var request = URLRequest(url: url) //url은 내가 받은 url
                request.httpMethod = "GET" //URLRequest의 httpMethod메서드는 "GET"임 (GitHub의 API문서참조)
                return request
            }
        //URLRequest를 받아서 Observable타입으로 변환
            .flatMap{ request -> Observable<(response: HTTPURLResponse, data: Data)> in //HTTPURLResponse과 Data를 갖는 튜플형태의 Observable로 변환
                return URLSession.shared.rx.response(request: request) //rx는 swift에서 제공하는 인자를 rx로 변환한다.
                    //즉,response가 request(URLrequest)를 받아서 위에 선언해둔 Observable형태로 변환될 수 있도록한다.
            }
        //제대로된 응답과 에러 걸러내기
            .filter{ responds, _ in
                return 200..<300 ~= responds.statusCode //정상적인응답(200..<300)일 때만 넘겨받는다
            }
        //filter만 했기 때문에, flatMap에서 전달하는 결과값과 동일한 형태의 튜플을 전달한다. 그 데이터를 tableView에 올릴 수 있도록 손질하는 과정
            .map{ _, data -> [[String : Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else { //데이터의 생김새가 [[String: Any]]임을 알려준다.
                    return [] //안되겠으면 빈 어레이 반환
                }
                return result
            }
        //결과값을 제대로 풀지 못하면 빈 어레이가 반환되는데 그 결과값을 무시하도록 필터링해야함
            .filter{ result in
                return result.count > 0
            }
        //filter를 통과한 데이터를 Repository Entity에 저장
            .map { objects in //objects는 [[String: Any]]와 동일한 표현
                return objects.compactMap{ dic -> Repository? in //딕셔너리를 푸는 과정에서 디코딩오류가 나오면 닐을 배출하고, 컴팩트맵은 닐을 제거하는 역할을한다.
                    guard let id = dic["id"] as? Int, //id라는 키값을 가진 데이터를 id라고 정의
                          let name = dic["name"] as? String, //name이라는 키값을 가진 데이터를 name이라고 정의
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
            }
            .subscribe(onNext:{ [weak self] newRepositories in //구독
                self?.repositories.onNext(newRepositories)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing() //데이터 받아온 후 refreshing 종료
                }
            })
            .disposed(by: disposeBag)
    }
}

//UITableViewDelegate
extension RepositoryListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do{
            return try repositories.value().count
        } catch{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell") as? RepositoryListCell else { return UITableViewCell()}
        var crrentRepo: Repository?{
            do {
                return try repositories.value()[indexPath.row]
            } catch{
                return nil
            }
        }
        

        cell.repository = crrentRepo
        
        return cell
    }
}
