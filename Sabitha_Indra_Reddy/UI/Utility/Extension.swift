//
//  Extension.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 05/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import Foundation

private var AssociatedObjectHandle: UInt8 = 0

extension UINavigationBar {
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 40 // add 20 to account for the status bar
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage? {
        let cgcolors = colors.map { $0.cgColor }         // Turn the colors into CGColors
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)     // Begin the graphics context
        guard let context = UIGraphicsGetCurrentContext() else { return nil }  // If no context was retrieved, then it failed
        defer { UIGraphicsEndImageContext() }            // From now on, the context gets ended if any return happens
        var locations : [CGFloat] = [0.0, 0.5, 1.0, 1.0]        // Create the Coregraphics gradient
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        return UIGraphicsGetImageFromCurrentImageContext()   // Generate the image (the defer takes care of closing the context)
    }
}

// ******* MARK ******** Gradient Color for View ************** //
extension UIView {
     func applyGradient(colours: [UIColor]) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect (x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0.0, 0.5, 1.0, 1.0]   
        gradient.startPoint = CGPoint (x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint (x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5.5
    }
}

extension UIView {
    func roundedView() {
        let maskPath = UIBezierPath(roundedRect: CGRect (x: 0.0, y: 0.0, width: self.frame.width + 40, height: 50.0), byRoundingCorners: [.topLeft , .topRight], cornerRadii:CGSize (width: 7.0, height: 7.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UITextField {
    func underlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension UIViewController {
    func alertController(title: String?, message: String?, actionTitle: String, handler: ((UIAlertAction) -> Void)?)  {
        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction (title: actionTitle, style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UILabel {
    func changeDateFormat(date: String?, format: String, toChangeFormat: String) {
        guard let passDate = date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let newdate = dateFormatter.date(from: passDate) {
            dateFormatter.dateFormat = toChangeFormat
            self.text = dateFormatter.string(from: newdate)
        }
    }
}

extension UITextField {
    func getDateFormat(date: Date?, toChangeFormat: String) {
        guard let passDate = date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toChangeFormat
        let result = dateFormatter.string(from: passDate)
        self.text = result
    }
}

// To Dismiss Keyboard when touching anywhere on the View

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Extension for Image to convert to Data

extension UIImage
{
    var highestQualityJPEGNSData: NSData { return self.jpegData(compressionQuality: 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.25)! as NSData}
    @objc var lowestQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.10)! as NSData}
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}

extension UIViewController {
    func handleError(_ error:Error) {
        let alert = UIAlertController (title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction (title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: 'Roboto'; font-size: \(self.font!.pointSize-1); text-align:justify;\">%@</span>", htmlText)
        
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
        
        self.attributedText  = attrStr
    }
}

extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedText = attribute
    }
}

extension UILabel {
    func textHeight(withWidth width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.height(withWidth: width, font: font)
    }
    
    func attributedTextHeight(withWidth width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.height(withWidth: width)
    }
}

extension String {
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
}

extension NSAttributedString {
    func height(withWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}

extension UINavigationController {
    func addNavBarImage(imageName: UIImage) {
        let navController = UINavigationController()
        
        let imageView = UIImageView(image: imageName)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - imageName.size.width / 2
        let bannerY = bannerHeight / 2 - imageName.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

