

import Foundation
import UIKit
import DropDown

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


extension Data {
    public var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}

extension String {
    func isContaint(str : String) -> Bool{
        
        if self.lowercased().range(of: str.lowercased()) != nil {
            return true
        }
        return false
    }
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}


extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
   
}


extension UIViewController {
   
    func backButton(color : UIColor) {
        
        self.view.endEditing(true)
        let barButton = UIBarButtonItem()
        barButton.title = ""
        barButton.tintColor = color
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
    }

    func leftMenuButton()
    {
        self.title = leftSideMenu?.arrTitle[leftSideMenu!.selectedIndex]
        self.view.endEditing(true)
        let btn : UIBarButtonItem!
        btn = UIBarButtonItem(image:UIImage(named : "ic_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnDidTapOpen))
        self.navigationItem.leftBarButtonItem = btn
    }
    
    func leftDriverMenuButton()
    {
        self.title = driverLeftSideMenu!.arrTitle[driverLeftSideMenu!.selectedIndex]
        self.view.endEditing(true)
        let btn : UIBarButtonItem!
        btn = UIBarButtonItem(image:UIImage(named : "ic_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnDidTapOpen))
        self.navigationItem.leftBarButtonItem = btn
    }
    
    @objc func btnDidTapOpen()
    {
        self.view.endEditing(true)
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    func openCameraSettingForSetup() {
        alertShow(self, title: "This feature requires camera access", message: "In iPhone settings, tap on iCognizance and turn on camera", okStr: "Open Settings", cancelStr: "Not Now", okClick: {
            if let url = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
            }
        }) {
            
        }
    }
    
    public func alertShow(_ controller : UIViewController, title : String = "", message : String = "",okStr : String = "",cancelStr : String = "", okClick : (() -> ())? = nil, cancelClick : (() -> ())? = nil ) {
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        if okStr.count > 0 {
            alert.addAction(UIAlertAction(title: okStr, style: UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
                if let block = okClick {
                    block()
                }
            }));
        }
        alert.addAction(UIAlertAction(title: cancelStr.count > 0 ?  cancelStr : "Cancel", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
            if let block = cancelClick {
                block()
            }
        }));
        controller.present(alert, animated: true, completion: nil);
    }
    
    func openDatePicker(formate : String, mode: UIDatePicker.Mode = .dateAndTime, _ completionBlock : ((_ value : String)->())?)
    {
        view.endEditing(true)
        let style = RMActionControllerStyle.white
        
        let selectAction = RMAction<UIDatePicker>(title: "Select", style: RMActionStyle.done) { (controller) in
            if let pickerController = controller as? RMDateSelectionViewController
            {
                let formatter = DateFormatter.init()
                formatter.dateFormat = formate
                formatter.locale = Locale.current
                let date = formatter.string(from: pickerController.datePicker.date)
                
                if completionBlock != nil {
                    completionBlock!(date)
                }
            }
        }
        
        let cancelAction = RMAction<UIDatePicker>(title: "Cancel", style: RMActionStyle.cancel) { (_) in
            print("Row selection was canceled")
        }
        
        if let actionController = RMDateSelectionViewController(style: style, title: "CargoXpress", message: "Select Date", select: selectAction, andCancel: cancelAction)
        {
            actionController.datePicker.datePickerMode = mode
            if #available(iOS 13.4, *) {
                actionController.datePicker.preferredDatePickerStyle = .wheels
            } else {
                
            }
            self.present(actionController, animated: true, completion: nil)
        }
    }
}

extension DateFormatter
{
    func setLocal() {
        self.locale = Locale.init(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(abbreviation: "UTC")!
    }
}

extension Date {
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    var startOfDay: Date {
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    var yesterday: Date {
        let calendar = Calendar.current
        return (calendar as NSCalendar).date(byAdding: .day, value: -1, to: Date(), options: .matchStrictly)!.dateWithNoTime()
    }
    
    public func dateWithNoTime()->Date{
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: self)
        return date
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
}

extension UISearchBar {
    
    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}


extension Sequence where Iterator.Element == (key: String, value: Any) {
    var jsonString : String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)!
        }
        catch {
            return ""
        }
    }
}

extension String
{
    
    func makeAttributedText(attributedPortion:String)-> NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string:self)
        let range = (self as NSString).range(of: attributedPortion)

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)

        return attributedString
    }
    var jsonObject : [String: Any]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
            } catch {
                
            }
        }
        return nil
    }
    
    var encodeEmoji: String {
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr! as String
    }
    
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

//MARK:- Image Orientation fix

extension UIImage {
    
    func fixOrientation() -> UIImage {
        
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}


extension CALayer {
    func addGradienBorder(colors:[UIColor],width:CGFloat = 1,rect : CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: rect.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: rect).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        self.addSublayer(gradientLayer)
    }
}


extension UINavigationBar
{
    /// Applies a background gradient with the given colors
    func apply(gradient colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension UIViewController {
    func openDropDown(anchorView: UIView, data: [String], completionBlk : ((_ str : String, _ index : Int)->())?) {
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.dataSource = data
        dropDown.selectionAction = { (index: Int, item: String) in
            if completionBlk != nil {
                dropDown.hide()
                completionBlk!(item, index)
            }
        }
        dropDown.show()
    }
    
    func openCountryDropDown(anchorView: UIView, data: [CountryData], completionBlk : ((_ str : String, _ index : Int)->())?) {
        let dropDown = DropDown()
        dropDown.cellNib = UINib(nibName: "DropDownCustomCell", bundle: nil)
        dropDown.customCellConfiguration = {(index, item, cell) -> Void in
        guard let cell = cell as? DropDownCustomCell else { return }
            cell.imgView.image = nil
        }
        dropDown.anchorView = anchorView
        if !data.isEmpty {
            dropDown.dataSource = data.compactMap({"\($0.CountryCode) \($0.Name)"})
        }
        dropDown.selectionAction = { (index: Int, item: String) in
            if completionBlk != nil {
                dropDown.hide()
                completionBlk!(item, index)
            }
        }
        dropDown.show()
    }
}

func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
    guard !phoneNumber.isEmpty else { return "" }
    guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
    let r = NSString(string: phoneNumber).range(of: phoneNumber)
    var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

    if number.count > 10 {
        let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
        number = String(number[number.startIndex..<tenthDigitIndex])
    }

    if shouldRemoveLastDigit {
        let end = number.index(number.startIndex, offsetBy: number.count-1)
        number = String(number[number.startIndex..<end])
    }

    if number.count < 7 {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)

    } else {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
    }

    return number
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        var badgeWidth = 8
        var numberOffset = 4
        
        if number > 9 {
            badgeWidth = 12
            numberOffset = 6
        }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
