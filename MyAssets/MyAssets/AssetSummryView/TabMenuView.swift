
import SwiftUI

struct TabMenuView: View {
    var tabs: [String] //지난달결제, 이번달결제, 다음달결제
    @Binding var selectedTab: Int
    @Binding var updated: CreditCardAmounts?
    
    var body: some View {
        HStack{
            ForEach(0..<tabs.count, id: \.self){ row in
                Button(
                    action: {
                       selectedTab = row
                        UserDefaults.standard.set(true, forKey: "creditcard_update_checked: \(row)")
                    }, label: {
                        VStack(spacing: 0){
                            HStack{
                                if updated?.id == row{ //업데이트가 있는경우
                                    let checked = UserDefaults.standard.bool(forKey: "creditcard_update_checked: \(row)")
                                    Circle() //업데이트표시할 모양
                                        .fill(
                                    !checked //버튼을 누르지 않은경우 : 버튼을 누른경우
                                    ? Color.red : Color.clear)
                                    frame(width: 6, height: 6)
                                        .offset(x:2, y:-8)
                                } else { //업데이트가 없는경우
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 6, height: 6)
                                        .offset(x: 2, y: -8)
                                }
                                //타이틀설정
                                Text(tabs[row])
                                    .font(.system(.headline))
                                    .foregroundColor(        //누른탭과 누르지 않은 탭
                                        selectedTab == row ? .accentColor : .gray
                                    )
                                offset(x: -4, y: 0)
                            }
                            
                            //탭전환
                            .frame(height: 52)
                            Rectangle()
                                .fill(
                                selectedTab == row //선택된 행과 선택되지 않은 행
                                ? Color.secondary : Color.clear
                                )
                                .frame(height: 3)
                        }
                        
                    }
                )
                    //버튼스타일
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 55)
    }
}


//프리뷰
struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView(tabs: ["지난달결제", "이번달결제", "다음달결제"], selectedTab: .constant(1), updated: .constant(.currentMonth(amount: "10,000d원")))
    }
}
