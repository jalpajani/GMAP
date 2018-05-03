//
//  EditAccountVC.swift
//  FinchCart
//
//  Created by vivek versatile on 06/12/17.
//  Copyright © 2017 Kaira NewMac. All rights reserved.
//

import UIKit
import ObjectMapper

class EditAccountVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var txtName: TextFieldDesign!
    @IBOutlet weak var txtMobileNo: TextFieldDesign!
    @IBOutlet weak var txtEmail: TextFieldDesign!
    @IBOutlet weak var txtDOB: IQDropDownTextField!
    
    var cameraController = UIImagePickerController()
    
    var dateFormatter = DateFormatter()
    var objResponse :  ServiceResponse<UploadProfilePictureResponseModel> = ServiceResponse()!
    
    var objEditProfileResponse :  ServiceResponse<UploadProfilePictureResponseModel> = ServiceResponse()!
    
    var currentUser = UserProfileResModel<address,GSTModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension EditAccountVC {
    @IBAction func btnClickedBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClickedCamera(_ sender: Any) {
        self.openCamera()
    }
    
    @IBAction func btnClickedSave(_ sender: UIButton) {
        if ValidationAll() {
            print("validation sucessfully call")
            EditProfileData()
        } else {
            print("validation error")
        }
    }
}

//MARK:- IQDropDownTextFieldDelegate
extension EditAccountVC : IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    func textField(_ textField: IQDropDownTextField, didSelect date: Date?) {
        self.txtDOB.setSelectedItem(self.dateFormatter.string(from: date!), animated: true)
     
    }
}

//MARK: - Validation Check
extension EditAccountVC {
    
    func ValidationAll() -> Bool{
        
        var falg:Bool = true
        if(self.Validation(textField: self.txtName) == false){
            falg = false
        }
        else if(self.Validation(textField: self.txtMobileNo) == false){
            falg = false
        }
        else if(self.Validation(textField: self.txtEmail) == false){
            falg = false
        }
        return falg
    }
    
    func Validation(textField: UITextField) -> Bool {
        var flag:Bool = true
        var flagRequired:Bool = true
        
        if textField == txtName {
            if (txtName.text?.isEmpty)! == true || (txtName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)! == true  {
                flagRequired = false
                flag = false
            }
        }
        else if textField == txtEmail {
            
            if txtEmail.text?.isEmpty == true {
                flagRequired = false
                flag = false
            } else {
                if Common().Validate(value: txtEmail.text!, Regex: RegularExpression.REGEX_EMAIL) != true {
                    flag = false
                    self.view.makeToast(message: ValidationMessage.emailError)
                }
            }
        }
        else if textField == txtMobileNo {
            if txtMobileNo.text?.isEmpty == true {
                flagRequired = false
                flag = false
            } else {
                if Common().Validate(value: txtMobileNo.text!, Regex: RegularExpression.REGEX_Mobile_NUMBER) != true {
                    flag = false
                    self.view.makeToast(message: ValidationMessage.mobileError)
                }
            }
        }
        if flagRequired == false {
            self.view.makeToast(message: msg_AllFields)
            return false
        }
        return flag
    }
}

extension EditAccountVC {
    func setView() {
        
        self.navigationBar.HeaderSet(self, leftBtnSlector: #selector(self.btnClickedBack(_:)), rightBtnSelector: nil, right1BtnSelector: nil,right2BtnSelector: nil)
        
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width/2.0
//        self.imgUserProfile.layer.borderColor = UIColor.clear.cgColor
//        self.imgUserProfile.layer.borderWidth = 1.0
//
        self.txtDOB.dropDownMode = .datePicker
        self.txtDOB.delegate = self
        self.txtDOB.datePickerMode = .date
        self.txtDOB.maximumDate = Date()
       
        if let name = self.currentUser.varName {
            self.txtName.text = name
            self.lblName.text = name
        }
        if let email = self.currentUser.varEmail {
            self.txtEmail.text = email
            self.lblEmail.text = email
        }
        if let phone = self.currentUser.varPhone {
            self.txtMobileNo.text = phone
        }
        let date = self.currentUser.varDOB
        if date != "" {
            let userDate = DateHelper().stringToNSDateConvert(strdate: date!, dateFormat: DateTimeFormate.Formate_yyyyMMdd)
            self.txtDOB.setDate(userDate as Date, animated: false)
        }
        
        if let imgUrl: URL = URL(string: (self.currentUser.varImage)!) {
            self.imgUserProfile?.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: AppImageName.Img_Placeholder))
        }
    }
    
}

