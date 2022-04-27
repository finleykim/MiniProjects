

import SwiftUI

struct ContentDetailView: View {
    //@State 프로퍼티레퍼 - 외부자극없이 내부의 상태가 어떻게 변화할 것인지 표시
    @State var item: Item?
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
        ZStack(alignment: .bottom){
            if let item = item {
                Image(uiImage: item.image)
                    .aspectRatio(contentMode: .fit)
                Text(item.description)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.primary)
                    .background(Color.primary
                                    .colorInvert()
                                    .opacity(0.75))
            } else {
                Color.white
            }
        }
        }
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let item0 = Item(description: "흥미진진, 판타지, 애니메이션, 액션, 멀티캐스팅", imageName: "poster0")
        ContentDetailView(item: item0)
    }
}
