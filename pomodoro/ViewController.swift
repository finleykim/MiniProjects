
import UIKit

class ViewController: UIViewController {

    enum TimerStatus{
        case start
        case pause
        case end
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    

    var duration = 60
    var timerStatus: TimerStatus = .end
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }

    func setTimerInfoViewVisble(isHidden: Bool){
    self.timerLabel.isHidden = isHidden
    self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton(){
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.timerStatus = .end
        self.setTimerInfoViewVisble(isHidden: true)
        self.datePicker.isHidden = false
        self.toggleButton.isSelected = false
        self.cancelButton.isEnabled = false
        
    }
    @IBAction func tapToggleButton(_ sender: Any) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus{
        case .end: //클릭 -> 시작
            self.timerStatus = .start
            //1. 타이머와 프로그레스뷰를 숨기지 말고
            self.setTimerInfoViewVisble(isHidden: false)
            //2. 데이트피커는 숨기고
            self.datePicker.isHidden = true
            //3. 버튼은 선택된상태이므로 "일시정지"로변경 (configuareToggleButton메서드의 .selected)
            self.toggleButton.isSelected = true
            //4. 취소버튼은 활성화
            self.cancelButton.isEnabled = true
            
        case .start: //클릭 -> 일시정지
            //버튼을 누르면 .pause 상태로 변경
            self.timerStatus = .pause
            //1. 버튼은 선택된상태이므로 "시작"으로 변경 (configuareToggleButton메서드의 .selected가 아님을 표시 즉 .normal인 "시작")
            self.toggleButton.isSelected = false
        
            
        case .pause: //클릭 -> 시작
            self.timerStatus = .start
            self.toggleButton.isSelected = true
     
        }
    
        
    }
    
    
}

