//
//  NavigationBar.swift
//  Navigator
//
//  Created by CIB on 2022/1/21.
//

import Foundation
import UIKit

open class NavigationBar: UINavigationBar {
    
    lazy var fakeView: UIVisualEffectView = getFakeView()
    
    lazy var shadowImageView: UIImageView = getShadowImageView()
    
    lazy var backgroundImageView: UIImageView = getBackgroundImageView()
    
    open override var barTintColor: UIColor? {
        didSet(newValue) {
            guard let lastView = fakeView.subviews.last else {
                return
            }
            lastView.backgroundColor = newValue
            checkFakeView()
        }
    }
    
    open override var shadowImage: UIImage? {
        didSet(newValue) {
            guard (newValue != nil) else {
                self.shadowImageView.backgroundColor = nil
                return
            }
            self.shadowImageView.image = newValue
            self.shadowImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 77.0/255)
        }
    }
    
}

// MARK: Private Methods
extension NavigationBar {
    fileprivate func checkFakeView() {
        UIView.setAnimationsEnabled(false)
        if fakeView.superview == nil {
            subviews.first?.insertSubview(fakeView, at: 0)
            fakeView.frame = fakeView.superview?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        if shadowImageView.superview == nil {
            subviews.first?.insertSubview(shadowImageView, aboveSubview: fakeView)
            shadowImageView.frame = CGRect(x: 0, y: shadowImageView.superview?.bounds.height ?? 0, width: shadowImageView.superview?.bounds.width ?? 0, height: 0.5)
        }
        
        if backgroundImageView.superview == nil {
            subviews.first?.insertSubview(backgroundImageView, aboveSubview: fakeView)
            backgroundImageView.frame = backgroundImageView.superview?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        UIView.setAnimationsEnabled(true)
    }
    
    fileprivate func getFakeView() -> UIVisualEffectView {
        super.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        let fakeView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        fakeView.isUserInteractionEnabled = false
        fakeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.subviews.first?.insertSubview(fakeView, at: 0)
        return fakeView
    }
    
    fileprivate func getShadowImageView() -> UIImageView {
        super.shadowImage = UIImage()
        let shadowImageView = UIImageView()
        shadowImageView.isUserInteractionEnabled = false
        shadowImageView.contentScaleFactor = 1
        self.subviews.first?.insertSubview(shadowImageView, aboveSubview: fakeView)
        return shadowImageView
    }
    
    fileprivate func getBackgroundImageView() -> UIImageView {
        let backgroundImageView = UIImageView()
        backgroundImageView.contentScaleFactor = 1
        backgroundImageView.isUserInteractionEnabled = false
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.subviews.first?.insertSubview(backgroundImageView, aboveSubview: fakeView)
        return backgroundImageView
    }
}

extension NavigationBar {
    class func navibarHeight(view: UIView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return 64 + view.safeAreaInsets.top
        } else {
            return 64
        }
    }
}


extension NavigationBar {
    open override func layoutSubviews() {
        super.layoutSubviews()
        fakeView.frame = fakeView.superview?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        shadowImageView.frame = CGRect(x: 0, y: shadowImageView.superview?.bounds.height ?? 0, width: shadowImageView.superview?.bounds.width ?? 0, height: 0.5)
        backgroundImageView.frame = backgroundImageView.superview?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    open override func setBackgroundImage(_ backgroundImage: UIImage?, for barMetrics: UIBarMetrics) {
        backgroundImageView.image = backgroundImage
        checkFakeView()
    }
}


