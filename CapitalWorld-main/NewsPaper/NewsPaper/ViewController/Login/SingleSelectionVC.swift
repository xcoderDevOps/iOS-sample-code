//
//  SingleSelectionVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 25/03/22.
//

import UIKit

class SingleSelectionVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrayData = [String]()
    var searchResult = [String]()
    var selectedValue = ""
    var completionBlock: ((_ sender: String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResult = arrayData
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = arrayData.filter({$0.contains(searchText)})
        if searchText.trim.isEmpty {
            searchResult = arrayData
        }
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
    
}


extension SingleSelectionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        cell?.accessoryType = (selectedValue == searchResult[indexPath.row]) ? .checkmark :  .none
        cell!.textLabel?.text = searchResult[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            if self.completionBlock != nil {
                self.completionBlock!(self.searchResult[indexPath.row])
            }
        }
    }
}
