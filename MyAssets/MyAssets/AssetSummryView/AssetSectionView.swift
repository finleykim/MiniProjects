

import SwiftUI

struct AssetSectionView: View {
    @ObservedObject var assetSection: Asset
    var body: some View {
        VStack(spacing: 20){
            AssetSectionHeaderView(title: assetSection.type.title)
            ForEach(assetSection.data){ asset in
                HStack{
                    Text(asset.title)
                        .font(.title)
                        .foregroundColor(.secondary)
                    Spacer() //간격
                    Text(asset.amount)
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Divider()
                
            }
        }
        .padding()
    }
}

struct AssetSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = Asset(
            id: 0,
            type: .bankAccount,
            data: [
                AssetData(id: 0, title: "신한은행", amount: "5,300,000원"),
                AssetData(id: 0, title: "국민은행", amount: "2,300,000원"),
                AssetData(id: 0, title: "기업은행", amount: "7,500,000원")
                
            ]
            )
        AssetSectionView(assetSection: asset)
    }
}
