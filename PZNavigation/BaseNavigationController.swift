//
//  BaseNavigationController.swift
//  Navigator
//
//  Created by CIB on 2021/12/7.
//

import Foundation
import UIKit


//MARK: - BaseNavigationController
public class BaseNavigationController: UINavigationController {
    
    var panGesture: BaseNavigationGesture?
    lazy var fromFakeBar: UIVisualEffectView? = initFakeBar()
    lazy var toFakeBar: UIVisualEffectView? = initFakeBar()
    
    lazy var fromFakeShadow: UIImageView? = resetFakeShadow()
    lazy var toFakeShadow: UIImageView? = resetFakeShadow()
    
    public override var delegate: UINavigationControllerDelegate? {
        didSet {
            if delegate is BaseNavigationGesture || panGesture != nil {
                super.delegate = delegate
            } else {
                panGesture?.proxyDelegate = delegate
            }
        }
    }
    
    
    public override var interactivePopGestureRecognizer: UIGestureRecognizer? {
        return panGesture
    }
    
    public override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.navigation.barStyle == .black ? .lightContent : .default
    }
    
    public override var childForHomeIndicatorAutoHidden: UIViewController? {
        return topViewController
    }
    
    var fromFakeImageView: UIImageView? = UIImageView()
    var toFakeImageView: UIImageView? = UIImageView()
    weak var poppingViewController: UIViewController?
    
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        viewControllers = [rootViewController]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public override func viewDidLoad() {
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        if #available(iOS 15.0, *) {
            let scrollEdgeAppearance = UINavigationBarAppearance()
            scrollEdgeAppearance.configureWithTransparentBackground()
            scrollEdgeAppearance.shadowColor = UIColor.clear
            scrollEdgeAppearance.backgroundColor = UIColor.clear
            navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            navigationBar.standardAppearance = scrollEdgeAppearance.copy()
        }
        panGesture = BaseNavigationGesture(navigationController: self)
        panGesture?.proxyDelegate = delegate
        delegate = panGesture
        
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let _ = transitionCoordinator,
            let topViewController = topViewController {
            updateNavigationBarForViewController(topViewController)
        }
    }
    
    
    
    func superInteractivePopGestureRecognizer() -> UIGestureRecognizer? {
        return super.interactivePopGestureRecognizer
    }
    

    
    func showFakeBar(from: UIViewController, to: UIViewController) {
        guard let navigationBar = navigationBar as? NavigationBar else { return  }
        UIView.setAnimationsEnabled(false)
        navigationBar.fakeView.alpha = 0
        navigationBar.shadowImageView.alpha = 0
        navigationBar.backgroundImageView.alpha = 0
        showFakeBar(from: from)
        showFakeBar(to: to)
        UIView.setAnimationsEnabled(true)
    }
    
    func showFakeBar(from: UIViewController) {
        guard let fromFakeImageView = fromFakeImageView,
        let fromFakeShadow  = fromFakeShadow,
        let fromFakeBar = fromFakeBar else { return }
        
        let fakeBarFrame = fakeBarFrameForViewController(from)
        fromFakeImageView.image = from.navigation.computedBarImage
        fromFakeImageView.alpha = from.navigation.barAlpha
        fromFakeImageView.frame = fakeBarFrame
        from.view .addSubview(fromFakeImageView)
        
        fromFakeBar.subviews.last?.backgroundColor = from.navigation.computedBarTintColor
        fromFakeBar.alpha = (from.navigation.barAlpha == 0 || from.navigation.computedBarImage != nil) ? 0.01 : from.navigation.barAlpha
        
        if from.navigation.barAlpha == 0 || from.navigation.computedBarImage != nil {
            fromFakeBar.subviews.last?.alpha = 0.01
        }
        
        fromFakeBar.frame = fakeBarFrame
        from.view.addSubview(fromFakeBar)
        
        fromFakeShadow.alpha = from.navigation.computedBarShadowAlpha
        fromFakeShadow.frame = fakeShadowFrameWithBarFrame(fromFakeBar.frame)
        from.view.addSubview(fromFakeShadow)
    }
    
    func showFakeBar(to: UIViewController) {
        guard let toFakeImageView = toFakeImageView ,
        let toFakeShadow  = toFakeShadow,
        let toFakeBar = toFakeBar else { return }
        
        let fakeBarFrame = fakeBarFrameForViewController(to)
        toFakeImageView.image = to.navigation.computedBarImage
        toFakeImageView.alpha = to.navigation.barAlpha
        toFakeImageView.frame = fakeBarFrame
        to.view .addSubview(toFakeImageView)
        
        toFakeBar.subviews.last?.backgroundColor = to.navigation.computedBarTintColor
        toFakeBar.alpha = (to.navigation.barAlpha == 0 || to.navigation.computedBarImage != nil) ? 0.01 : to.navigation.barAlpha
        
        if to.navigation.barAlpha == 0 || to.navigation.computedBarImage != nil {
            toFakeBar.subviews.last?.alpha = 0.01
        }
        
        toFakeBar.frame = fakeBarFrame
        to.view.addSubview(toFakeBar)
        
        toFakeShadow.alpha = to.navigation.computedBarShadowAlpha
        toFakeShadow.frame = fakeShadowFrameWithBarFrame(toFakeBar.frame)
        to.view.addSubview(toFakeShadow)
    }
    
    func clearFake() {
        fromFakeBar?.removeFromSuperview()
        toFakeBar?.removeFromSuperview()
        fromFakeShadow?.removeFromSuperview()
        toFakeShadow?.removeFromSuperview()
        fromFakeImageView?.removeFromSuperview()
        toFakeImageView?.removeFromSuperview()
        
        fromFakeBar = initFakeBar()
        toFakeBar = initFakeBar()
        fromFakeShadow = resetFakeShadow()
        toFakeShadow = resetFakeShadow()
        fromFakeImageView = UIImageView()
        toFakeImageView = UIImageView()
    }
    
    func fakeBarFrameForViewController(_ vc: UIViewController) -> CGRect {
        guard let back = navigationBar.subviews.first else { return CGRect()}
        var frame = navigationBar.convert(back.frame, to: vc.view)
        frame.origin.x = 0
        if (vc.edgesForExtendedLayout.rawValue & UIRectEdge.top.rawValue) == 0 {
            frame.origin.y = -frame.size.height
        }
        
        if let scrollView = vc.view as? UIScrollView {
            scrollView.clipsToBounds = false
            if scrollView.contentOffset.y == 0 {
                frame.origin.y = -frame.size.height
            }
        }
        
        return frame
    }
    
    func resetFakeShadow() -> UIImageView {
        if let navigationBar = self.navigationBar as? NavigationBar {
            let shadow = UIImageView(image: navigationBar.shadowImageView.image)
            shadow.backgroundColor = navigationBar.shadowImageView.backgroundColor
            return shadow
        }
        return UIImageView()
    }
    
    func initFakeBar() -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .light))
    }
    
    func checkBackButtonCorrect() {
        if #available(iOS 13.0, *) {
            return
        }
        
        if #available(iOS 11.0, *),
        let coordinator = transitionCoordinator,
           coordinator.isInteractive,
        let topViewController = topViewController {
            navigationBar.barStyle = topViewController.navigation.barStyle
            navigationBar.titleTextAttributes = topViewController.navigation.titleTextAttributes
        }
    }
    
}



