//
//  PopupAddTruckVC.swift
//  CargoXpress
//
//  Created by infolabh on 09/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import PDFKit
import MobileCoreServices
import SafariServices

class PopupAddTruckVC: MyPopupController {

    @IBOutlet weak var txtTruckType: LetsTextField!
    @IBOutlet weak var txtPlateNum: LetsTextField!
    @IBOutlet weak var txtCompanyName: LetsTextField!
    @IBOutlet weak var txtInsurance: LetsTextField!
    @IBOutlet weak var txtRFIDTag: LetsTextField!
    @IBOutlet weak var txtLogBook: LetsTextField!
    @IBOutlet weak var txtCapacity: LetsTextField!
    @IBOutlet weak var txtImeiNum: LetsTextField!
    @IBOutlet weak var switchActive: UISwitch!
    @IBOutlet weak var lblInsurance: UILabel!
    @IBOutlet weak var lbllogBook: UILabel!
    @IBOutlet weak var btnInsurance: UIButton!
    @IBOutlet weak var btnlogBook: UIButton!
    
    @IBOutlet weak var viewInsurance: UIView!
    @IBOutlet weak var viewlogBook: UIView!
    @IBOutlet weak var viewActive: UIView!
    
    var docType = ""
    
    var infUrl = ""
    var logbUrl = ""
    
    struct DocData {
        var data : Data?
        var thumg : UIImage?
        var img : UIImage?
        var ext = ""
    }
    
    var selectedTruck : TruckTypeData?
    var truckTypeArray = [TruckTypeData]()
    
    var truckData : TruckData?
    
   override func viewDidLoad() {
        super.viewDidLoad()

    viewInsurance.isHidden = true
    viewlogBook.isHidden = true
    viewActive.isHidden = true
    callGetTruckTypeList { (data) in
            self.truckTypeArray = data
            
            if let data = self.objData as? TruckData {
                self.truckData = data
                self.setupData(data: data)
                self.callDoc(id: "\(data.Id)")
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    func setupData(data:TruckData) {
        if let t = self.truckTypeArray.filter({$0.Id == data.TruckTypeId}).first {
            self.selectedTruck = t
            self.txtTruckType.text = t.Name
        }
        
        self.txtPlateNum.text = data.PlateNumber
        self.txtCompanyName.text = data.CompanyName
        self.txtInsurance.text = data.Insurance
        self.txtRFIDTag.text = data.RfidTag
        self.txtLogBook.text = data.Logbook
        self.txtCapacity.text = "\(data.LoadCapacity)"
        self.txtImeiNum.text = data.Imei
        self.switchActive.setOn(data.IsActive, animated: true)
        
        self.viewInsurance.isHidden = false
        self.viewlogBook.isHidden = false
        self.viewActive.isHidden = false
    }

    @IBAction func btnTruckData(_ sender: UIButton) {
        let arr = self.truckTypeArray.compactMap({"\($0.Name)"})
        openDropDown(anchorView: sender, data: arr) { (str, index) in
               self.txtTruckType.text = str
               self.selectedTruck = self.truckTypeArray[index]
        }
    }

    @IBAction func btnCancelCLK(_ sender: UIButton) {
          if pressCancel != nil {
              pressCancel!()
          }
      }

      @IBAction func btnOkCLK(_ sender: UIButton) {
        if validationSignUp() {
            var param = [
                "PlateNumber": txtPlateNum.text!,
                "CarrierId": UserInfo.savedUser()!.Id,
                "TruckTypeId": selectedTruck!.Id,
                "Logbook": txtLogBook.text!,
                "CompanyName": txtCompanyName.text!,
                "Insurance": txtInsurance.text!,
                "RfidTag": txtRFIDTag.text!,
                "LoadCapacity": txtCapacity.text!,
                "Imei":txtImeiNum.text!
                ] as [String : Any]
            
            if let data = truckData {
                param["Id"] = data.Id
            }
            callInsertTruck(url: baseURL+URLS.Trucks_Upsert.rawValue, param) { (data) in
                if let data = data {
                    if self.pressOK != nil {
                        self.pressOK!(data)
                    }
                }
            }
        }
      }
    
    func callDoc(id:String) {
        
        callGetDocuemtnList(truckId: id) { (data) in
            let arr = data.compactMap({$0.DocumentType})
            if arr.contains("4") {
                self.lblInsurance.text = "Document Uploaded"
                self.btnInsurance.setTitle("   View File   ", for: UIControl.State.normal)
                if let dd = data.lastIndex(where: {$0.DocumentType == "4"}) {
                    self.infUrl = data[dd].UrlStr
                }
            }
            if arr.contains("3") {
                self.lbllogBook.text = "Document Uploaded"
                self.btnlogBook.setTitle("   View File   ", for: UIControl.State.normal)
                if let dd = data.lastIndex(where: {$0.DocumentType == "3"}) {
                    self.logbUrl = data[dd].UrlStr
                }
            }
        }
    }
    
    func openBrowser(url : String) {
        if let url = URL(string: url.replacingOccurrences(of: " ", with: "%20")) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func btnlogbookCLK(_ sender: UIButton) {
        if !logbUrl.isEmpty {
            self.openBrowser(url: logbUrl)
            return
        }
        docType = "logb"
        choosePicker(sender: sender)
    }
    @IBAction func btnInsCLK(_ sender: UIButton) {
        if !infUrl.isEmpty {
            self.openBrowser(url: infUrl)
            return
        }
        docType = "ins"
        choosePicker(sender: sender)
    }
    
    @IBAction func switchValueChange(_ sender:UISwitch) {
        callTruckActiveInActive(id: "\(truckData!.Id)") { (data) in
            if let data = data {
                self.truckData = data
                self.setupData(data: data)
            }
        }
    }
}

extension PopupAddTruckVC : UITextFieldDelegate {
        func validationSignUp() -> Bool
        {
            if  isEmptyString(txtPlateNum.text!) || isEmptyString(txtLogBook.text!) || isEmptyString(txtCompanyName.text!) || isEmptyString(txtInsurance.text!) || isEmptyString(txtRFIDTag.text!) || isEmptyString(txtCapacity.text!) || selectedTruck == nil  || isEmptyString(txtImeiNum.text!){
                showAlert(popUpMessage.emptyString.rawValue)
                return false
            }
            else{
                return true
            }
        }
}

extension PopupAddTruckVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.docType = ""
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
    
    
    func uploadDocumentData(data1 : DocData) {
        var param = [String : String]()
        var url = ""
        switch docType {
        case "logb":
            param = ["TruckId":"\(truckData!.Id)", "DocumentType":"3"]
            url = baseURL + URLS.TruckDocuments_Upsert.rawValue
            break
        case "ins":
            param = ["TruckId":"\(truckData!.Id)", "DocumentType":"4"]
            url = baseURL + URLS.TruckDocuments_Upsert.rawValue
            break
        default:
            break
        }
        print(param)
        callUploadImage(url:url , param: param, data: data1) { (data) in
            if let data = data {
                switch self.docType {
                case "logb":
                    self.lbllogBook.text = "Document Uploaded"
                    self.btnlogBook.setTitle("   View File   ", for: UIControl.State.normal)
                    self.logbUrl = data.UrlStr
                    break
                case "ins":
                    self.lblInsurance.text = "Document Uploaded"
                    self.btnInsurance.setTitle("   View File   ", for: UIControl.State.normal)
                    self.infUrl = data.UrlStr
                    break
                default:
                    break
                }
            }
            self.docType = ""
        }
    }
    
}
