//
//  Helpers.swift
//  CounterApp
//
//  Created by Gerardo on 2/12/19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    
    static let sharedInstance = Helpers()
    
    func showAlert(title: String, message:String, vc: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: Constants.Alert.titleBtnConfirm, style: .default, handler: nil)
        
        alert.addAction(confirmAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
}
