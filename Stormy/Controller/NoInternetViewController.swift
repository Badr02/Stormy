//
//  NoInternetViewController.swift
//  Stormy
//
//  Created by Mohamed Adel on 10/11/2022.
//

import UIKit


class NoInternetViewController: UIViewController {
    
    let stormyManager = StormyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stormyManager.checkInternet()
        
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        
        if stormyManager.internetIsContected {
          dismiss(animated: true)
        }
    }
    
    
    @IBAction func goToSetting(_ sender: UIButton) {
        
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

    }
    
    
}
