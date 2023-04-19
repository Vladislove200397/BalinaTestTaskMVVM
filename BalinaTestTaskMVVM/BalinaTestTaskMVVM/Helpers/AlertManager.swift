//
//  AlertManager.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 19.04.23.
//

import UIKit

class AlertManager {
    static func showAlert(on controller: UIViewController, title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                
            }
            alertController.addAction(okAction)
            controller.present(alertController, animated: true, completion: nil)
        }
}
