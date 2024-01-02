//
//  AppURL.swift
//  iCognizance
//
//  Created by MickyBahu on 22/01/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import Foundation

var baseURL = "https://api.capitalworldguj.com/api/"

enum URLS : String {
    case ForgetPassword             =   "aspNetUsers/AspNetUsers_ForgetPassword?email="
    case LoginUsers                 =   "users/Users_SendOTP"
    case Users_ById                 =   "users/Users_ById?Id="
    case Users_Upsert               =   "users/Users_Upsert"
    case UserNotifications_All      =   "userNotifications/UserNotifications_ByUserId?UserId="
    case Transaction_ByUserId       =   "payment/Payment_ByUserId?UserId="
    case Payment_Upsert             =   "payment/Payment_Upsert"
    case Users_ChangePassword       =   "users/Users_ChangePassword"
    case Users_Logout               =   "users/Users_Logout?Id="
    case UploadedFiles_ByDate       =   "uploadedFiles/UploadedFiles_ByDate?ByDate="
    //case PaymentPlans_All           =   "paymentPlans/PaymentPlans_All"
    case Payment_Hash               =   "payment/Payment_Hash"
    case Country_All                =   "country/Country_All"
    case State_ByCountryId          =   "state/State_ByCountryId?CountryId="
    case City_ByStateId             =   "city/City_ByStateId?StateId="
    case Users_Force_Logout         =   "users/Users_Force_Logout?PhoneNumber="
}
