//
//  PremiumViewModel.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 23/06/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import StoreKit
class PremiumViewModel :NSObject, ViewModel {
    enum SubscriptionType : String {
        case Monthly
        case Yearly
    }
    var brokenRules : [BrokenRule]    = [BrokenRule]()
    var isValid     : Bool = true
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishPayement: (() -> ())?
    var didSelectChat:((ChatUserModel)->())?
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var products      : [SKProduct] = [SKProduct]()
    var selectedSubscription = SubscriptionType.Yearly
}
extension PremiumViewModel {
    func fetchProductList() {
        isLoading = true
        IAPManager.shared.getProducts { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
                case .success(let products):
                    self.products = products
                    self.didFinishFetch?()
            case .failure(let error): self.error = error.errorDescription
            }
        }
    }
    func purchase(){
        var selectedProduct : SKProduct?
        for pro in products {
            switch selectedSubscription {
            case .Monthly:
                if pro.productIdentifier == "com.MonthlySubscription" {
                    selectedProduct = pro
                    break
                }
            case .Yearly:
                if pro.productIdentifier == "com.YearlySubscription" {
                    selectedProduct = pro
                    break
                }
            }
        }
        guard let product = selectedProduct else {
            self.error = "In App Purchase Product ID not found"
            return
        }
        
        if !IAPManager.shared.canMakePayments() {
            self.error = "In App Purchase canmot make payment"
        } else {
            isLoading = true
            IAPManager.shared.buy(product: product) { [weak self](result) in
                guard let self = self else {return}
                self.isLoading = false
                switch result {
                case .success(_): self.updateSubscriptionToServer()
                case .failure(let error): self.error = error.localizedDescription
                }
            }
        }
    }
    func updateSubscriptionToServer() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.addSubscription(transcationID: IAPManager.shared.transactionID, PaymanetID: IAPManager.shared.paymentID, amount: IAPManager.shared.amount, product: selectedSubscription.rawValue) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(_):
                self.didFinishPayement?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
}
