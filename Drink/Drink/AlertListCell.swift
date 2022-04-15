
import UIKit
import UserNotifications

class AlertListCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()
    

    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }
    
    @IBAction func alertSwitchValueChange(_ sender: UISwitch) {
        //UserDefaults에 있는 alerts키의 값을 가지고 나온다
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }
        
        //배열에 있는 값 중에 isOn값을 sender(지금 이 메서드의 매개변수)의 isOn값으로 넘겨준다
        alerts[sender.tag].isOn = sender.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        if sender.isOn { //스위치가 켜져있을경우
            //알럿의 여러 배열에서 해당 셀의 스위치만 온으로변경해서 Notification에 추가
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else { //스위치를 끌경우
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
     
}
