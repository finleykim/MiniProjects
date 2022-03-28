//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Finley on 2022/03/25.
//

import UIKit

enum DiaryEditerMode{
    case new
    case edit(IndexPath, Diary) //IndexPath, Diary객체를 전달받을 수 있도록 정의
}


//델리게이트를 이용해 일기장리스트화면에 작성된 일기를 전달
protocol WriteDiaryViewDelegate: AnyObject{
    func didSelectReigster(diary: Diary) //작성된 일기를 전달
}


class WriteDiaryViewController: UIViewController {

    //1. 제목,내용,날짜의 텍스트필드와 등록버튼 아울렛변수선언
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
   
    //5. 일기장작성화면 - 날짜선택 피커뷰 생성을 위한 코드 ( 상수선언 )
    private let datePicker = UIDatePicker()
    //데이트피커에서 선택된 데이트를 저장하는프로퍼티
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    //DiaryEditerMode타입을 저장하는 프로퍼티 선언
    var diaryEditorMode: DiaryEditerMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        self.confirmButton.isEnabled = false
    }
    
    private func configureEditMode(){
        switch self.diaryEditorMode{
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
            
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    //4. 내용텍스트필드 테두리생성을 위한 함수작성
    private func configureContentsTextView(){
        //색상선언
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        //보더컬러지정
        self.contentsTextView.layer.borderColor = borderColor.cgColor
                                                            // ㄴ 레이어관련 색상을 설정할때는 UIColor가 아닌 cgColor사용해야함
        //보더넓이지정
        self.contentsTextView.layer.borderWidth = 0.5
        //보더모서리 둥그스름하게
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    
    //6. 일기장작성화면 - 날짜선택 피커뷰 생성을 위한 코드 ( 함수생성 )
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date
                                        // ㄴ 날짜만 나오게 설정 (시간 x)
        self.datePicker.preferredDatePickerStyle = .wheels
                                                // ㄴ 휠스타일로 지정
        //addTarget: UIController 객체가 이벤트에 응답하는 방식을 설정
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
                                // ㄴ 타겟은 해당 뷰턴트롤러                                // ㄴ for: 어떤상황에 액션함수를 호출할지
                                    // ㄴ action : 이벤트가 발생하였을 때(for 파라미터에 설정한 때)그에 응답하여 호출될 메서드를 셀렉터로 넘겨준다
        self.dateTextField.inputView = self.datePicker
        self.datePicker.locale = Locale(identifier: "ko-KR")
    }
    
    //10.
    private func configureInputField(){
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }

    //2. 등록버튼 액션함수생성
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
                   // ㄴ 구조체                                             // ㄴ 즐겨찾기된 상태가 아니므로 false를 넘겨준다
        
        switch self.diaryEditorMode{
            //등록되었을때와 수정되었을 때를 나누어 각각의 동작을 결정
        case .new: //일기가 등록되었을 때
            self.delegate?.didSelectReigster(diary: diary) //일기 전달받을 메서드 호출
            
            
        case let .edit(indexPath, _): //일기가 수정되었을 때
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: [
                "indexPath.row": indexPath.row
            ])
            
        }
        
        
        
        self.navigationController?.popViewController(animated: true)  //pop뷰로 전화면으로 이동
    }
    
    //7. 일기장작성화면 - 날짜선택 피커뷰 생성을 위한 코드 ( 6번의 함수 내 action파라매터 #selector에 들어갈 objc함수 )
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formmator = DateFormatter()
                      // ㄴ 날짜와 텍스트를 변환해주는역할. 즉, 데이트타입을 사람이 읽을 수 있도록 변환해주는 역할
        //dateFormat: 데이트타입을 어떤문자열로 보여줄 것인지 포멧을 적는다
        formmator.dateFormat = "yyyy 년 MM월 dd일(EEEEE)"
                                                // ㄴ 요일을 한글자만 보여주게
        //locale: 데이트포맷이 한국어로 표현되도록선택
        formmator.locale = Locale(identifier: "ko_KR")
        //위에 선언한 diaryDate상수에 datePicker프로퍼티의 date타입을 저장
        self.diaryDate = datePicker.date
        //dateTextField아울렛변수에 설정한 포맷을 넘겨준다
        self.dateTextField.text = formmator.string(from: datePicker.date)
        //날짜가 변경될 때 마다
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField){
            self.validateInputField()
        }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    
   //8. touchesBegan 메서드 : 유저가 화면을 터치하면 호출되는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //등록버튼 활성화를 판단할 수 있게하는 메서드. 아래 WriteDiaryViewController익스텐션에 추가할 것
    private func validateInputField(){
            self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) &&
            !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
        }
}

extension WriteDiaryViewController: UITextViewDelegate{
    //textViewDidChange : 텍스트뷰에 텍스트가 입력될 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView){
        self.validateInputField()
    }
}



