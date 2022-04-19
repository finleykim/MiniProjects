

import UIKit
import SnapKit


class ContentCollectionViewCell: UICollectionViewCell{
    //하나의 이미지뷰만 가질 셀이기때문에 UIImageView로 선언
    let imageView = UIImageView()
    //이미지뷰생성
    override func layoutSubviews(){
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        //self.backgroundColor로 표현하지 않는 이유: Cell의 레이아웃을 표현하기 위해서는 UICollectionViewCell의 기본객체인 contentView를 슈퍼뷰로 보고 그 위에 서브뷰를 설정해야한다.
        
        //이미지표현방식
        imageView.contentMode = .scaleAspectFill
        
        //이미지 넣을 서브뷰(imageView) 추가 - stroryboard상에서 imageview오브젝트를 추가한 것과 같은 것
        contentView.addSubview(imageView)
        
        //이미지뷰 오토레이아웃설정 - snapkit활용
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
                    // ㄴ constraints : 탑,바텀,리딩,트레일링 0
        }
    }
    
}
