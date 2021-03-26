//
//  ViewController.swift
//  ScannerApp
//
//  Created by Vinod VIshwakarma on 26/03/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func kioskMode(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ScannerViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}

