//
//  ViewController.swift
//  MyCalculator
//
//  Created by Joon on 30/08/2017.
//  Copyright © 2017 Joon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        label.text = sender.currentTitle ?? ""
    }
    
       override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

