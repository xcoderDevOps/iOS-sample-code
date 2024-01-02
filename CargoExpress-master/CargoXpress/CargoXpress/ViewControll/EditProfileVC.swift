//
//  EditProfileVC.swift
//  UIDevelopment
//
//  Created by MickyBahu on 26/05/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import UIKit
import SafariServices
import PDFKit
import MobileCoreServices

class EditProfileVC: UIViewController {

    @IBOutlet weak var txtFirstName: LetsFloatField!
    @IBOutlet weak var txtLastName: LetsFloatField!
    @IBOutlet weak var txtCommodity: LetsFloatField!
    @IBOutlet weak var txtEmail: LetsFloatField!
    @IBOutlet weak var txtNumber: LetsFloatField!
    @IBOutlet weak var imgProfile: LetsImageView!
    
    @IBOutlet weak var btnTradingLicense: UIButton!
    @IBOutlet weak var btnTin: UIButton!
    @IBOutlet weak var btnRegistrant: UIButton!
    
    @IBOutlet weak var lblTradingLicense: UILabel!
    @IBOutlet weak var lblTin: UILabel!
    @IBOutlet weak var lblRegistrant: UILabel!
    
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var viewCompanyData: UIView!
    @IBOutlet weak var btnEye: UIButton!
    
    
    @IBOutlet weak var txtCompanyname: LetsFloatField!
    @IBOutlet weak var txtTrading: LetsFloatField!
    @IBOutlet weak var txtTin: LetsFloatField!
    @IBOutlet weak var txtRegistrant: LetsFloatField!
    
    var trdUrl = ""
    var tinUrl = ""
    var regUrl = ""
    
    var docType = ""
    struct DocData {
        var data : Data?
        var thumg : UIImage?
        var img : UIImage?
        var ext = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        updateUI()
        callGetUserData(url: baseURL+URLS.Shippers_ById.rawValue+"\(UserInfo.savedUser()!.Id)") { (info) in
            if let info = info {
                info.isFindService = appDelegate.isFindService
                info.save()
                self.updateUI()
            }
        }
        callDoc()
        // Do any additional setup after loading the view.
    }
    
    func callDoc() {
        callGetDocuemtnList { (data) in
            let arr = data.compactMap({$0.DocumentType})
            if arr.contains("6") {
                self.lblTradingLicense.text = "Document Uploaded"
                self.btnTradingLicense.setTitle("   View File   ", for: UIControl.State.normal)
                if let dd = data.lastIndex(where: {$0.DocumentType == "6"}) {
                    self.trdUrl = data[dd].UrlStr
                }
            }
            if arr.contains("5") {
                self.lblTin.text = "Document Uploaded"
                self.btnTin.setTitle("   View File   ", for: UIControl.State.normal)
                if let dd = data.lastIndex(where: {$0.DocumentType == "5"}) {
                    self.tinUrl = data[dd].UrlStr
                }
            }
            if arr.contains("2") {
                self.lblRegistrant.text = "Document Uploaded"
                self.btnRegistrant.setTitle("   View File   ", for: UIControl.State.normal)
                if let dd = data.lastIndex(where: {$0.DocumentType == "2"}) {
                    self.regUrl = data[dd].UrlStr
                }
            }
        }
    }
    
