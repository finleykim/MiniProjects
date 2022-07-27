//
//  SelectRegionViewModel.swift
//  FindCoronaCenter
//
//  Created by Finley on 2022/07/27.
//

import SwiftUI

struct SelectRegionView: View {
    @ObservedObject var viewModel = SelectRegionViewModel()
    // func bind(viewModel: ) <-RxSwift에서 이렇게표현하던 것
    private var items: [GridItem] { //그리드타입으로 그리드뷰를 그리려면 GridItem을 선언해야한다.
        Array(repeating: .init(.flexible(minimum: 80)), count: 2)
    }
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: items, spacing: 20){
                    ForEach(Center.Sido.allCases, id: \.id) //allCases: Sido의 모든 케이스를 Array로 불러오고 id는 자체가 바라보고있는 id값을 불러온다
                    { sido in
                        let centers = viewModel.centers[sido] ?? []
                        NavigationLink(
                            destination: CenterList(centers: centers)){
                                SelectRegionItem(region: sido, count: centers.count)
                            }
                    }
                }
                .padding()
                .navigationTitle("코로나19 예방접종 센터")
            }
        }
    }
}

struct SelectRegionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SelectRegionViewModel()
        SelectRegionView(viewModel: viewModel)
    }
}
