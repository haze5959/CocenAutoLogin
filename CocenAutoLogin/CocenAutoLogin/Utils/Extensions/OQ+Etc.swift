//
//  OQ+Etc.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2021/01/11.
//

import UIKit

extension UIView {
    class func instanceFromNib() -> UIView {
        print(String(describing: Self.self))
        return UINib(nibName: String(describing: Self.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension UIViewController {
    /**
     addSubview
     */
    func addPopup(_ child: UIViewController, frame: CGRect? = nil) {
        self.addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        } else {
            child.view.frame = self.view.frame
        }
        
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /**
     removeFromSuperview
     */
    func removePopup() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

public extension UIWindow {
    /// UIApplication.shared.windows.first 리턴
    static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}