    func updateUI() {
        if let info = UserInfo.savedUser() {
            txtNumber.text = "+\(info.CountryCode) \(format(phoneNumber: info.PhoneNumber))"
            txtEmail.text = info.Email
            txtFirstName.text = info.FirstName
            txtLastName.text = info.LastName
            txtCommodity.text = info.CommodityGroups
            let str = info.FileUrlStr.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: str) {
                imgProfile.load(url:url)
            }
            viewCompanyData.isHidden = true
            btnEye.isHidden = true
            btnCompany.isSelected = false
            if info.IsCompany {
                btnCompany.isSelected = true
                viewCompanyData.isHidden = false
                btnEye.isHidden = false
                txtCompanyname.text = info.CompanyName
                txtTrading.text = info.TradingLicense
                txtTin.text = info.Tin
                txtRegistrant.text = info.RegistrantId
            }
        }
    }
    
    @IBAction func btnSubmitCLK(_ sender: LetsButton) {
        if validation() {
            if btnCompany.isSelected {
                let param = [     "Id":UserInfo.savedUser()!.Id,
                                  "FirstName" : txtFirstName.text!,
                                  "LastName" : txtLastName.text!,
                                  "CommodityGroups" : txtCommodity.text!,
                                  "TradingLicense":txtTrading.text!,
                                  "Tin":txtTin.text!,
                                  "RegistrantId":txtRegistrant.text!,
                                  "CountryId": UserInfo.savedUser()!.CountryId,
                                  "CompanyName":txtCompanyname.text!,
                                  "IsCompany": true
                                  ] as [String : Any]
                //Call Signup API
                
                callLoginSignUp(url: baseURL + URLS.ShipperSignup.rawValue, param) { (info) in
                    if let info = info {
                        info.isFindService = appDelegate.isFindService
                        info.save()
                    }
                }
            } else {
                let param = [     "Id":UserInfo.savedUser()!.Id,
                                  "FirstName" : txtFirstName.text!,
                                  "LastName" : txtLastName.text!,
                                  "CommodityGroups" : txtCommodity.text!,
                                  ] as [String : Any]
                //Call Signup API
                
                callLoginSignUp(url: baseURL + URLS.ShipperSignup.rawValue, param) { (info) in
                    if let info = info {
                        info.isFindService = appDelegate.isFindService
                        info.save()
                    }
                }
            }
            
        }
    }
    
    @IBAction func btnChangePassCLK(_ sender: LetsButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func btnuploadDocument(_ sender: LetsButton) {
        if sender == btnTradingLicense {
            docType = "tradinglicense"
            if !trdUrl.isEmpty {
                self.openBrowser(url: trdUrl)
                return
            }
        } else if sender == btnTin {
            docType = "tin"
            if !tinUrl.isEmpty {
                self.openBrowser(url: tinUrl)
                return
            }
        } else {
            docType = "registrant"
            if !regUrl.isEmpty {
                self.openBrowser(url: regUrl)
                return
            }
        }
        choosePicker(sender: sender)
    }
    
    func openBrowser(url : String) {
        if let url = URL(string: url.replacingOccurrences(of: " ", with: "%20")) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func btnProfileUpload(_ sender: LetsButton) {
        docType = "profile"
        choosePicker(sender: sender)
    }
    
    @IBAction func btnCompanyCLK(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewCompanyData.isHidden = !sender.isSelected
        btnEye.isHidden = !sender.isSelected
    }
    
    @IBAction func btnEyeTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtRegistrant.isSecureTextEntry = !sender.isSelected
    }
}


extension EditProfileVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFirstName || textField == txtLastName {
            if (string.isCharacterWithSpace) {
                let maxLength = 60
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            else {
                return false
            }
        }
        else if txtEmail == textField {
            if (string.isEmailString ) {
                let maxLength = 60
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            else {
                return false
            }
        }
        else if txtNumber == textField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
            return false
        }
        else {
            return true
        }
    }
    
    func validation() -> Bool {
        //|| txtNumber.text!.trim.isEmpty || txtEmail.text!.trim.isEmpty
        if txtFirstName.text!.trim.isEmpty || txtLastName.text!.trim.isEmpty || txtCommodity.text!.trim.isEmpty {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        } else if btnCompany.isSelected {
            if txtTrading.text!.trim.isEmpty || txtCompanyname.text!.trim.isEmpty {
                showAlert(popUpMessage.emptyString.rawValue)
                return false
            }
            else if self.lblTradingLicense.text == "No File Chosen" || self.lblTin.text == "No File Chosen"  || self.lblRegistrant.text == "No File Chosen" {
                showAlert("Please upload all document before update profile")
                return false
            } else {
                return true
            }
        }
        else {
            return true
        }
    }
}


