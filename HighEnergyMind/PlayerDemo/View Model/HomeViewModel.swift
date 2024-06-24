//
//  HomeViewModel.swift
//  HighEnergyMind
//
//  Created by iOS TL on 29/03/24.
//

import Foundation
import UIKit

class HomeViewModel: NSObject, ViewModel {
    
    
    enum ModelType {
        
    }
    var modelType        : ApiType
    var brokenRules      : [BrokenRule]    = [BrokenRule]()
    var isValid          : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var showSuccessAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishGet: ((_ type:ApiType) -> ())?
    //    var valuePassClosure : (() -> (String,UITextField))?
    var valuePassClosure : ((String,UITextField) -> ())?
    var didFinishFetch: ((ApiType) -> ())?
    var didFinish:(() -> ())?
    var didFinishGunFetch: ((ApiType) -> ())?
    var didFinishSubmitProfileFetch: (() -> ())?
    var logoutClosure: (() -> ())?
    init(type:ApiType) {
        modelType = type
    }
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var message: String? {
        didSet { self.showAlertClosure?() }
    }
    var success: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var isLogout: Bool = false {
        didSet { self.logoutClosure?() }
    }
    
    
    var affirmationDetails          : [AffirmationDetailsData]?
    var trackDetails                : LastTrack?
}

extension HomeViewModel {
    private func Validate() {
//        switch modelType {
//
//}
//        default: break
        }
}

// MARK: - Network call
extension HomeViewModel {
    
    func markFavApi(Id: Int, favourite: Int, type: String) {
        Indicator.shared.show("")
        let model = NetworkManager.sharedInstance
        model.markFav(Id: Id, favourite: favourite, type: type) { [weak self] (result) in
            guard let self = self else{ return }
            Indicator.shared.hide()
            switch result{
            case .success(let res):
                print(res)
                DispatchQueue.main.async {
                    self.didFinishFetch?(.markFav)
                }
            case .failure(let err):
                switch err{
                case .errorReport(let desc, let statuscode):
                    print(desc)
                    self.error = desc
                    print(statuscode)
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func loadAffirmations() {
        if let url = Bundle.main.url(forResource: "affirmations", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let affirmationResponse = try decoder.decode(AffirmationDetailsModel.self, from: data)
                
                self.trackDetails = affirmationResponse.trackDetails
                self.affirmationDetails = affirmationResponse.data ?? []
                
                DispatchQueue.main.async {
                    self.didFinishFetch?(.markFav)
                }
                
                
                print(affirmationResponse)
            } catch {
                print("Error loading JSON data: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
}
