//
//  HomeViewController.swift
//  NetflixStyleSampleApp
//
//  Created by Finley on 2022/04/18.
//

import UIKit
import SwiftUI

class HomeViewController: UICollectionViewController{
    var contents : [Content] = []
    var mainItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //네비게이션바 설정
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        
        //maincell의 Data설정, 가져오기
        contents = getContents()
        mainItem = contents.first?.contentItem.randomElement() //random으로 가져오기
        
        

        
        //collectionView Item(cell)설정
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        
        //rankcell등록
        collectionView.register(ContentCollectionViewRankCell.self, forCellWithReuseIdentifier: "ContentCollectionViewRankCell")
        //main셀 등록
        collectionView.register(ContentCollctionViewMainCell.self, forCellWithReuseIdentifier: "ContentCollectionViewMainCell")
        
        //섹션이름(헤더)등록
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")
        
        //layout
        collectionView.collectionViewLayout = layout()
        
        


    }
    
    
    //getContents는 Content의 배열을 반환하는 함수
    func getContents() -> [Content]{
        //plist의 경로
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
                                                        // ㄴ 파일이름  // ㄴ 파일형식
              //어떤파일인지
                let data = FileManager.default.contents(atPath: path),
                //리스트
                let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return[] }
        return list
    }
    
    //각각의 섹션 타입에대한 UICollectionViweLayout설정
    private func layout() -> UICollectionViewLayout{
        return UICollectionViewCompositionalLayout{[weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch self.contents[sectionNumber].sectionType
            {
            case .basic:
                return self.createBasicTypeSection()
            case .large:
                return self.createLargeTypeSection()
            case .rank:
                return self.createRankTypeSection()
            case .main:
                return self.createMainTypeSection()

            }
        }
    }
    
    
    //basic섹션 - 컴포지셔널 레이아웃(가로스크롤)설정
    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        //item
        //item - size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5 )
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        //section
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        //헤더
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    
    //large섹션 - 컴포지셔널 레이아웃(가로스크롤)설정
    private func createLargeTypeSection() -> NSCollectionLayoutSection{
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        //섹션이름(헤더) 불러오기
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    //rank섹션 - 컴포지셔널 레이아웃(가로스크롤)설정
    private func createRankTypeSection() -> NSCollectionLayoutSection{
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        //섹션이름(헤더) 불러오기
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    
    //main섹션 - 컴포지셔널 레이아웃(가로스크롤)설정
    private func createMainTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //secion
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        return section
    }
    
    
    //sectionheader layout설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        //section header의 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        //section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
    
    
    
}


//UICollectionView DataSource, Delegate
extension HomeViewController{
    //섹션당 셀의 갯수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section{
        case 0: //단 하나의 컨텐츠만 보여줄 것
            return 1
        default:
            return contents[section].contentItem.count
            
        
    }
        
    }
    
    //콜렉션 뷰 셀 설정 (만들어둔 셀 적용)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //구조체에서 선택된 섹션의 sectionType(basic,main,large,rank이 속한 열거형)
        switch contents[indexPath.section].sectionType{
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        case .rank:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewRankCell", for: indexPath) as? ContentCollectionViewRankCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.rankLabel.text = String(describing: indexPath.row + 1)
            return cell
        case .main:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollctionViewMainCell", for: indexPath) as? ContentCollctionViewMainCell else { return UICollectionViewCell() }
            cell.imageView.image = mainItem?.image
            cell.descriptionLabel.text = mainItem?.description
            return cell

        }
    }
    
    //섹션이름라벨 적용
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else{ fatalError("could not dequeue header")}
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            return headerView
        } else {
            return UICollectionReusableView()
            
        }
    }
    
    //섹션 갯수설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //root의 갯수 (컨텐츠구조체 바로 하위에있는 항목의 갯수)
        return contents.count
    }
    
    //셀선택 (어떤셀을 선택했는지 알려주는 역할)
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isFirstSection = indexPath.section == 0
        let selectedItem = isFirstSection
            ? mainItem
            : contents[indexPath.section].contentItem[indexPath.row]
        let contentDetailView = ContentDetailView(item: selectedItem)
        let hostingVC = UIHostingController(rootView: contentDetailView)
        self.show(hostingVC, sender: nil)
    }
}


struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewControllerRepresentable().edgesIgnoringSafeArea(.all)
    }
    

}
struct HomeViewControllerRepresentable:
    UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let layout = UICollectionViewFlowLayout()
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        return UINavigationController(rootViewController: homeViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
}
