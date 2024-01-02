//
//  StatisticsVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class StatisticCell : UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
}

class StatisticsVC: UIViewController {

    var arrayData = [StatasticData]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Statistic"
        
        callGetStatistics { (data) in
            self.arrayData = data
            self.collectionView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    

}


extension StatisticsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticCell", for: indexPath) as! StatisticCell
        let obj = arrayData[indexPath.row]
        cell.lblTitle.text = "\(obj.SOSCount)"
        cell.lblSubTitle.text = obj.Type
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.width/2-18.0
        return CGSize(width: width, height: UIScreen.height/6.0)
    }
}
