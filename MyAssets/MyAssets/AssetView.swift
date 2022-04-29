//
//  AssetView.swift
//  MyAssets
//
//  Created by Finley on 2022/04/28.
//

import SwiftUI

struct AssetView: View {
    var body: some View {
        NavigationView{
            //scrollview생성
            ScrollView {
                VStack(spacing: 30){
                    Spacer()
                    AssetMenuGridView()
                    AssetBannerView()
                        .aspectRatio(5/2, contentMode: .fit)
                    AssetSummaryView()
                        .environmentObject(AessetSummaryData())
                }
            }
            
            .background(Color.gray.opacity(0.2))
            //상단 네비게이션 불러오기
            .navigationBarwithButton("내 자산")
        }
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView()
    }
}