extension EditProfileVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate{
    func choosePicker(sender : UIButton) {
        let alertController = UIAlertController(title: "", message: "Select an option to choose photo", preferredStyle: (IS_IPAD ? UIAlertController.Style.alert : UIAlertController.Style.actionSheet))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action -> Void in
        })
        let doc = UIAlertAction(title: "Choose Document", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openDoucment()
        })
        let gallery = UIAlertAction(title: "Choose Photo", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openPicker(isCamera: false, sender: sender)
        })
        let camera = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openPicker(isCamera: true, sender: sender)
        })
        if docType != "profile" {
            alertController.addAction(doc)
        }
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openDoucment() {
           let types: [String] = [String(kUTTypePDF)]
           let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
           documentPicker.delegate = self
           documentPicker.modalPresentationStyle = .formSheet
           self.present(documentPicker, animated: true, completion: nil)
       }
       func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
           guard let url = urls.first else {return}
           if let fileN = (url.absoluteString as NSString).lastPathComponent.removingPercentEncoding {
               let arr = fileN.components(separatedBy: ".")
               var docData = DocData()
               if let ext = arr.last {
                   docData.ext = ext
               }
               do {
                   docData.data  = try Data(contentsOf: url)
                   self.uploadDocumentData(data1: docData)
               } catch {}
               
           }
       }
    
    func openPicker(isCamera : Bool,sender : UIButton){
        
        let picker:UIImagePickerController?=UIImagePickerController()
        
        if isCamera {
            picker!.sourceType = UIImagePickerController.SourceType.camera
        }else{
            picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        picker?.delegate = self
        //picker?.allowsEditing = true
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        } else{
            picker!.modalPresentationStyle = .popover
            present(picker!, animated: true, completion: nil)//4
            picker!.popoverPresentationController?.sourceView = sender
            picker!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            picker!.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 80, width: 0, height: 0)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.mediaType] as! String)  == "public.image"
        {
            let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var data = DocData()
            data.img = img
            uploadDocumentData(data1: data)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadDocumentData(data1: DocData) {
        var param = [String : String]()
        var url = ""
        switch docType {
        case "tradinglicense":
            param = ["ShipperId":"\(UserInfo.savedUser()!.Id)", "DocumentType":"6"]
            url = baseURL + URLS.ShipperDocuments_Upsert.rawValue
            break
        case "tin":
            param = ["ShipperId":"\(UserInfo.savedUser()!.Id)", "DocumentType":"5"]
            url = baseURL + URLS.ShipperDocuments_Upsert.rawValue
            break
        case "registrant":
            param = ["ShipperId":"\(UserInfo.savedUser()!.Id)", "DocumentType":"2"]
            url = baseURL + URLS.ShipperDocuments_Upsert.rawValue
            break
        case "profile":
            param = ["Id":"\(UserInfo.savedUser()!.Id)"]
            url = baseURL + URLS.Shippers_ProfileUpdate.rawValue
            break
        default:
            break
        }
        
        callUploadImage(url:url , param: param, data: data1) { (data) in
            if let data = data {
                switch self.docType {
                case "tradinglicense":
                    self.lblTradingLicense.text = "Document Uploaded"
                    self.btnTradingLicense.setTitle("   View File   ", for: UIControl.State.normal)
                    self.trdUrl = data.UrlStr
                    break
                case "tin":
                    self.lblTin.text = "Document Uploaded"
                    self.btnTin.setTitle("   View File   ", for: UIControl.State.normal)
                    self.tinUrl = data.UrlStr
                    break
                case "registrant":
                    self.lblRegistrant.text = "Document Uploaded"
                    self.btnRegistrant.setTitle("   View File   ", for: UIControl.State.normal)
                    self.regUrl = data.UrlStr
                    break
                case "profile":
                    if let info = UserInfo.savedUser() {
                        info.FileUrlStr = data.FileUrlStr
                        info.isFindService = appDelegate.isFindService
                        info.save()
                    }
                    if let img = data1.img {
                        self.imgProfile.image = img
                    }
                    break
                default:
                    break
                }
            }
            self.docType = ""
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.docType = ""
    }
    
}
