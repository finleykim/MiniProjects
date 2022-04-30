

import SnapKit
import UIKit

final class TodayViewController: UIViewController {
    

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout() // UICollectionView는 layout이 반드시 필요하기 때문에, collectionViewFlowLayout으로 초기화해야한다.
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                                            // ㄴ frame은 snapkit으로 설정할 것이기 때문에 zero로 설정
        //collectionView를 꾸며주기 위해 delegate와 dateSource를 지정한다.
        collectionView.delegate = self
        collectionView.dataSource = self


        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: "todayCell")
        collectionView.register(TodayCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodayCollectionHeaderView")


        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView적용
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        //view.backgroundColor = .blue

        }


    }



//cell의 갯수
extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath)
        as? TodayCollectionViewCell //셀컨트롤러로 다운캐스팅
        cell?.setup() //셀컨트롤러의 셋업메서드 불러오기
        
        return cell ?? UICollectionViewCell() //cellForItemAt은 반드시 반환값이 있어야하기 때문에 옵셔널처리
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    //viewForSupplementaryElementOfKind 헤더나 푸터의 뷰를 리턴해주는 메서드
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //footer와 header 모두 이 메서드로 불려지기 때문에 구분해서 구현해야한다.
        guard
            kind == UICollectionView.elementKindSectionHeader, //kind가 UICollectionView의 header일 때만 리턴
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "TodayCollectionHeaderView",
                for: indexPath
            ) as? TodayCollectionHeaderView
        else { return UICollectionReusableView() } //위 조건이 아닐 때에는 임의의 컬렉션뷰리턴

        header.setupViews()

        return header
              
    }
    }

//cell의 레이아웃 조정
extension TodayViewController: UICollectionViewDelegateFlowLayout {
    //셀사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return CGSize(width: width, height: width) //정사각형
    }
    
    //헤더사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width - 32.0, height: 100.0)
    }
    
    //패딩(헤더와 셀 사이 간격)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let value: CGFloat = 16.0

            return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        }
}
    


