//
//  SOSRatingDetailPageVC.swift
//  SOS
//
//  Created by Alpesh Desai on 29/12/20.
//

import UIKit
import FloatRatingView
import Kingfisher
import CoreLocation
import GoogleMaps

class SOSRatingDetailPageVC: UIViewController {

    var sosHistoryData = SOSHistoryData()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: LetsImageView!
    @IBOutlet weak var staffRatingView: FloatRatingView!
    @IBOutlet weak var yourRatingView: FloatRatingView!
    @IBOutlet weak var yourRatingStack: UIStackView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblSosTime: UILabel!
    
    @IBOutlet weak var viewTop: LetsView!
    @IBOutlet weak var viewBottom: LetsView!
    @IBOutlet weak var viewBg: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Raised SOS Details"
        viewBg.isHidden = true
        let url = baseURL + URLS.GetSOSById.rawValue + "\(sosHistoryData.Id)"
        callGetSOSRatingDetail(url: url) { (data) in
            if let data = data {
                self.viewBg.isHidden = false
                self.setupData(data: data)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setupData(data : SOSHistoryData) {
        lblTitle.text = data.RoamingStaffName
        staffRatingView.rating = data.Rating.ns.doubleValue
        yourRatingView.rating = data.CustomerRating.ns.doubleValue
        yourRatingStack.isHidden = data.CustomerRating.isEmpty
        
        if let str = data.CustomerProfilePicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let url = URL(string: str) {
            let source = ImageResource(downloadURL: url)
            imgProfile.kf.setImage(with: source, placeholder:UIImage(named: "ic_profile"))
        }
        
        lblDate.text = data.StartDate
        lblTime.text = data.StartTime
        lblType.text = data.SOSType
        lblSosTime.text = "\(data.CompletedSOSInMin) Min."
        
    }

}