//MARK: BaseNavigationController - UINavigationBarDelegate
extension BaseNavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count > 1,
           let topViewController = topViewController,
           topViewController.navigationItem == item {
            if !topViewController.navigation.backInteractive {
                resetSubviewsInNavBar(navigationBar)
                return false
            }
            
        }

        return true
    }
    
    func resetSubviewsInNavBar(_ navBar: UINavigationBar) {
        guard #available(iOS 11, *) else {
            for (_ , element) in navBar.subviews.enumerated() {
                if element.alpha < 1 {
                    UIView.animate(withDuration: 0.25) {
                        element.alpha = 1.0
                    }
                }
            }
            return
        }
    }
    
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        poppingViewController = topViewController
        let array = super.popToViewController(viewController, animated: animated)
        checkBackButtonCorrect()
        return array
    }
    
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        poppingViewController = topViewController
        let array = super.popToRootViewController(animated: animated)
        checkBackButtonCorrect()
        return array
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        poppingViewController = topViewController
        let vc = super.popViewController(animated: animated)
        checkBackButtonCorrect()
        return vc
    }
}


//MARK: - BaseNavigationGesture
class BaseNavigationGesture: UIScreenEdgePanGestureRecognizer {
    
    weak var proxyDelegate: UINavigationControllerDelegate?
    weak var nav: BaseNavigationController?
    
