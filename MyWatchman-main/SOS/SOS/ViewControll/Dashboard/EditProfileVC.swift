//
//  EditProfileVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import Kingfisher
import UIKit

class EditProfileVC: UIViewController {
    @IBOutlet weak var txtFirst: LetsTextField!
    @IBOutlet weak var txtLast: LetsTextField!
    @IBOutlet weak var txtUser: LetsTextField!
    @IBOutlet weak var txtEmail: LetsTextField!
    @IBOutlet weak var txtCode: LetsTextField!
    @IBOutlet weak var txtMobile: LetsTextField!
    @IBOutlet weak var imgView: LetsImageView!
    
    var countryData : CountryData? {
        didSet {
            if let code = countryData {
                self.txtCode.text = code.CountryCode
            }
        }
    }
    var arrayCountry = [CountryData]() {
        didSet {
            if let data = arrayCountry.first {
                countryData = data
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Edit Profile"
        
        callGetCountryList { (datas) in
            self.arrayCountry = datas
            self.setupData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let info = UserInfo.savedUser() {
            self.callGetUserData(baseURL+URLS.GetCustomerById.rawValue+"\(info.Id)") { (info) in
                if let info = info {
                    info.save()
                    self.setupData()
                }
            }
        }
    }
    
    func setupData() {
        if let data = UserInfo.savedUser() {
            
            self.txtFirst.text = data.FirstName
            self.txtLast.text = data.LastName
            self.txtEmail.text = data.Email
            self.txtUser.text = data.UserName
            if !data.Mobile.isEmpty {
                if let country = self.arrayCountry.filter({$0.Id == data.CountryId}).first {
                    self.countryData = country
                    self.txtMobile.text = data.Mobile
                    self.txtCode.text = country.CountryCode
                }
            }
            if let str = data.ProfilePicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str) {
                let source = ImageResource(downloadURL: url)
                self.imgView.kf.setImage(with: source, placeholder:UIImage(named: "ic_profile"))
            }
        }
    }
    
    @IBAction func btnCodeClk(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrayCountry.compactMap({"\($0.CountryCode) (\($0.Name))"})) { (str, index) in
            self.countryData = self.arrayCountry[index]
        }
    }
    
    @IBAction func btnRegisterClk(_ sender: UIButton) {
        updateProfile()
    }
    
    @IBAction func btnUploadProfileClk(_ sender: UIButton) {
        choosePicker()
    }
    
    func updateProfile() {
        guard let country = self.countryData else {
            return
        }
        if txtMobile.text!.isEmpty {
            showAlert(popUpMessage.emptyPhone.rawValue)
            return
        }
        let param = ["Id":UserInfo.savedUser()!.Id,
                     "FirstName": txtFirst.text!,
                     "LastName": txtLast.text!,
                     "UserName": txtUser.text!,
                     "Email": txtEmail.text!,
                     "Mobile": txtMobile.text!,
                     "CountryId":country.Id] as [String : Any]
        
        if txtMobile.text! == UserInfo.savedUser()!.Mobile && UserInfo.savedUser()!.CountryId == country.Id {
            let url = baseURL+URLS.Signup.rawValue
            callPostUserDataAPI(url: url, param: param) { (info) in
                if let info = info {
                    info.save()
                    showAlert("Profile update successfully.")
                }
            }
        } else {
            let controll = LoginBord.instantiateViewController(identifier: "SecurityQuestionsVC") as! SecurityQuestionsVC
            controll.completionBlock = { () -> Void in
                let url = baseURL+URLS.Signup.rawValue
                self.callPostUserDataAPI(url: url, param: param) { (info) in
                    if let info = info {
                        info.save()
                        showAlert("Profile update successfully.")
                    }
                }
            }
            self.navigationController?.pushViewController(controll, animated: true)
        }
    }
    
    func validationSignUp() -> Bool
    {
        if  isEmptyString(txtFirst.text!) || isEmptyString(txtLast.text!) || isEmptyString(txtUser.text!) || isEmptyString(txtEmail.text!) || isEmptyString(txtMobile.text!) || isEmptyString(txtCode.text!) {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else{
            return true
        }
    }
    
}

extension EditProfileVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func choosePicker() {
        let alertController = UIAlertController(title: "", message: "Select an option to choose photo", preferredStyle: (IS_IPAD ? UIAlertController.Style.alert : UIAlertController.Style.actionSheet))
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
        picker?.allowsEditing = true
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        } else{
            picker!.modalPresentationStyle = .popover
            present(picker!, animated: true, completion: nil)//4
            picker!.popoverPresentationController?.sourceView = imgView
            picker!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            picker!.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 80, width: 0, height: 0)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.mediaType] as! String)  == "public.image"
        {
            let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            self.imgView.image = img.fixOrientation()
            self.callUploadProfileImage(img: img) { (info) in
                if let info = info {
                    info.save()
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
