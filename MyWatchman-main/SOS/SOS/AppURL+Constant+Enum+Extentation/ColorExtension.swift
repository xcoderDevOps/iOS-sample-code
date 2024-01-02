
import Foundation
import UIKit

extension UIColor {
    
    class func bgColor() -> UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    class func barTintColor() -> UIColor {
        return UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1.0)
    }
    
    class func barTintColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: alpha)
    }
    
    class func greenColor() -> UIColor {
        return UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
    }
    
    class func greenColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: alpha)
    }
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
