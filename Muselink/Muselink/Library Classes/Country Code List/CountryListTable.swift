//
//  CountryListTable.swift
//  BamigbeApp
//
//  Created by Apps on 01/02/21.
//  Copyright © 2021 iOS System. All rights reserved.
//

import UIKit
enum TypeOfPicker{
    case phoneNumber
    case country
    case city
    case religion
}
class CountryListTable: BaseClassVC {
    var countries: [String] = []
    var countryList = [CountiesWithPhoneModel]()
    @IBOutlet weak var countrytable:UITableView!{
        didSet{
            self.countrytable.delegate = self
            self.countrytable.dataSource = self
        }
    }
    @IBOutlet var searchBar: UISearchBar!
    var countryID : ((_ countryName:String,_ code:String) -> Void)?
    var filterdata = [CountiesWithPhoneModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = self.getDataFormFile()
        self.countrytable.separatorStyle = .none
        searchBar.delegate = self
        if data.1 == ""{
            countryList = data.0
            filterdata = countryList
            self.countrytable.reloadData()
        }
    }
    func getDataFormFile() -> ([CountiesWithPhoneModel],String)
    {
        var country_code = [CountiesWithPhoneModel]()
        if let jsonFile = Bundle.main.path(forResource: "CountryCodes", ofType: "json")  {
            let url = URL.init(fileURLWithPath: jsonFile)
            do{
                let data  = try Data.init(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let json = jsonData as? [[String:String]]
                {
                    for list in json{
                        let data = CountiesWithPhoneModel.init(dial_code: (list["dial_code"] ?? ""), countryName: (list["name"] ?? ""), code: (list["code"] ?? ""))
                        country_code.append(data)
                    }
                    return (country_code,"")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return ([],"error")
    }
}

extension CountryListTable:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filterdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell else {
            return CountryCell()
        }
        cell.countryNameLbl.text = filterdata[indexPath.row].countryName
        cell.flag.image = UIImage.init(named: filterdata[indexPath.row].code ?? "")
        cell.code.text = filterdata[indexPath.row].dial_code
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countryID?(filterdata[indexPath.row].countryName ?? "", filterdata[indexPath.row].dial_code ?? "")
        dismiss(animated: true, completion: nil)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.view.endEditing(true)
        self.filterdata = self.countryList
        self.countrytable.reloadData()
        self.searchBar.text = ""
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdata = searchText.isEmpty ? countryList : countryList.filter { (($0.countryName ?? "").contains(searchText)) || (($0.dial_code ?? "").contains(searchText))}
        countrytable.reloadData()
    }
}
  
class CountryCell: UITableViewCell {
    @IBOutlet weak var countryNameLbl:UILabel!
    @IBOutlet weak var flag:UIImageView!
    @IBOutlet weak var code:UILabel!
}
class CityCell: UITableViewCell {
    @IBOutlet weak var cityNameLbl:UILabel!
 
}
struct CountiesWithPhoneModel {
    var dial_code :String?
    var countryName : String?
    var code :String?
}
