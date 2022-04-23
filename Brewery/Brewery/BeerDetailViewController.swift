
import Foundation
import UIKit
import SwiftUI
import Kingfisher

class BeerDetailViewController: UITableViewController{
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = beer?.name ?? "이름없는 맥주"
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        //헤더설정
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
        tableView.tableHeaderView = headerView
        
    }
    
}


//UITableView DataSource, Delegate
extension BeerDetailViewController{
    
    //섹션의 갯수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //섹션당 row의 갯수 (foodPairing은 맥주마다 다른 여러개의 셀로 구성되고, 나머지는 1개의 셀만 가지면된다.)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 3:
            return beer?.foodPairing?.count ?? 0
        default: return 1
        }
    }
    
    //섹션별 타이틀
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0 :
            return "ID"
        case 1 :
            return "Description"
        case 2 :
            return "Brewers Tips"
        case 3 :
            //foodpairing
            let isFoodPairingEmpty = beer?.foodPairing?.isEmpty ?? true
            return isFoodPairingEmpty ? nil : "Food Paring"
        default : return nil
        }
    }
    
    //셀설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        switch indexPath.section{
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "설명 없는 맥주"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "팁 없는 맥주"
            return cell
        case 3:
            cell.textLabel?.text = beer?.foodPairing?[indexPath.row] ?? ""
            return cell
        default:
            return cell
        }
    }
}
