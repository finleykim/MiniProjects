
import SwiftUI

struct ContentView: View {
    //선언부
    @State private var selection: Tab = .asset
    
    //하단 탭 열거형
    enum Tab{
        case asset
        case recommend
        case alert
        case setting
    }
    var body: some View {
        //탭뷰설정
        TabView(selection: $selection){
                        // ㄴ @State 불러오기
            Color.white
                .tabItem{
                    Image(systemName: "dollarsign.circle.fill")
                    Text("자산")
                }
                .tag(Tab.asset)
            Color.blue
                .edgesIgnoringSafeArea(.all)
                .tabItem{
                    Image(systemName: "star.fill")
                    Text("추천")
                }
                .tag(Tab.recommend)
            Color.yellow
                .edgesIgnoringSafeArea(.all)
                .tabItem{
                    Image(systemName: "bell.fill")
                    Text("알림")
                }
                .tag(Tab.alert)
            Color.red
                .edgesIgnoringSafeArea(.all)
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("설정")
                }
                .tag(Tab.setting)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
