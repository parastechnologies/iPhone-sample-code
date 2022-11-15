//
//  HomeSearchVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 01/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class HomeSearchVC: BaseClassVC {
    @IBOutlet weak var txt_Search     : SoftUIView!
    @IBOutlet weak var btn_Search     : SoftUIView!
    @IBOutlet      var btn_SearchType : [SoftUIView]!
    @IBOutlet weak var btn_ClearText  : SoftUIView!
    @IBOutlet weak var tbl_Search     : UITableView!
    @IBOutlet weak var constraint_Height : NSLayoutConstraint!
    var txtField_Search : BindingTextField! {
        didSet {
            txtField_Search.bind{[unowned self] in self.viewmodel.searchText.value = $0 }
        }
    }
    var viewmodel : SoundProfileViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewmodel)
        viewmodel.searchAudioList.removeAll()
        tbl_Search.delegate   = viewmodel
        tbl_Search.dataSource = viewmodel
        tbl_Search.isHidden = true
        btn_ClearText.isHidden = true
        viewmodel.didFinishSearh = { [weak self] in
            DispatchQueue.main.async {
                if !(self?.viewmodel.searchAudioList.isEmpty ?? false) {
                    self?.btn_ClearText.isHidden = true
                }
                self?.tbl_Search.reloadArticleData {
                    self?.constraint_Height.constant = self!.tbl_Search.contentSize.height
                    self?.view.layoutSubviews()
                }
            }
        }
        viewmodel.didSelectSearchItem = { [weak self] (item) in
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "SongDetail", bundle: .main)
                let VC = storyBoard.instantiateViewController(withIdentifier: "SongDetailNavVC") as! UINavigationController
                VC.modalPresentationStyle = .custom
                VC.transitioningDelegate = self
                if let initVC = VC.viewControllers.first as? SongDetailContainerVC {
                    initVC.selectedAudio = item
                }
                self?.present(VC, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {[unowned self] in
            tbl_Search.isHidden = false
            btn_ClearText.isHidden = false
        }
    }
    private func setUpViews() {
        txt_Search.type             = .pushButton
        txt_Search.isSelected       = true
        txt_Search.cornerRadius     = 10
        txt_Search.mainColor        = UIColor.paleGray.cgColor
        txt_Search.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        txt_Search.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        txt_Search.borderWidth      = 3
        txt_Search.borderColor      = UIColor.white.cgColor
        txtField_Search = txt_Search.setBindingTextField(font: .Avenir_Medium(size: 16), placeholder: "Search",placeholderColor: .placeholder)
        
        btn_Search.type            = .pushButton
        btn_Search.addTarget(self, action: #selector(action_Search), for: .touchDown)
        btn_Search.cornerRadius    = 10
        btn_Search.mainColor       = UIColor.paleGray.cgColor
        btn_Search.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Search.borderWidth     = 2
        btn_Search.borderColor     = UIColor.white.cgColor
        btn_Search.setButtonImage(image: #imageLiteral(resourceName: "search"))
        
        btn_ClearText.type            = .pushButton
        btn_ClearText.addTarget(self, action: #selector(action_ClearText), for: .touchDown)
        btn_ClearText.cornerRadius    = 10
        btn_ClearText.mainColor       = UIColor.paleGray.cgColor
        btn_ClearText.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_ClearText.borderWidth     = 2
        btn_ClearText.borderColor     = UIColor.white.cgColor
        btn_ClearText.setButtonTitle(font: .Avenir_Medium(size: 16), title: "Clear History")
        
        for v in btn_SearchType {
            v.type            = .pushButton
            v.addTarget(self, action: #selector(action_SearchType), for: .touchDown)
            v.cornerRadius    = 10
            v.mainColor       = UIColor.paleGray.cgColor
            v.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
            v.borderWidth     = 2
            v.borderColor     = UIColor.white.cgColor
            if v.tag == 1 {
                v.setButtonTitle(font: .Avenir_Medium(size: 16), title: "All")
            }
            if v.tag == 2 {
                v.setButtonTitle(font: .Avenir_Medium(size: 16), title: "Location")
            }
            if v.tag == 3 {
                v.setButtonTitle(font: .Avenir_Medium(size: 16), title: "Username")
            }
            if v.tag == 4 {
                v.setButtonTitle(font: .Avenir_Medium(size: 16), title: "Full Name")
            }
        }
    }
    @IBAction func action_Close() {
        UIView.animate(withDuration: 0.5) {[unowned self] in
            tbl_Search.isHidden = true
            btn_ClearText.isHidden = true
        } completion: { (res) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    @objc private func action_SearchType(_ sender:SoftUIView) {
        if sender.tag == 1 {
            viewmodel.selectedSearchType = .All
        }
        else if sender.tag == 2 {
            viewmodel.selectedSearchType = .location
        }
        else if sender.tag == 3 {
            viewmodel.selectedSearchType = .userName
        }
        viewmodel.search()
    }
    @objc private func action_Search() {
        viewmodel.search()
    }
    @objc private func action_ClearText() {
        AppSettings.audioSearchHistory = ""
        tbl_Search.reloadData()
    }
}
extension HomeSearchVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
class Cell_SearchHistory: UITableViewCell {
    @IBOutlet weak var btn_Title:UIButton!
}
