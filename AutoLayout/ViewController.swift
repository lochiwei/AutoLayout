//
//  ViewController.swift
//  AutoLayout
//
//  Created by pegasus on 2018/07/06.
//  Copyright © 2018年 Lo Chiwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubviews() {
        
        // background color
        let subviews: [UIView] = [b1, b2, v1, v2]
        let colors: [UIColor] = [#colorLiteral(red: 0.937254905700684, green: 0.34901961684227, blue: 0.192156866192818, alpha: 1.0), #colorLiteral(red: 0.341176480054855, green: 0.623529434204102, blue: 0.168627455830574, alpha: 1.0), #colorLiteral(red: 0.556862771511078, green: 0.352941185235977, blue: 0.968627452850342, alpha: 1.0), #colorLiteral(red: 0.466666668653488, green: 0.764705896377563, blue: 0.266666680574417, alpha: 1.0)]
        
        for i in 0...3 {
            subviews[i].backgroundColor = colors[i]
        }
        
        // auto layout
        let pad: CGFloat = 20
        subviews.usesAutolayout()
        
        b1.leading => view.leading + pad
        b1.trailing => b2.leading - pad
        b1.bottom => view.bottom - pad
        b1.top => v1.bottom + pad
        b1.firstBaseline => b2.firstBaseline
        
        b2.trailing => view.trailing - pad
        b2.width => b1.width
        
        v1.leading => view.leading + pad
        v1.trailing => view.trailing - pad
        v1.top => view.top + pad
        
        v2.centerX => v1.centerX
        v2.centerY => v1.centerY
        v2.width => 100
        v2.height => 100
    }

}

