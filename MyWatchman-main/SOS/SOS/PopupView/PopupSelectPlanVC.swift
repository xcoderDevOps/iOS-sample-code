//
//  PopupSelectPlanVC.swift
//  SOS
//
//  Created by Alpesh Desai on 02/01/21.
//

import UIKit

class PlanCollectionCell : UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmout: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var bgView: UIView!
}

struct PlanData {
    var planId = 0
    var durationId = 0
}

class PopupSelectPlanVC: MyPopupController {
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayDuration = [PlanDurationData]()
    
    var selectedDuration : PlanDurationData? {
        didSet {
            if let dur = selectedDuration {
                self.lblDuration.text = dur.Name
            }
        }
    }
    
    var arrayData = [PlanListData]()
    var selectedPlan : PlanListData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = self.objData as? PlanListData {
            lblPlan.text = obj.Name
            if obj.Price.ns.integerValue == 0 {
                btnDuration.isHidden = true
            } else {
                btnSubmit.isHidden = true
            }
        }

        callGetPlanDuration { (data) in
            self.arrayDuration = data
            if let first = data.first {
                self.selectedDuration = first
            }
        }
        
        callGetPlanData { (data) in
            self.arrayData = data
            if let info = UserInfo.savedUser(), let fir = self.arrayData.filter({$0.Id == info.PlanId}).first {
                self.selectedPlan = fir
            }
            self.collectionView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDurationSelection(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrayDuration.compactMap({$0.Name})) { (str, index) in
            self.selectedDuration = self.arrayDuration[index]
        }
    }
    
    @IBAction func btnDismissPopup(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }
    
    @IBAction func btnSubmitCLK(_ sender: UIButton) {
        if let dur = selectedDuration, let plan = selectedPlan {
            if pressOK != nil {
                let obj = PlanData(planId: plan.Id, durationId: dur.Id)
                pressOK!(obj as AnyObject)
            }
        }
    }
}

extension PopupSelectPlanVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionCell", for: indexPath) as! PlanCollectionCell
        let obj = arrayData[indexPath.row]
        if let plan = selectedPlan {
            cell.bgView.backgroundColor = plan.Id == obj.Id ?  #colorLiteral(red: 0.2389999926, green: 0.6549999714, blue: 0.97299999, alpha: 1) : UIColor.white
            cell.lblTitle.textColor = plan.Id == obj.Id ?  UIColor.white : UIColor.black
            cell.lblAmout.textColor = plan.Id == obj.Id ?  UIColor.white : UIColor.black
            cell.lblMonth.textColor = plan.Id == obj.Id ?  UIColor.white : UIColor.black
        }
        cell.lblTitle.text = obj.PlanCategory
        cell.lblAmout.text = "$\(obj.Price)"
        cell.lblMonth.text = "\(obj.PlanDurationMonth) Month Security"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlan = arrayData[indexPath.row]
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heigit = collectionView.frame.size.height
        return CGSize(width: heigit, height: heigit)
    }
}
