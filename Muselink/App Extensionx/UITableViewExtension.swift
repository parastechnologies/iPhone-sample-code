//
//  UITableViewExtension.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 01/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
    func reloadArticleData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadDataWithAutoSizingCellWorkAround() })
        { _ in completion() }
    }
}
extension UICollectionView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
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
}
