
import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotice()
        
        
    }
    
    
}

extension ViewController {
    func getNotice() {
        guard let remoteConfig = remoteConfig else { return }
        //페칭
        remoteConfig.fetch {[weak self] status, _ in
            //status가 성공이라면(값을 잘 가져왔다면) 원격구성값을 active한다. 실패일경우 해당문자열출력
            if status == .success {
                remoteConfig.activate(completion: nil)
            } else {
                print("Config not fetched")
            }
            
            guard let self = self else { return }
            if !self.isNoticeHidden(remoteConfig) { //isNoticeHidden의 값이 true가 아니라면(즉, 표시되는 상태라면)
                //NoticeViewController 창 띄우기 (+nib파일)
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                                                            // ㄴ nib파일명
                //modal스타일 설정
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                //Firebase에 설정한 값 표시하기, 줄바꿈설정
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                //NoticeViewController의 튜플에 위 프로퍼티값 할당
                noticeVC.noticeContents = (title: title, detail: detail, date: date)
                self.present(noticeVC, animated: true, completion: nil)
            }
        }
    }
    
    //공지사항 표시여부결정
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        //isHidden이라는 키의 boolValue를 반환한다
        return remoteConfig["isHidden"].boolValue
                            // ㄴ 키값
    }
}



