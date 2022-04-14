
import UIKit


class AlertListViewController: UITableViewController{
    
    var alerts: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibname = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibname, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.alerts = alertList()
    }
    
    
    @IBAction func addAlertButtonAction(_ sender: Any) {
        //스토리보드의 addAlertViewController 인스턴스화
        guard let addAlertViewController = storyboard?.instantiateViewController(withIdentifier: "addAlertViewController") as? addAlertViewController else { return }
        //addAlertViewController로부터 전달받을 정보핸들링
        addAlertViewController.pickedDate = {[weak self] date in
            guard let self = self else { return }
         
          
            //자식뷰에 설정된 Alert값을 불러오기
            let newAlert = Alert(date: date, isOn: true)
            
            //UserDefaults의 정보를 받는동작을 하는 메서드(alertList) 불러오기
            var alertList = self.alertList()
            //데이터 추가
            alertList.append(newAlert)
            //시간순으로 재정렬
            alertList.sort { $0.date < $1.date}
            //구조체는 alertList
            self.alerts = alertList
            
            //인코딩 셋(추가된 값을 다시 Userdefaults에 저장)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            
            //테이블뷰 새로고침
            self.tableView.reloadData()
        }
        self.present(addAlertViewController, animated: true, completion: nil)
        }

    func alertList() -> [Alert]{
        //UserDefaults에서 키가 Alerts인 데이터를 내보낸다
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              //UserDefaults는 우리가 만든 정보를 이해할 수 없기때문에 JSON처럼 인코딩,디코딩해주어야한다.
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return []}
        return alerts
    }
        
    }
    
    

    
    


//UITableView Datasource,Deleagate
extension AlertListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0 :
            return "물 마실 시간"
        default:
            return nil
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
  
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        cell.alertSwitch.tag = indexPath.row
        return cell
    }
    
    //cell의 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //알림을 스와이프로 삭제하고, 셀을 삭제할 때 알림 전체가 삭제되도록 델리게이트추가
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //삭제한 셀의 정보를 삭제
            self.alerts.remove(at: indexPath.row)
            //인코딩 셋(삭제된 값을 Userdefaults에 저장)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            //테이블새로고침
            tableView.reloadData()
        default:
            break
        }
    }
}
