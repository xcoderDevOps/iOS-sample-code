//
//  ValidationFile.swift
//  Pods
//
//  Created by Lokesh on 05/05/16.
//
//

import Foundation

public func checkInternet() ->Bool
{
    let status = LetsReach().connectionStatus()
    switch status {
    case .unknown, .offline:
        return false
    case .online(.wwan), .online(.wiFi):
        return true
    }
    
}

/*
public func jsonStringConvert(_ obj : AnyObject) -> String {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions.prettyPrinted)
        return  String(data: jsonData, encoding: String.Encoding.utf8)! as String
        
    } catch {
        return ""
    }
}
*/ 

//MARK: Validation Function

public func isEmptyString(_ text : String) -> Bool
{
    if text.trim == "" || text.trim.isEmpty
    {
        return true
    }
    else
    {
        return false
    }
    
}
public func validateEmailWithString(_ Email: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        return !(regex.firstMatch(in: Email, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, Email.count)) != nil)
    } catch {
        return true
    }
}

public func validatePasswordWithString(_ Password: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$", options: .caseInsensitive)
        return !(regex.firstMatch(in: Password, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, Password.count)) != nil)
    } catch {
        return true
    }
}

public func validePasswordWithLenght(_ text : String) ->Bool
{
    if text.count < 6 || text.count > 16
    {
        return true
    }
    else
    {
        return false
    }
}

public func validePhoneNumber(_ text : String)->Bool
{
    if text.count != 10
    {
        return true
    }
    else
    {
        return false
    }
}

func valideCardNumber(_ text : NSString)->Bool
{
    if text.length < 16 || text.length > 20
    {
        return true
    }
    else
    {
        return false
    }
}
