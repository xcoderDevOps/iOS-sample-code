
import Foundation
import UIKit

extension UIColor {
    
    class func bgColor() -> UIColor {
        return UIColor(red: 240/255, green:  240/255, blue: 240/255, alpha: 1.0)
    }
    
    class func blueColor() -> UIColor {
        return UIColor(red: 115/255, green: 85/255, blue: 232/255, alpha: 1.0)
    }
    
    class func blueColor(alpha:CGFloat) -> UIColor {
        return UIColor(red: 115/255, green: 85/255, blue: 232/255, alpha: alpha)
    }
    
    class func avgColor(alpha:CGFloat) -> UIColor {
        return UIColor(red: 2/255, green: 151/255, blue: 219/255, alpha: alpha)
    }
}
