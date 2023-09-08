//
//  AlertManager.swift
//  bostaTask
//
//  Created by Abdelrahman on 08/09/2023.
//

import Foundation
import UIKit

class AlertManager{
    static let shared = AlertManager()
    
    public func alertConnectionError(message:String,viewController:UIViewController){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        viewController.present(alert,animated: true)
    }
}
