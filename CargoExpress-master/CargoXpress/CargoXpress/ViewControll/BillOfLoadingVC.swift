//
//  PaymentVC.swift
//  CargoXpress
//
//  Created by infolabh on 07/07/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import PDFKit
import MobileCoreServices
import SafariServices

class BillOfLoadCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    var blockDelete : (()->())?
    
    @IBAction func btnDeleteCLK(_ sender: UIButton) {
        if blockDelete != nil {
            blockDelete!()
        }
    }
}

class BillOfLoadingVC: UIViewController {
    
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var btnChoseFile: UIButton!
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightTop: NSLayoutConstraint!
    
    var selectedDoc : DocData? {
        didSet {
            lblFile.text = "Receipt Selected"
        }
    }
    
    var jobId = ""
    
    struct DocData {
        var data : Data?
        var thumg : UIImage?
        var img : UIImage?
        var ext = ""
    }
    
    var arrPaymentData = [BillOfLoadingData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
        if appDelegate.isFindService {
            heightTop.constant = 250.0
            payView.isHidden = false
        } else {
            heightTop.constant = 0.0
            payView.isHidden = true
        }
        callListAPI()
        // Do any additional setup after loading the view.
    }
    
    func callListAPI() {
        let url = baseURL + URLS.JobBillOfLoading_All.rawValue + "\(jobId)"
        callPaymentListAPI(url: url) { (data) in
            self.arrPaymentData = data
            if !data.isEmpty {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            } else {
                self.tableView.isHidden = true
            }
        }
    }
    
    @IBAction func btnUploadImage(_ sender: UIButton) {
        choosePicker()
    }
    
    
    @IBAction func btnSubmitPaymenyClk(_ sender: Any) {
        if txtNotes.text!.isEmpty {
            showAlert("Please enter title for bill of loading")
            return
        } else if selectedDoc == nil {
            showAlert("Please select image")
            return
        } else {
            let param = ["JobId":jobId,
                         "BillOfLoading":txtNotes.text!]
            callUploadImage(url: baseURL + URLS.JobBillOfLoading_Upsert.rawValue, param: param, data: selectedDoc) { (data) in
                if let data = data {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension BillOfLoadingVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPaymentData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillOfLoadCell") as! BillOfLoadCell
        cell.btnDelete.isHidden = !appDelegate.isFindService
        cell.lblTitle.text = self.arrPaymentData[indexPath.row].BillOfLoading
        cell.blockDelete = { () -> Void in
            self.wsDeleteBillCLK(id: "\(self.arrPaymentData[indexPath.row].Id)") { (flag) in
                if let flag = flag, flag == true {
                    self.callListAPI()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openBrowser(url: self.arrPaymentData[indexPath.row].FileUrlStr)
    }
    
    func openBrowser(url : String) {
        if let url = URL(string: url.replacingOccurrences(of: " ", with: "%20")) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}

extension BillOfLoadingVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
    func choosePicker() {
        let alertController = UIAlertController(title: "CargoXpress", message: "Select an option to choose photo", preferredStyle: (IS_IPAD ? UIAlertController.Style.alert : UIAlertController.Style.actionSheet))
        let doc = UIAlertAction(title: "Choose Document", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openDoucment()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action -> Void in
        })
        let gallery = UIAlertAction(title: "Choose Photo", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openPicker(isCamera: false)
        })
        let camera = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openPicker(isCamera: true)
        })
        alertController.addAction(doc)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openPicker(isCamera : Bool){
        
        let picker:UIImagePickerController?=UIImagePickerController()
        
        if isCamera {
            picker!.sourceType = UIImagePickerController.SourceType.camera
        }else{
            picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        picker?.delegate = self
//        picker?.allowsEditing = true
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        } else{
            picker!.modalPresentationStyle = .popover
            present(picker!, animated: true, completion: nil)//4
            picker!.popoverPresentationController?.sourceView = btnChoseFile
            picker!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            picker!.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 80, width: 0, height: 0)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.mediaType] as! String)  == "public.image"
        {
            if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                var doc = DocData()
                doc.img = img
                selectedDoc = doc
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
                  docData.thumg = generatePdfThumbnail(of: CGSize(width: 100.0, height: 100.0), for: url, atPage: 0)
                self.selectedDoc = docData
              } catch {}
              
          }
      }
      
      func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
          let pdfDocument = PDFDocument(url: documentUrl)
          let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
          return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
      }
    
}
