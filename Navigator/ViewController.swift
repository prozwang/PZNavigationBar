//
//  ViewController.swift
//  Navigator
//
//  Created by CIB on 2021/9/29.
//

import UIKit

class ViewController: UIViewController {

    var currentNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        view.addSubview(btn)
        
//        let bar: PZNavigationBar = navigationController?.navigationBar as! PZNavigationBar
        let red = (CGFloat)(arc4random() % 255) / 255.0
        let green = (CGFloat)(arc4random() % 255) / 255.0
        let blue = (CGFloat)(arc4random() % 255) / 255.0
        
        navigation.setBarTintColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        
        let colorView = UIView(frame: view.bounds)
        colorView.backgroundColor = UIColor.orange
        view.insertSubview(colorView, belowSubview: btn)
        title = "\(red)"
        navigation.setNeedsUpdateNavigationBar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigation.setNeedsUpdateNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("current number is", currentNumber)
    }

    @objc func clickBtn() -> Void {
        let vc = ViewController()
        vc.currentNumber = currentNumber + 1
        navigationController?.pushViewController(vc, animated: true)
    }

    

}

