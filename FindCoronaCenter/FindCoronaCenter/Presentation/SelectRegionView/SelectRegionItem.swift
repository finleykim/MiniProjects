//
//  SelectRegionItem.swift
//  FindCoronaCenter
//
//  Created by Finley on 2022/07/27.
//

import SwiftUI

struct SelectRegionItem: View {
    var region: Center.Sido
    var count: Int
    var body: some View {
        ZStack{
            Color(white: 0.9)
            VStack{
                Text(region.rawValue)//어떤시도를나타낼지
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                Text("(\(count))") //센터갯수
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SelectRegionItem_Previews: PreviewProvider {
    static var previews: some View {
        let region0 = Center.Sido.경상남도
        SelectRegionItem(region: region0, count: 3) //프리뷰
    }
}
