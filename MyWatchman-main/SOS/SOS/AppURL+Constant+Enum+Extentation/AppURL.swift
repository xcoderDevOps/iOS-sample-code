//
//  AppURL.swift
//  iCognizance
//
//  Created by MickyBahu on 22/01/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import Foundation

var baseURL = "https://api.my-watchman.com/api/"
let GooglePlaceKey = "AIzaSyDby5O_0c4dCBX50h_8RDYaXuA619oA9lY"
enum URLS : String {
    case GetAllCountryMaster        =   "countryMaster/GetAllCountryMaster"
    case LogIn                      =   "customer/LogIn"
    case Signup                     =   "customer/CustomerUpsert"
    case CustomerGenerateOTP        =   "customer/CustomerSigupByMobileExistsGenerateOTP?Mobile="
    case SecurityQuestionsSelectAll =   "securityQuestions/SecurityQuestionsSelectAll"
    case ForgotPassword             =   "customer/ForgotPassword?Email="
    case CustomerOtpMobileExists    =   "customer/CustomerGenrateOTPByMobileExists?Mobile="
    case ChangePassword             =   "customer/CustomerChangePassword"
    case GetCustomerById            =   "customer/GetCustomerById/"
    case CustomerAddrByCustomerId   =   "customer/CustomerAddressesByCustomerId"
    case AddCustomerAddress         =   "customer/AddCustomerAddress"
    case EmergencyContactUpsert     =   "customer/EmergencyContactUpsert"
    case ResendOtp                  =   "customer/ResendOtp?Mobile="
    case SOSByAddresIdCustomerId    =   "plan/SOSSelectAllByAddresIdAndCustomerId?"
    case GetSOSById                 =   "plan/GetSOSById/"
    case SOSSelectAllByCustomerId   =   "plan/SOSSelectAllByCustomerId?CustomerId="
    case NotificationByCustomerId   =   "customer/NotificationAllByCustomerId?CustomerId="
    case GetContactAll              =   "customer/EmergencyContactAllActive?CustomerId="
    case ContactByEmailcustomer     =   "customer/EmergencyContactSelectByEmail?ContactPhone="
    case CustomerAddressesDelete    =   "Customer/CustomerAddressesDelete?Id="
    case DeleteContact              =   "emergencyContact/EmergencyContactDeleteByCustomerId?CustomerId="
    case EmergencyConUpdateStatus   =   "customer/EmergencyContactUpdateStatus?id="
    case SubCustomerUpsert          =   "customer/SubCustomerUpsert"
    case GetSub_Customer_All        =   "customer/SubCustomerAll?CustomerId="
    case CustomerDelete             =   "customer/CustomerDelete?CustomerId="
    case SOSTypeAll                 =   "sOSType/SOSTypeAll"
    case SOSUpsert                  =   "plan/SOSUpsert"
    case SOSByCustomerId            =   "plan/SOSByCustomerId?CustomerId="
    case PlanSelectAll              =   "plan/PlanSelectAll"
    case SettingSelectAll           =   "plan/SettingSelectAll"
    case GetPlanDetails             =   "plan/GetPlanDetails?PlanId="
    case TransactionDetailsUpsert   =   "plan/TransactionDetailsUpsert"
    case cancelPlan                 =   "customer/UpdatePlanByCustomerId?CustomerId="
    case billingHistory             =   "plan/CustomersVSTransactionSelectAllByCustomerId?CustomerId="
    case getStatastic               =   "SOSType/GetSOSCountByCustomerId?CustomerId="
    case ProfilePictUpdate          =   "customer/CustomerProfilePictureUpdate?Id="
    case MedicalInfoUpsert          =   "medicalInfo/MedicalInfoUpsert"
    case InsuranceInfoUpsert        =   "insuranceInfo/InsuranceInfoUpsert"
    case RatingUpsert               =   "rating/RatingUpsert"
    case QuestionariesInsert        =   "user/QuestionariesInsert?"
    case SOSIsactiveORInactive      =   "plan/SOSIsactiveORInactive?Status=3&SosId="
    case MedicalInfoById            =   "medicalInfo/MedicalInfoById?Id="
    case InsuranceInfoById          =   "insuranceInfo/InsuranceInfoById?Id="
}
