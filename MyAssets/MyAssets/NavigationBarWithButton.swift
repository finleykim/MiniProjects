
import SwiftUI

struct NavigationBarWithButton: ViewModifier {
    var title: String = ""
    func body(content: Content) -> some View{
        return content
        //왼쪽네비게이션 바
            .navigationBarItems(leading: Text(title)
                                .font(.system(size: 24, weight: .bold))
                                    .padding(), //왼쪽 여백
                                trailing: Button(action:{
                print("자산추가버튼 tapped")
            },
                                                 label: {
                Image(systemName: "plus")
                Text("자산추가")
                    .font(.system(size: 12))
            })
                                    .accentColor(.black) //글자색상
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)) //버튼 내 여백
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black)) //테두리
            
            )
            .navigationBarTitleDisplayMode(.inline)
        //퍼포먼스추가
            .onAppear{
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = UIColor(white: 1, alpha: 0.5)
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
    

}

extension View{
    func navigationBarwithButton(_ title: String) -> some
    View{
        return self.modifier(NavigationBarWithButton(title:title))
    }
}

struct NavigationBarWithButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Color.gray.edgesIgnoringSafeArea(.all)
                //적용
                .navigationBarwithButton("내 자산")
        }
        
        

    }
}
