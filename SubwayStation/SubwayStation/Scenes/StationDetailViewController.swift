//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by Finley on 2022/05/11.
//

import SnapKit
import UIKit
import Alamofire

final class StationDetailViewController: UIViewController{
    private let station: Station
    private var realtimeArrivalList : [StationArrivalDatResponseModel.RealTimeArrival] = []
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()
    //임시코드
    @objc func fetchData(){

        
//        let stationName = "왕십리역"
        let stationName = station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of:"역", with: ""))"
        
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDatResponseModel.self) { [weak self] response in
                self?.refreshControl.endRefreshing()
                guard case .success(let data) = response.result else { return }
                
//                print(data.realtimeArrivalList)
                self?.realtimeArrivalList = data.realtimeArrivalList
                self?.collectionViekw.reloadData()
            }
            .resume()
    }
    
    private lazy var collectionViekw: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: view.frame.width - 32.0, height: 100.0
        )
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical //상하스크롤
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        
        return collectionView
        
    }()
    
    init(station: Station){
        self.station = station
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
//        navigationItem.title = "왕심리" //임시코드
        navigationItem.title = station.stationName
        
        view.addSubview(collectionViekw)
        collectionViekw.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    

}

extension StationDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
        return realtimeArrivalList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath) as? StationDetailCollectionViewCell
        
        let realTimeArrival =
        realtimeArrivalList[indexPath.row]
        cell?.setup(with: realTimeArrival)
        
        return cell ?? UICollectionViewCell()
    }
}
