//
//  PopupSearchLocationVC.swift
//  CargoXpress
//
//  Created by infolabh on 24/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PopupSearchLocationVC: MyPopupController {

    struct AddressList {
        var name = ""
        var id = ""
    }
    var arrayAddressList = [AddressList]()
    var searchQuery = SPGooglePlacesAutocompleteQuery()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        searchQuery = SPGooglePlacesAutocompleteQuery(apiKey: GooglePlaceKey)
        
        // Do any additional setup after loading the view.
    }
    
    func handleSearchForSearchString(_ searchString : String)
    {
        var uniqueArray = NSArray()
        
        searchQuery.input = searchString
        
        
        searchQuery.fetchPlaces { (places, error) -> Void in
            if ((error) != nil)
            {
                print(error)
            }
            else
            {
                self.arrayAddressList = []
                uniqueArray = places as! NSArray
                
                for obj in uniqueArray
                {
                    print(obj)
                    self.arrayAddressList.append(AddressList(name: (obj as AnyObject).name as String, id: (obj as AnyObject).reference))
                }
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    @IBAction func btnCancelCLK(_ sender: Any) {
        if pressCancel != nil {
            self.pressCancel!()
        }
    }

}

extension PopupSearchLocationVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.handleSearchForSearchString(searchBar.searchTextField.text! + text)
        return true
    }
}

extension PopupSearchLocationVC : UITableViewDelegate, UITableViewDataSource
{
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        cell.lblAddress.text = arrayAddressList[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let address = arrayAddressList[indexPath.row]
        if self.pressOK != nil {
            self.pressOK!([address.id, address.name] as AnyObject)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
