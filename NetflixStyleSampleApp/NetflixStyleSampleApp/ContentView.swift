//
//  ContentView.swift
//  NetflixStyleSampleApp
//
//  Created by Finley on 2022/04/26.
//

import SwiftUI

struct ContentView: View {
    let titles = ["Netflix Sample App"]
    var body: some View {
        NavigationView{
            List(titles, id: \.self){
                // ㄴ 위 타이틀 어레이를 가질 수 있도록 설정
                            // ㄴ id는 시퀀스 id를 그대로 가져올 수 있도록 설정
                //HomeViewController를 가져올 때에는 클래스가아닌 마지막에 빼둔 구조체를 가져와야한다
                let netflixVC = HomeViewControllerRepresentable()
                    //네비게이션 바 숨기기
                    .navigationBarHidden(true)
                //전체화면 채우기
                    .edgesIgnoringSafeArea(.all)
                //push와같이 새로운 뷰를 보여줄 수 있도록 설정
                NavigationLink($0,destination: netflixVC)
                            // ㄴ 타이틀 순서대로 표현 // ㄴ netflixVC로 이동
                }
            //네비게이션 타이틀설정
            .navigationTitle("SwiftUI to UIKit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
