//
//  AssetSummaryView.swift
//  MyAssets
//
//  Created by Finley on 2022/04/29.
//

import SwiftUI

struct AssetSummaryView: View {
    @EnvironmentObject var assetData: AessetSummaryData
    
    var assets: [Asset]{
        return assetData.assets
    }
    var body: some View {
        VStack(spacing: 20){
            ForEach(assets) {asset in
                switch asset.type{
                case .creditCard: AssetCardSectionView(asset: asset)
                        .frame(idealHeight: 250) //이상적인 height
                default:
                    AssetSectionView(assetSection: asset)
                }
                //AssetSectionView(assetSection: asset)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
    }
}


//프리뷰
struct AssetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        AssetSummaryView()
            .environmentObject(AessetSummaryData())
            .background(Color.gray.opacity(0.2))
        
    }
}
