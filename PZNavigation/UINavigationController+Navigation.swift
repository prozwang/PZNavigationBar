//
//  UINavigationController+Navigation.swift
//  Navigator
//
//  Created by CIB on 2022/2/8.
//

import Foundation
import UIKit

extension UINavigationController {
    func updateNavigationBarForViewController(_ vc: UIViewController) {
        updateNavigationBarStyleForViewController(vc)
        updateNavigationBarTinitColorForViewController(vc)
        updateNavigationBarAlphaForViewController(vc)
        updateNavigationBarBackgroundForViewController(vc)
    }
}


//MARK: Private Methods
extension UINavigationController {
    func updateNavigationBarStyleForViewController(_ vc: UIViewController) {
        navigationBar.barStyle = vc.navigation.barStyle
    }
    
    func updateNavigationBarTinitColorForViewController(_ vc: UIViewController) {
        navigationBar.tintColor = vc.navigation.tintColor
        navigationBar.titleTextAttributes = vc.navigation.titleTextAttributes
        if #available(iOS 15.0, *) {
            guard (vc.navigation.titleTextAttributes != nil)  else { return }
            navigationBar.scrollEdgeAppearance?.titleTextAttributes = vc.navigation.titleTextAttributes!
            navigationBar.standardAppearance.titleTextAttributes = vc.navigation.titleTextAttributes!
        }
    }
    
    func updateNavigationBarAlphaForViewController(_ vc: UIViewController) {
        guard let bar = navigationBar as? NavigationBar  else {
            return
        }
        
        if vc.navigation.computedBarImage != nil {
            bar.fakeView.alpha = 0
            bar.backgroundImageView.alpha = vc.navigation.barAlpha
        } else {
            bar.fakeView.alpha = vc.navigation.barAlpha
            bar.backgroundImageView.alpha = 0
        }
        
        bar.shadowImageView.alpha = vc.navigation.computedBarShadowAlpha
        
    }
    
    func updateNavigationBarBackgroundForViewController(_ vc: UIViewController) {
        navigationBar.barTintColor = vc.navigation.computedBarTintColor
        guard let bar = navigationBar as? NavigationBar else {
            return
        }
        bar.backgroundImageView.image = vc.navigation.computedBarImage
    }
}
