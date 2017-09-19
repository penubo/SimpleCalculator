//
//  ViewController.swift
//  MyCalculator
//
//  Created by Joon on 30/08/2017.
//  Copyright © 2017 Joon. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        label.text = brain.labelAppend(of: sender.currentTitle!)
    }
    
    @IBAction func touchOperator(_ sender: UIButton) {
        brain.changeTypingMode(to: false)
        brain.performOperation(sender.currentTitle!)
        label.text = brain.result
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        if sender.currentTitle == "AC" {
            brain.allClear()
        } else {
            brain.clear()
        }
        label.text = brain.result
    }
    
    @IBAction func touchDelete(_ sender: UIButton) {
        label.text = brain.labelDrop()
    }
    
    @IBAction func touchDot(_ sender: UIButton) {
        if label.text!.characters.contains(".") {
            return
        } else {
            brain.changeTypingMode(to: true)
            label.text = brain.labelAppend(of: sender.currentTitle!)
        }
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

