//
//  GetStartedVC.swift
//  SOS
//
//  Created by Alpesh Desai on 27/12/20.
//

import UIKit
import AVFoundation
import AVKit
import AppTrackingTransparency

class GetStartedVC: UIViewController {

    @IBOutlet weak var viewVideo: UIView!
    var avPlayer: AVPlayer!
    var avPlayerController : AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filepath: String? = Bundle.main.path(forResource: "qidong", ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        avPlayer = AVPlayer(url: fileURL)
        avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        avPlayerController.showsPlaybackControls = false
        avPlayerController.videoGravity = .resizeAspectFill
        DispatchQueue.main.async {
            self.viewVideo.addSubview(self.avPlayerController.view)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        avPlayerController.player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
        avPlayerController.player?.pause()
    }
    
    @IBAction func btnSignupClk(_ sender: UIButton) {
        self.openSignUp()
        /*
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                print(status)
                if status == .authorized {
                    self.openSignUp()
                } else {
                    self.alertShow(self, title: "Allow this app to track you across the app.", message: "In iPhone settings, tap on SOS app and Allow Tracking", okStr: "Open Settings", cancelStr: "Not Now") {
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(url)
                        }
                    } cancelClick: {}
                }
            })
        } else {
            self.openSignUp()
        } */
    }
    
    func openSignUp() {
        let controll = LoginBord.instantiateViewController(identifier: "SignupNav")
        controll.modalPresentationStyle = .fullScreen
        self.present(controll, animated: true, completion: nil);
    }
    
    @IBAction func btnLoginClk(_ sender: UIButton) {
        let controll = LoginBord.instantiateViewController(identifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    

}
