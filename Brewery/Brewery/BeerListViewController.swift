//
//  BeerListViewController.swift
//  Brewery
//
//  Created by Finley on 2022/04/23.
//

import UIKit

class BeerListViewController: UITableViewController{
    //UITableView의 DataSource
    var beerList = [Beer]()
    var dataTasks = [URLSessionDataTask]()
    var currentPage = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "FinBrewery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //* UITableView설정
        //셀 레지스터(등록)
        tableView.register((BeerListCell.self), forCellReuseIdentifier: "BeerListCell")
        //셀 높이지정
        tableView.rowHeight = 150
        tableView.prefetchDataSource = self
        fetchBeer(of: currentPage)
        
    }
}

//UITableView Datasource
extension BeerListViewController: UITableViewDataSourcePrefetching{

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as! BeerListCell
                
                let beer = beerList[indexPath.row]
                cell.configure(with: beer)
                
                return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        
        indexPaths.forEach{
            if ($0.row + 1)/25 + 1 == currentPage{
                self.fetchBeer(of: currentPage)
            }
        }
        
    }
    
}


//데이터패칭
private extension BeerListViewController{
    func fetchBeer(of page: Int){
        //데이터를 가져올 주소
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
        dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil
        else { return }
        var request = URLRequest(url: url)
        //요청방식
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request){[weak self] data, response, error in
        guard error == nil,
        let self = self,
        let response = response as? HTTPURLResponse,
        let data = data,
        let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
            print("ERROR:URLSession data task \(error?.localizedDescription ?? "")")
            return
        }
            switch response.statusCode{
                //정상
            case (200...299):
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //클라이언트에러
            case (400...499):
                print("""
ERROR: Client ERROR \(response.statusCode)
Response: \(response)
""")
                //서버에러
            case (500...599):
                print("""
ERROR: Server ERROR \(response.statusCode)
Response: \(response)
""")
            default:
                print("""
ERROR: \(response.statusCode)
Response: \(response)
""")
            }
        }
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}
