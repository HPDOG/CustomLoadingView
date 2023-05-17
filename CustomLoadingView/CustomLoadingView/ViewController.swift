//
//  ViewController.swift
//  CustomLoadingView
//
//  Created by HPDOG on 2022/8/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customLoadingView = CustomLoadingView.init(frame: UIScreen.main.bounds)
        self.view.addSubview(customLoadingView)
    }
    
}
