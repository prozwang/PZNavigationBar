//
//  NavigationItem.swift
//  Navigator
//
//  Created by CIB on 2022/1/21.
//

import UIKit
typealias ActionBlock = () -> Void
class NavigationItem: UIBarButtonItem {
    var actionBlock: ActionBlock?
    
    required init(_ title: String, image: UIImage?, action: ActionBlock?) {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        btn.setImage(image, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        if let cb = action {
            actionBlock = cb
        }
  
        super.init()
        customView = btn
        btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc private func clickAction() {
        guard let actionBlock = actionBlock else {
            return
        }
        actionBlock()
    }
    
}