    convenience init(navigationController: BaseNavigationController) {
        self.init()
        nav = navigationController
        edges = .left
        delegate = self
        navigationController.superInteractivePopGestureRecognizer()?.isEnabled = false
        navigationController.view.addGestureRecognizer(self)
        addTarget(self, action: #selector(handleNavigationTransition(_:)))
    }
    
    @objc
    func handleNavigationTransition(_ pan: UIScreenEdgePanGestureRecognizer) {
        guard let nav = nav else { return }
        if !(self.proxyDelegate?.responds(to: #selector(navigationController(_:interactionControllerFor:))) ?? false) {
            if let target = nav.superInteractivePopGestureRecognizer()?.delegate,
               target.responds(to: #selector(handleNavigationTransition(_:))) {
                target.perform(#selector(handleNavigationTransition(_:)), with: pan)
            }
            
        }
        guard #available(iOS 11.0, *) else {
            return
        }
        if let coordinator = nav.transitionCoordinator {
            if let from = coordinator.viewController(forKey: .from),
               let to = coordinator.viewController(forKey: .to),
                pan.state == .began || pan.state == .changed {
                nav.navigationBar.tintColor = blendColor(from: from.navigation.tintColor ?? UIColor.clear, to: to.navigation.tintColor ?? UIColor.clear, percent: coordinator.percentComplete)
            }
        }
    }
}

//MARK: BaseNavigationGesture - UIGestureRecognizerDelegate
extension BaseNavigationGesture: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = nav, nav.viewControllers.count > 1 else {
            return false
        }
        guard let topVC = nav.topViewController else { return true }
        return topVC.navigation.backInteractive
    }
    
    
}

//MARK: BaseNavigationGesture - UINavigationControllerDelegate
extension BaseNavigationGesture: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let proxyDelegate = proxyDelegate, proxyDelegate.responds(to: #selector(navigationController(_:willShow:animated:))) {
            proxyDelegate.navigationController?(navigationController, willShow: viewController, animated: animated)
        }
        
        if !viewController.navigation.extendedLayoutDidSet {
            adjustLayout(viewController)
            viewController.navigation.setExtendedLayoutDidSet(true)
        }
        
        guard let nav = nav else { return }
        
        if let coordinator = nav.transitionCoordinator {
            showViewController(viewController: viewController, coordinator: coordinator)
        } else {
            if !animated && nav.children.count > 1 {
                let last = nav.children[nav.children.count - 2]
                if shouldShowFake(viewController, from: last, to: viewController) {
                    nav.showFakeBar(from: last, to: viewController)
                    return
                }
            }
            nav.updateNavigationBarForViewController(viewController)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let proxyDelegate = proxyDelegate,
            proxyDelegate.responds(to: #selector(navigationController(_:didShow:animated:))) {
            proxyDelegate .navigationController?(navigationController, didShow: viewController, animated: animated)
        }
        guard let nav = nav else { return }
        if !animated {
            nav.updateNavigationBarForViewController(viewController)
            nav.clearFake()
        }
        
        nav.poppingViewController = nil
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        if let proxyDelegate = proxyDelegate,
           proxyDelegate.responds(to: #selector(navigationControllerSupportedInterfaceOrientations(_:))){
            return  proxyDelegate.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? .portrait
        }
        
        return .portrait
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if let proxyDelegate = proxyDelegate,
           proxyDelegate.responds(to: #selector(navigationController(_:interactionControllerFor:))){
            return proxyDelegate.navigationController?(navigationController, interactionControllerFor: animationController)
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let proxyDelegate = proxyDelegate,
           proxyDelegate.responds(to: #selector(navigationController(_:animationControllerFor:from:to:))){
            return proxyDelegate.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        }
        return nil
    }
    
    
    func showViewController(viewController: UIViewController, coordinator: UIViewControllerTransitionCoordinator) {
        guard let from = coordinator.viewController(forKey: .from),
           let to = coordinator.viewController(forKey: .to),
           let nav = nav,
        let navigationBar = nav.navigationBar as? NavigationBar else { return }
                
        nav.updateNavigationBarStyleForViewController(viewController)
        
        coordinator.animate { _ in
            let shouldFake = shouldShowFake(viewController, from: from, to: to)
            if shouldFake {
                nav.updateNavigationBarTinitColorForViewController(viewController)
                nav.showFakeBar(from: from, to: to)
            } else {
                nav.updateNavigationBarForViewController(viewController)
                if #available(iOS 15.0, *) , to == viewController {
                    navigationBar.scrollEdgeAppearance?.backgroundColor = viewController.navigation.computedBarTintColor
                    navigationBar.standardAppearance.backgroundColor = viewController.navigation.computedBarTintColor
                }
            }
        } completion: { context in
            nav.poppingViewController = nil
            if #available(iOS 15.0, *) {
                navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor.clear
                navigationBar.standardAppearance.backgroundColor = UIColor.clear
            }
            
            if context.isCancelled {
                if to == viewController {
                    nav.updateNavigationBarForViewController(viewController)
                }
            } else {
                nav.updateNavigationBarForViewController(viewController)
            }
            if to == viewController {
                nav.clearFake()
            }
        }
    }
}