extension EditAccountVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    ///ImagePicker method
    func startCameraFromViewController(_ viewController: UIViewController,sourceType:UIImagePickerControllerSourceType, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) == false {
            return false
        }
        cameraController = UIImagePickerController()
        cameraController.sourceType = sourceType
        cameraController.allowsEditing = true
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                var selectedImage = UIImage()
                selectedImage = selectedImage.resizeImagewithSize(image: image, targetSize: CGSize(width: 200, height: 200))
                self.imgUserProfile.image = selectedImage
                var objParameter = ["" : ""]
                
                let userID = Preference.GetString(key: UserDefaultsKey.UserID)
                objParameter = ["intUser": userID!]
                self.UploadProfilePictureCall(imageView: selectedImage, parameter: objParameter)
            }
        }
        
    }
    
    func openCamera()
    {
        let actionSheetController: UIAlertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        cancelAction.setValue(AppColor.AppTheme_Primary, forKey: "titleTextColor")
        actionSheetController.addAction(cancelAction)
        
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            
            _ = self.startCameraFromViewController(self, sourceType:.photoLibrary, withDelegate:self)
            
        }
        actionSheetController.addAction(choosePictureAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            _ = self.startCameraFromViewController(self, sourceType: .camera, withDelegate: self )
            
        }
        actionSheetController.addAction(takePictureAction)
    }
}

extension EditAccountVC {
    
    func UploadProfilePictureCall(imageView:UIImage , parameter: [String:String]?) {
        let objDataProvider: UserDataProvider = UserDataProvider()
        
        objDataProvider.SaveImage(imageDataKey: UIImageJPEGRepresentation(imageView, 1.0)! as NSData, Parameter: parameter!,viewController:self) { (response, IsSuccess) -> Void in
            
            if IsSuccess! {
                self.objResponse = response!
                self.view.makeToast(message: self.objResponse.Message!)
            } else {
                self.view.makeToast(message: AppMessage.RequestFail)
            }
            
        }
    }
    
    func EditProfileData()
    {
        let objReq : EditUserReqModel = EditUserReqModel()
        objReq.intUser = Preference.GetString(key: UserDefaultsKey.UserID)
        objReq.varPhone = self.txtMobileNo.text
        objReq.varEmail = self.txtEmail.text
        objReq.varName = self.txtName.text
        objReq.varDOB = self.txtDOB.selectedItem
        let objDataProvider: UserDataProvider = UserDataProvider()
        
        objDataProvider.EditUser (reqModel:objReq, IsLoader: true, viewController: self) { (response, IsSuccess) -> Void in
            
            if IsSuccess! {
                self.objEditProfileResponse = response!
                if (self.objEditProfileResponse.Data != nil) {
                    
                    Preference.PutString(key: UserDefaultsKey.UserNum, value: self.objEditProfileResponse.Data?.varPhone)
                    Preference.PutString(key: UserDefaultsKey.UserEmailID, value: self.objEditProfileResponse.Data?.varEmail)
                    
                    Preference.PutString(key: UserDefaultsKey.UserName, value: self.objEditProfileResponse.Data?.varName)
                    
                    Preference.PutString(key: UserDefaultsKey.ProfileUrl, value: self.objEditProfileResponse.Data?.varImage)
                    
                    Preference.PutString(key: UserDefaultsKey.DOB, value: self.objEditProfileResponse.Data?.varDOB)
                    
                   self.view.makeToast(message: self.objEditProfileResponse.Message!)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.view.makeToast(message: AppMessage.RequestFail)
            }
        }
    }
}
