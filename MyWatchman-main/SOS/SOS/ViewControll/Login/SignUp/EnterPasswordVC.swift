//
//  EnterPasswordVC.swift
//  SOS
//
//  Created by Alpesh Desai on 04/03/21.
//

import UIKit
import FirebaseMessaging
import SafariServices

class EnterPasswordVC: UIViewController {

    @IBOutlet weak var txtPas: LetsTextField!
    @IBOutlet weak var txtConPas: LetsTextField!
    @IBOutlet weak var lblTerms: UILabel!
    
    let text = "By continuing you agree to My Wathman Terms of Service. Please see our Privacy Notice."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTerms.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapLabel(gesture:)))
        tapGesture.numberOfTouchesRequired = 1
        lblTerms.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (text as NSString).range(of: "Terms of Service")
           // comment for now
        let privacyRange = (text as NSString).range(of: "Privacy Notice")

           if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termsRange) {
                let url = URL(string: "https://my-watchman.com/Terms&Conditions")
                let svc = SFSafariViewController(url: url!)
                svc.view.tintColor = UIColor.systemBlue
                self.present(svc, animated: true, completion: nil)
           } else if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: privacyRange) {
                let url = URL(string: "https://my-watchman.com/privacy")
                let svc = SFSafariViewController(url: url!)
                svc.view.tintColor = UIColor.systemBlue
                self.present(svc, animated: true, completion: nil)
           } else {
               print("Tapped none")
           }
    }
    
    @IBAction func btnDismissCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEyeClk(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtPas.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func btnReEyeClk(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtConPas.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func btnBackCLK(_ sender: UIButton) {
        registerData.password = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueCLK(_ sender: UIButton) {
        
        /*
         else if validePasswordWithLenght(txtPas.text!) || validatePasswordWithString(txtPas.text!) {
            showAlert(popUpMessage.PasswordValid.rawValue)
            return
        }
         */
        
        if  isEmptyString(txtPas.text!) || isEmptyString(txtConPas.text!)
        {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        } else if txtPas.text! != txtConPas.text! {
            showAlert(popUpMessage.ConPassword.rawValue)
            return
        } else {
            guard let firebaseToken = Messaging.messaging().fcmToken  else { return}
            let param = ["FirstName": registerData.first,
                         "LastName": registerData.last,
                         "UserName": registerData.username,
                         "Email": registerData.email,
                         "Mobile": registerData.phoneNum ,
                         "Password": txtPas.text!,
                         "CountryId":registerData.country.Id,
                         "DeviceToken":firebaseToken,
                         "DeviceInfo":"iOS"] as [String : Any]
            let controll = LoginBord.instantiateViewController(identifier: "SecurityQuestionsVC") as! SecurityQuestionsVC
            controll.param = param
            self.navigationController?.pushViewController(controll, animated: true)
        }
    }
}

extension UITapGestureRecognizer {
   
   func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
       guard let attributedText = label.attributedText else { return false }

       let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
       mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))
       
       // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
       let paragraphStyle = NSMutableParagraphStyle()
       paragraphStyle.alignment = .center
       mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

       // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
       let layoutManager = NSLayoutManager()
       let textContainer = NSTextContainer(size: CGSize.zero)
       let textStorage = NSTextStorage(attributedString: mutableStr)
       
       // Configure layoutManager and textStorage
       layoutManager.addTextContainer(textContainer)
       textStorage.addLayoutManager(layoutManager)
       
       // Configure textContainer
       textContainer.lineFragmentPadding = 0.0
       textContainer.lineBreakMode = label.lineBreakMode
       textContainer.maximumNumberOfLines = label.numberOfLines
       let labelSize = label.bounds.size
       textContainer.size = labelSize
       
       // Find the tapped character location and compare it to the specified range
       let locationOfTouchInLabel = self.location(in: label)
       let textBoundingBox = layoutManager.usedRect(for: textContainer)
       let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                         y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
       let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                    y: locationOfTouchInLabel.y - textContainerOffset.y);
       let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
       return NSLocationInRange(indexOfCharacter, targetRange)
   }
   
}
