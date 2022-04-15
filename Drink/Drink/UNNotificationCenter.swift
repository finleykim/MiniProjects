

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    //알럿 객체를 받아서 리퀘스트를 만들고 최종적으로 노티피케이션에 추가하는 함수
    func addNotificationRequest(by alert: Alert) {
        //알림의 내용설정
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이예요💦"
        content.body = "세계보건기구(WHO)가 권장하는 하루 물 섭취량은 1.5~2ℓ입니다."
        content.sound = .default
        content.badge = 1
        
        //날짜는 알럿객체가 가지고있기 때문에 해당 데이트를 시간 분 형태의 데이트 컴포넌츠로 만든다
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
                                                        // ㄴ 어떤 컴포넌트를 넣을지     // ㄴ 데이터를 얻어오는 곳
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
                                                    // ㄴ 날짜조건             // ㄴ 반복여부
        let reguest = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(reguest, withCompletionHandler: nil)
        //ㄴ UNNotificationCenter에 추가    // ㄴ 완료된 후의 동작
    }
}
