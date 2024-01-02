//
//  JobPaymentVC.swift
//  CargoXpress
//
//  Created by infolabh on 01/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import PDFKit
import MobileCoreServices
class AddPostCell : UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDelete: LetsButton!
    
    var blockDeleteImage : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnTapOnDeleteCLK(_ sender: LetsButton) {
        if blockDeleteImage != nil {
            blockDeleteImage!()
        }
    }
}


class JobPaymentVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblJobNo: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var viewUploadDoc: LetsView!
    @IBOutlet weak var imgListView: LetsView!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblCarrierName: UILabel!
    @IBOutlet weak var imgCarierProfile: UIImageView!
    
    @IBOutlet weak var viewDriver: LetsView!
    
    struct DocData {
        var data : Data?
        var thumg : UIImage?
        var img : UIImage?
        var ext = ""
    }
    var docDataArray = [DocData]() {
        didSet {
            imgListView.isHidden = docDataArray.isEmpty
            viewUploadDoc.isHidden = !docDataArray.isEmpty
        }
    }
    
    var jobData = JobData()
    var jobBidData = JobBidData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accept & Pay"
        backButton(color: UIColor.white)
        imgListView.isHidden =  true
        viewUploadDoc.isHidden = false

        lblJobNo.text = "Job No: \(jobData.JobNo)\nDate  : \(jobData.PickupDate)"
        
        lblAmount.text = String(format: "$%.2f", jobBidData.Price)
        lblDays.text = "\(jobBidData.JobCompletionDays) Day"
        lblCarrierName.text = jobBidData.CarrierName
    
        lblCarrierName.text = jobData.DriverName
        self.viewDriver.isHidden = jobData.DriverName.isEmpty
        
        lblPickup.text = jobData.PickUpAddress
        lblDrop.text = jobData.DropOffAddress
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnCheckOutCLK(_ sender: UIButton) {
        let param = [ "Id": self.jobData.Id,
                      "JobBidId": jobBidData.Id]
        self.callAccceptBid(url: baseURL+URLS.Job_AcceptBid.rawValue, param) { (data) in
            MyBookingVC.isRefresh = true
            if self.docDataArray.count > 0 {
                self.index = 0
                self.uploadImage()
            } else {
                if appDelegate.isFindService {
                    showAlert("Job Assigned Successfully")
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    driverLeftSideMenu?.didselectTableViewCellAtIndex(index: 1)
                }
                
            }
        }
    }
    var index = 0
    func uploadImage() {
        let param = [
            "JobId":"\(self.jobData.Id)",
            "UserType":"3",
            "DocumentTypeId":"7"]
        callUploadImage(url: baseURL+URLS.JobDocuments_Upsert.rawValue, param: param, data: docDataArray[index]) { (data) in
            if data != nil {
                self.index = self.index + 1
                if self.docDataArray.count == self.index {
                    showAlert("Job Assigned Successfully")
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.uploadImage()
                }
            }
        }
    }
    
    @IBAction func btnUploadDocCLK(_ sender: UIButton) {
        self.choosePicker()
    }
    
    
}

extension JobPaymentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return docDataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCell", for: indexPath) as! AddPostCell
        if indexPath.row == 0 {
            cell.btnDelete.isHidden = true
            cell.imgView.image = #imageLiteral(resourceName: "ic_camera")
            cell.imgView.contentMode = .center
        } else {
            cell.btnDelete.isHidden = false
            if let img = docDataArray[indexPath.row-1].img {
                cell.imgView.image = img
            } else if let img = docDataArray[indexPath.row-1].thumg {
                cell.imgView.image = img
            } else {
                cell.imgView.image = nil
            }
            
            cell.imgView.contentMode = .scaleToFill
        }
        cell.blockDeleteImage = { () -> Void in
            self.docDataArray.remove(at: indexPath.row-1)
            self.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.choosePicker()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
}

extension JobPaymentVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate , UIDocumentPickerDelegate{
    func choosePicker() {
        let alertController = UIAlertController(title: "CargoXpress", message: "Select an option to choose photo", preferredStyle: (IS_IPAD ? UIAlertController.Style.alert : UIAlertController.Style.actionSheet))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action -> Void in
        })
        let doc = UIAlertAction(title: "Choose Document", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openDoucment()
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
            picker!.popoverPresentationController?.sourceView = collectionView
            picker!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            picker!.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 80, width: 0, height: 0)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.mediaType] as! String)  == "public.image"
        {
            let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var docData = DocData()
            docData.img = img
            self.docDataArray.append(docData)
            self.collectionView.reloadData()
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
                self.docDataArray.append(docData)
                self.collectionView.reloadData()
            } catch {}
            
        }
    }
    
    
    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
}
