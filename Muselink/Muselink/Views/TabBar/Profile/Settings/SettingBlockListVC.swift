//
//  SettingBlockListVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 14/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SettingBlockListVC: BaseClassVC {
    @IBOutlet weak var btn_back    : SoftUIView!
    @IBOutlet weak var tbl_Blocked : UITableView!
    private   var dataSource :TableViewDataSource<Cell_BlockedAccount,BlockUserModel>!
    var viewModel : SettingsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.didFinishBlockingFetch = {[weak self] in
            self?.updateDataSource()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpViews()
        viewModel.fetchBlockedList()
    }
    private func updateDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: String.init(describing: Cell_BlockedAccount.self), items: viewModel.blockedList) {[unowned self] cell, vm in
            cell.view_Image.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color: .white,border_Width: 2)
            cell.lbl_Name.text = vm.userName
            cell.btn_unblock.tag = cell.tag
            cell.btn_unblock.addTarget(self, action: #selector(self.unblock_User(_:)), for: .touchUpInside)
        }
        self.tbl_Blocked.dataSource = self.dataSource
        self.tbl_Blocked.reloadData()
    }
    @objc private func unblock_User(_ sender:SoftUIView) {
        viewModel.unBlockAnUser(user: viewModel.blockedList[sender.tag])
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.paleGray.cgColor
        btn_back.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        btn_back.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        btn_back.borderWidth = 1
        btn_back.borderColor = UIColor.white.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "Back_black"))
    }
}
class Cell_BlockedAccount : UITableViewCell {
    @IBOutlet weak var lbl_Name  : UILabel!
    @IBOutlet weak var btn_unblock  : SoftUIView!
    @IBOutlet weak var view_Image   : SoftUIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_unblock.type             = .pushButton
        btn_unblock.cornerRadius     = 10
        btn_unblock.mainColor        = UIColor.paleGray.cgColor
        btn_unblock.darkShadowColor  = UIColor.darkShadow.cgColor
        btn_unblock.lightShadowColor = UIColor.lightShadow.cgColor
        btn_unblock.borderWidth      = 1
        btn_unblock.borderColor      = UIColor.white.cgColor
        btn_unblock.setButtonTitle(font: .Avenir_Medium(size: 16), title: "Unblock")
        
        view_Image.type             = .normal
        view_Image.cornerRadius     = view_Image.frame.height/2
        view_Image.mainColor        = UIColor.paleGray.cgColor
        view_Image.darkShadowColor  = UIColor.darkShadow.cgColor
        view_Image.lightShadowColor = UIColor.lightShadow.cgColor
        view_Image.borderWidth      = 2
        view_Image.borderColor      = UIColor.white.cgColor
    }
}
