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
        
    }
}

//UITableView Datasource
extension BeerListViewController{
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
    
    
    
}
