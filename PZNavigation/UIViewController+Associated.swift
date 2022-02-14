// 
//  UIViewController+Associated.swift
//  Navigator
//
//
//  Created by CIB on 2021/12/22.
//

import Foundation
import UIKit

fileprivate func getAssociateObj<T>(_ obj: AnyObject, _ key: UnsafeRawPointer, _ defaultValue: T? = nil) -> T? {
    guard let value = objc_getAssociatedObject(obj, key) as? T else {
        return defaultValue
    }
    return value
}

extension UIViewController: NavigationCompatible {}


// UIViewController Associate
public extension Navigation where Base: UIViewController  {

    func setBarStyle(_ barStyle: UIBarStyle) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.barStyleKey,
            barStyle,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    var barStyle: UIBarStyle {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.barStyleKey, UINavigationBar.appearance().barStyle)!
    }
    
    var barTintColor: UIColor? {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.barTintColorKey)
    }
    
    func setBarTintColor(_ value: UIColor) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.barTintColorKey,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    var barImage: UIImage? {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.barImageKey)
    }
    
    func setBarImage(_ value: UIImage) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.barImageKey,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    var tintColor: UIColor? {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.tintColorKey)
    }
    
    func setTintColor(_ value: UIColor) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.tintColorKey,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    var titleTextAttributes: [NSAttributedString.Key : Any]? {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        if let obj: [NSAttributedString.Key : Any]? = getAssociateObj(self.base, &AssociatedKeys.titleTextAttributesKey) {
            return obj
        }
        if let attributes = UINavigationBar.appearance().titleTextAttributes {
            guard attributes[.foregroundColor] != nil else {
                var mtArr = attributes
                var keyValue = [NSAttributedString.Key.foregroundColor: UIColor.white]
                if barStyle != .black {
                    keyValue = [NSAttributedString.Key.foregroundColor: UIColor.black]
                }
                mtArr.merge(keyValue) {oldKeyValue,_ in
                    return oldKeyValue
                }
                return mtArr
            }
            return attributes
        }
        
        if barStyle == .black {
            return [.foregroundColor : UIColor.white]
        } else {
            return [.foregroundColor : UIColor.black]
        }
    }
    
    func setTitleTextAttributes(_ value: [NSAttributedString.Key : Any]) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.titleTextAttributesKey,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    var extendedLayoutDidSet: Bool {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.extendedLayoutDidSetKey, false)!
    }
    
    func setExtendedLayoutDidSet(_ value: Bool) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.extendedLayoutDidSetKey,
            value,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    var barAlpha: Double {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.barAlphaKey, 1.0)!
    }
    
    func setBarAlpht(_ value: Double) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.barAlphaKey,
            value,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    var barHidden: Bool {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.barHiddenKey, false)!
    }
    
    func setBarHidden(_ value: Bool) {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        if value {
            self.base.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
            self.base.navigationItem.titleView = UIView()
        } else {
            self.base.navigationItem.leftBarButtonItem = nil
            self.base.navigationItem.titleView = nil
        }
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.barHiddenKey,
            value,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    var barShadowHidden: Bool {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.barShadowHiddenKey, false)!
    }
    
    func setBarShadowHidden(_ value: Bool)  {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.barShadowHiddenKey,
            value,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    var backInteractive: Bool {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return getAssociateObj(self.base, &AssociatedKeys.backInterActiveKey, true)!
    }
    
    func setBackInteractive(_ value: Bool)  {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        objc_setAssociatedObject(
            self.base,
            &AssociatedKeys.backInterActiveKey,
            value,
            .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }
    
    var barShadowAlpha: Double {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        if barShadowHidden {
            return 0
        }
        return barAlpha
    }
    
    var computedBarImage: UIImage? {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        guard let image = barImage else {
            if barTintColor != nil {
                return nil
            }
            return UINavigationBar.appearance().backgroundImage(for: .default)
        }
        return image
    }

    var computedBarShadowAlpha: Double {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        return barShadowHidden ? 0 : barAlpha
    }
    
    var computedBarTintColor: UIColor? {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this property"
        )
        if barHidden {
            return UIColor.clear
        }
        
        if barImage != nil {
            return nil
        }
        
        if let color = barTintColor {
            return color
        }
        
        if let _ = UINavigationBar.appearance().backgroundImage(for: .default) {
            return nil
        }
        
        guard let color = UINavigationBar.appearance().barTintColor else {
            return UINavigationBar.appearance().barStyle == .default ? UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 0.8) : UIColor(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 0.7)
        }
        
        return color
    }
}

public extension Navigation where Base: UIViewController  {
    func setNeedsUpdateNavigationBar() {
        assert(
            !(base is UINavigationController),
            "UINavigationController can't use this method"
        )
        guard let nav = self.base.navigationController else {
            return
        }
        if self.base == nav.topViewController {
            nav.updateNavigationBarForViewController(self.base)
            nav.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func updateNavigationBar() {
        
     
    }
}

extension Navigation where Base: UINavigationController {

}



private extension UINavigationItem {
    
    func copy(by navigationItem: UINavigationItem) {
        self.title = navigationItem.title
        self.prompt = navigationItem.prompt
    }
}
