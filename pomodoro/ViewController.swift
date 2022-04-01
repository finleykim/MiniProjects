
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
    var timer: DispatchSourceTimer?
    //현재 카운트다운되고있는 시간을 초로 저장하는 프로퍼티
    var currentSeconds = 0

    
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
    

    func startTimer(){
            if self.timer == nil{
                self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
                self.timer?.schedule(deadline: .now(), repeating: 1)
                self.timer?.setEventHandler(handler: {[weak self] in self?.currentSeconds -= 1
                                if self?.currentSeconds ?? 0 <= 0{
                                    debugPrint(self?.currentSeconds)
                                    self?.stopTimer()

    }
   })
                self.timer?.resume()
                                          
            }
        }
    
    
    func stopTimer(){
        if self.timerStatus == .pause{
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.setTimerInfoViewVisble(isHidden: true)
        self.datePicker.isHidden = false
        self.toggleButton.isSelected = false
        self.cancelButton.isEnabled = false
        self.timer?.cancel()
        //타이머를 종료할 때 nil을 할당하여 메모리에서 해제시켜야한다. 그렇지않으면 화면이 벗어나도 타이머가 계속동작됨
        self.timer = nil
    }
    
    
    @IBAction func tapCancelButton(_ sender: Any) {

        self.stopTimer()
        
    }
  
    @IBAction func tapToggleButton(_ sender: Any) {
        
        self.duration = Int(self.datePicker.countDownDuration)
                switch self.timerStatus{
                case .end:
                    self.currentSeconds = self.duration
                    self.timerStatus = .start
                    self.setTimerInfoViewVisble(isHidden: false)
                    self.datePicker.isHidden = true
                    self.toggleButton.isSelected = true
                    self.cancelButton.isEnabled = true
                    self.startTimer()
                case .start:
                    self.timerStatus = .pause
                    self.toggleButton.isSelected = false
                    self.timer?.suspend()
                case .pause:
                    self.timerStatus = .start
                    self.toggleButton.isSelected = true
                    self.timer?.resume()
             
                }
            
        
    }
    
    
}

