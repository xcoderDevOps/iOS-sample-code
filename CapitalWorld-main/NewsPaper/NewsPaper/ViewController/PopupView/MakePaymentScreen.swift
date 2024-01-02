//
//  MakePaymentScreen.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 24/02/22.
//

import Foundation
//import TraknPayObjC
import UIKit
import StoreKit
import SVProgressHUD
class MakePaymentScreen: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static var shared: MakePaymentScreen = {
        return MakePaymentScreen()
    }()
    
    var vc: UIViewController?
    var completionBlock : ((_ id:String)->())?
    
    var requestProd = SKProductsRequest()
    var products = [SKProduct]()
    
    func makePayment(vc: UIViewController, completionBlock : ((_ id:String)->())?) {
        SVProgressHUD.show()
        self.completionBlock = completionBlock
        self.vc = vc
        let request = SKProductsRequest(productIdentifiers: ["com.capitalworld.p3"])
        print(request)
        self.requestProd = request
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let pro = response.products.first {
            self.purchase(product: pro)
            /*
            let alertView = UIAlertController(title: "Confirm Your \nIn App Purchase", message: "Do you want to purchase our \n\(pro.localizedTitle) plan for \(pro.localizedPrice())" , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            if let popoverPresentationController = alertView.popoverPresentationController, let vc = self.vc {
                popoverPresentationController.sourceView = vc.view
                popoverPresentationController.sourceRect = vc.view.bounds
                alertView.popoverPresentationController?.permittedArrowDirections = []
            }
            self.vc?.present(alertView, animated: true, completion: nil)
            */
        }
    }
    
    func purchase(product : SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("The payment is being processed.")
                //getReceipt()
            case .purchased:
                //getReceipt()
                SKPaymentQueue.default().finishTransaction(transaction)
                if let id = transaction.transactionIdentifier {
                    print(id)
                    if self.completionBlock != nil {
                        self.completionBlock!(id)
                    }
                }
                
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let id = transaction.transactionIdentifier {
                    print(id)
                    if self.completionBlock != nil {
                        self.completionBlock!(id)
                    }
                }
                print("Payment restored successfully.")
            case .failed:
                showAlert("Payment Failed. Please try again.")
                print("Payment failed with error: \(transaction.error?.localizedDescription)")
            // Handle the error
            case .deferred:
                showAlert("Payment is waiting for outside action.")
                print("Payment is waiting for outside action.")
            default: break
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func getReceipt(){
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
                let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                let postString = "receipt-data=" + receiptString!
                print(postString)
                
                if self.completionBlock != nil {
                    self.completionBlock!(postString)
                }
            }
            catch{
                print("ERROR: " + error.localizedDescription)
            }
        }
    }
}

 

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
        
    }
}
