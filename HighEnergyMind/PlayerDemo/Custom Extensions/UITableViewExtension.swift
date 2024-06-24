//
//  UITableViewExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 22/09/22.
//

import UIKit


extension UITableViewCell {

  func hideSeparator() {
    self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
  }

  func showSeparator() {
    self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

extension UITableView {
    
    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                    row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                    section: self.numberOfSections - 1)
               // if hasRowAtIndexPath(indexPath) {
                    self.scrollToRow(at: indexPath, at: .bottom, animated: true)
               // }
            }
    }
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func reloadRows(indexes: [IndexPath], completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadRows(at: indexes, with: .automatic) })
        { _ in completion() }
    }
    
    func reloadDataWithAutoSizingCellWorkAround() {
        
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
         
        
    }
    func reloadArticleData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadDataWithAutoSizingCellWorkAround()})
        { _ in completion() }
    }
    
    func setBottomInset(to value: CGFloat) {
            let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

            self.contentInset = edgeInset
            self.scrollIndicatorInsets = edgeInset
    }

}
