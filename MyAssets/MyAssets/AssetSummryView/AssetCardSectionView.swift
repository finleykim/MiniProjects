
import SwiftUI

struct AssetCardSectionView: View {
    @State private var selectedTab = 1 //어떤탭을 선택했는지에 대한 상태 기본값 ("이번달결제")
    @ObservedObject var asset: Asset
    
    //assetData는 [AssetData]배열의 data
    var assetData: [AssetData]{
        return asset.data
    }
    
    
    var body: some View {
        VStack{
            AssetSectionHeaderView(title: asset.type.title)
            TabMenuView(
            tabs: ["지난달 결제", "이번달 결제", "다음달 결제"],
            selectedTab: $selectedTab,
            updated: .constant(.nextMonth(amount: "10,000"))
            )
            
            TabView(
                selection: $selectedTab,
                content: {
                    ForEach(0...2, id: \.self){i in
                        VStack{
                            ForEach(assetData){ data in
                                HStack {
                                    Text(data.title)
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(data.creditCardAmounts![i].amount) //첫번째 탭에는 0번째 데이터의 amount, 두번째 탭에는 1번째 데이터의 amount ...
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                }
                                Divider()
                            }
                        }
                        .tag(i)
                    }
                }
            )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding()
        }
    }
}

struct AssetCardSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = AessetSummaryData().assets[5]
        AssetCardSectionView(asset: asset)
        
    }
}
