
import UIKit
import AudioToolbox

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
    @IBOutlet weak var imageView: UIImageView!
    
    
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
                self.timer?.setEventHandler(handler: {[weak self] in
                    //시간을 시,분,초로 표현
                    guard let self = self else { return }
                    self.currentSeconds -= 1
                    let hour = self.currentSeconds / 3600
                    let minutes = (self.currentSeconds % 3600) / 60
                    let seconds = (self.currentSeconds % 3600) % 60
                    self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                    self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                    UIView.animate(withDuration: 0.5, delay: 0, animations: {
                        self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                    })
                    UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                        self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                    })
                    if self.currentSeconds <= 0{
                        self.stopTimer()
                        AudioServicesPlaySystemSound(1005)
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
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        self.cancelButton.isEnabled = false
        self.timer?.cancel()
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
                    UIView.animate(withDuration: 0.5, animations: {
                        self.timerLabel.alpha = 1
                        self.progressView.alpha = 1
                        self.datePicker.alpha = 0
                    })
                    //self.setTimerInfoViewVisble(isHidden: false)
                    //self.datePicker.isHidden = true
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