//MARK: - Private Method
fileprivate func fakeShadowFrameWithBarFrame(_ frame: CGRect) -> CGRect {
    return CGRect(x: frame.origin.x, y: frame.size.height + frame.origin.y - 0.5, width: frame.size.width, height: 0.5)
}

fileprivate func blendColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
    var fromRed: CGFloat = 0.0
    var fromGreen: CGFloat = 0.0
    var fromBlue: CGFloat = 0.0
    var fromAlpha: CGFloat = 0.0
    from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
    
    var toRed: CGFloat = 0.0
    var toGreen: CGFloat = 0.0
    var toBlue: CGFloat = 0.0
    var toAlpha: CGFloat = 0.0
    to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
    
    let newRed = fromRed + (toRed - fromRed) * CGFloat(fminf(1, Float(percent) * 4))
    let newGreen = fromGreen + (toGreen - fromGreen) * CGFloat(fminf(1, Float(percent) * 4))
    let newBlue = fromBlue + (toBlue - fromBlue) * CGFloat(fminf(1, Float(percent) * 4))
    let newAlpha = fromAlpha + (toAlpha - fromAlpha) * CGFloat(fminf(1, Float(percent) * 4))
    return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
}

fileprivate func imageEqual(from: UIImage?, to: UIImage?) -> Bool{
    guard let from = from, let to = to else {
        return false
    }
    
    if from == to {
        return true
    }
    
    let dataFrom = from.pngData()
    let dataTo = to.pngData()
    guard let dataFrom = dataFrom, let dataTo = dataTo else { return false }
    return dataFrom == dataTo
}

fileprivate func imageHasAlpha(_ image: UIImage) -> Bool {
    guard let alpha: CGImageAlphaInfo = image.cgImage?.alphaInfo else {
        return false
    }
    
    return (alpha == .first ||
            alpha == .last ||
            alpha == .premultipliedFirst ||
            alpha == .premultipliedLast)
}

fileprivate func shouldShowFake(_ vc: UIViewController, from: UIViewController, to: UIViewController) -> Bool {
    if vc != to {
        return false
    }
    
    if imageEqual(from: from.navigation.computedBarImage, to: to.navigation.computedBarImage) {
        if abs(from.navigation.barAlpha - to.navigation.barAlpha) > 0.1 {
            return true
        }
        return false
    }
    
    if from.navigation.computedBarImage == nil && to.navigation.computedBarImage == nil && from.navigation.computedBarTintColor?.description == to.navigation.computedBarTintColor?.description {
        if abs(from.navigation.barAlpha - to.navigation.barAlpha) > 0.1 {
            return true
        }
        return false
    }
    
    return true
}

fileprivate func colorHasAlpha(_ color: UIColor?) -> Bool {
    guard let color = color else {
        return true
    }
 
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return a < 1.0
}

fileprivate func adjustLayout(_ vc: UIViewController) {
    var isTranslucent = vc.navigation.barHidden || vc.navigation.barAlpha < 1.0
    if !isTranslucent {
        if let image = vc.navigation.computedBarImage {
            isTranslucent = imageHasAlpha(image)
        } else {
            isTranslucent = colorHasAlpha(vc.navigation.computedBarTintColor)
        }
    }
    
    if isTranslucent || vc.extendedLayoutIncludesOpaqueBars {
        vc.edgesForExtendedLayout = [vc.edgesForExtendedLayout, .top]
    } else {
        vc.edgesForExtendedLayout = vc.edgesForExtendedLayout.union(.top)
    }
    
    if vc.navigation.barHidden,
       #available(iOS 11.0, *) {
        let insets = vc.additionalSafeAreaInsets
        let height = vc.navigationController?.navigationBar.bounds.size.height ?? 0
        vc.additionalSafeAreaInsets = UIEdgeInsets(top: -height + insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
}
