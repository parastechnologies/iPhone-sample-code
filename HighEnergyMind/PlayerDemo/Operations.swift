//
//  Operations.swift
//  HighEnergyMind
//
//  Created by iOS TL on 22/02/24.
//

import Foundation
import UIKit

struct Operations {
    static let shared = Operations()
    
    func updateCollHeight(collectionView: UICollectionView, collHeight: NSLayoutConstraint, view: [UIView], completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            collHeight.constant = collectionView.contentSize.height
            for each in view {
                each.layoutIfNeeded()
            }
            completion()
        }
    }
    func updateCollWidth(collectionView: UICollectionView, collWidth: NSLayoutConstraint, view: [UIView], completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            collWidth.constant = collectionView.contentSize.width
            for each in view {
                each.layoutIfNeeded()
            }
            completion()
        }
    }
    func updateTblHeight(tableView: UITableView, tblHeight: NSLayoutConstraint, view: [UIView]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tblHeight.constant = tableView.contentSize.height
            for each in view {
                each.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - GRADIENT LAYOUT OPERATIONS
    func makeGradientLayer(view: UIView, layers: [CALayer], locations: [NSNumber]) {
        let gradientLayer = CAGradientLayer()
        
        let colorOne = UIColor.black
        let colorTwo = AppColor.app053343.cgColor
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        if !layers.isEmpty {
            addSublayers(layers: layers, view: view)
        }
    }
    
    func addSublayers(layers: [CALayer], view: UIView) {
        for each in layers {
            view.layer.addSublayer(each)
        }
    }
    
    func fadeInBg(bgView: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                bgView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
        }
    }
    
    func fadeOutBg(bgView: UIView, parentVC: UIViewController, completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1) {
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        } completion: { _ in
            parentVC.dismiss(animated: true) {
                completion()
            }
        }
    }
}
