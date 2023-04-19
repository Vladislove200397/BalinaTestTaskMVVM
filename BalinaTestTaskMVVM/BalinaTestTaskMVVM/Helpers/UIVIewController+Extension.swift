//
//  UIVIewController+Extension.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 19.04.23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
