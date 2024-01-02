//
//  PopupTrackJobVC.swift
//  CargoXpress
//
//  Created by infolabh on 16/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PopupTrackJobVC: MyPopupController {

    var routeArray = [RouteDetailData]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = objData as? [RouteDetailData] {
            self.routeArray = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
          if pressCancel != nil {
              pressCancel!()
          }
      }
    
      @IBAction func btnOkCLK(_ sender: UIButton) {
          if pressOK != nil {
              pressOK!(nil)
          }
      }

}

extension PopupTrackJobVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackJobCell") as! TrackJobCell
        cell.lblTitle.text = self.routeArray[indexPath.row].LocationName
        cell.btnCheckBox.isSelected = self.routeArray[indexPath.row].IsPassed
        return cell
    }
}


class TrackJobCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
}
