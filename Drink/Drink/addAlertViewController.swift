
import Foundation
import UIKit

class addAlertViewController: UIViewController{
    var pickedDate: ((_ date: Date) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
   
    
    
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        //설정한 시간값이 부모뷰에 전달할 수 있도록 설정
        pickedDate?(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
 
