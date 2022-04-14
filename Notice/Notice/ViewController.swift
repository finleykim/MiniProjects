
import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

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
            } else{
                self.showEventAlert()
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

//A/B testing
extension ViewController {
    func showEventAlert(){
        guard let remoteConfig = remoteConfig else { return }
        
        //패칭
        remoteConfig.fetch {[weak self] status, _ in
            if status == .success {
                remoteConfig.activate(completion: nil)
            } else {
                print("Config not fetched")
            }
            
            // message은 string값으로 전달되며 nil값일경우 비어있는 string전달
            let message = remoteConfig["message"].stringValue ?? ""
            // 확인버튼을 구성할 alert
            let confirmAction = UIAlertAction(title: "확인하기", style: .default) { action in
                Analytics.logEvent("promotion_alert", parameters: nil)
            }
            // 취소버튼구성. 단순히 알럿을 닫는 액션을 구성
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            // 두가지 액션(확인버튼, 취소버튼)을 포함하는 alertController구성
            let alertController = UIAlertController(title: "깜짝 이벤트", message: message, preferredStyle: .alert)
                                                                        // ㄴ 실험할 곳(remoteConfig에서 받은 값)// ㄴ 알럿시트와 알럿형태 중 알럿선택
            //컨트롤러에 액션추가
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            //현재가진 뷰 컨트롤러에서 알럿을 띄울 수 있도록 설정
            self?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
