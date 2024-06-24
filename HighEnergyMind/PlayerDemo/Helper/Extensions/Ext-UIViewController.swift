//
//  Ext-UIViewController.swift
//  ProBrowDesign
//
//  Created by admin on 25/08/23.
//

import Foundation
import UIKit

extension UIViewController {
    @discardableResult
    func presentVC(_ identifier: String, storyboard: UIStoryboard?, presentationStyle: UIModalPresentationStyle = .formSheet) -> UIViewController {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) else { return UIViewController() }
        viewController.modalPresentationStyle = presentationStyle
        self.present(viewController, animated: true, completion: nil)
        return viewController
    }
    
    @discardableResult
    func pushVC(_ identifier: String, storyboard: UIStoryboard?) -> UIViewController {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) else { return UIViewController() }
        self.navigationController?.pushViewController(viewController, animated: true)
        return viewController
    }
}

extension UIView {
    // MARK: - Action Block
    public func actionBlock(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
}

// MARK: -  UITapGestureRecognizer
class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}
