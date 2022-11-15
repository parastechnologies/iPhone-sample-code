//
//  ChatTabVC.swift
//  Muselink
//
//  Created by appsDev on 04/12/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit

class ChatTabVC: BaseClassVC {
    @IBOutlet weak var btn_Segment_One : SoftUIView!
    @IBOutlet weak var btn_Segment_two : SoftUIView!
    @IBOutlet weak var tbl_User        : UITableView!
    private var notificationImage  = UIImageView(image: #imageLiteral(resourceName: "notification_select"))
    private var umreadMessageImage = UIImageView(image: #imageLiteral(resourceName: "message"))
    private var notificationlabel  = UILabel()
    private var umreadMessagelabel = UILabel()
    private var viewModel : ChatTabViewModel! {
        didSet {
            tbl_User.dataSource = viewModel
            tbl_User.delegate   = viewModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChatTabViewModel()
        setUpVM(model: viewModel)
        viewModel.didFinishFetch = {[unowned self] in
            DispatchQueue.main.async {
                self.notificationlabel.text = "\(self.viewModel.notificationList.count)"
                self.umreadMessagelabel.text = "\(self.viewModel.chatUserList.count)"
                self.tbl_User.reloadData()
            }
        }
        viewModel.didSelectChat = { [unowned self]  (user) in
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            if user.senderID ?? "" == "\(AppSettings.userID)" {
                vc.receiverID   = user.receiverID ?? "0"
                vc.receiverName = user.receiverName  ?? ""
            }
            else {
                vc.receiverID   = user.senderID ?? "0"
                vc.receiverName = user.senderName ?? ""
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        setUpViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchNotifiactionList()
        viewModel.fetchChatUserList()
    }
    
    private func setUpViews() {
        viewModel.tableType = .Notification
        btn_Segment_One.type = .toggleButton
        btn_Segment_One.addTarget(self, action: #selector(action_Notification), for: .touchDown)
        btn_Segment_One.cornerRadius = 10
        btn_Segment_One.mainColor = UIColor.paleGray.cgColor
        btn_Segment_One.darkShadowColor = UIColor.darkShadow.cgColor
        btn_Segment_One.lightShadowColor = UIColor.lightShadow.cgColor
        btn_Segment_One.setButtonTitlewithImage(image: notificationImage,font: UIFont.AvenirLTPRo_Demi(size: 25.upperDynamic()), title: notificationlabel)
        btn_Segment_One.isSelected = true
        notificationImage.image  =  #imageLiteral(resourceName: "notification_select")
        
        btn_Segment_two.type = .toggleButton
        btn_Segment_two.addTarget(self, action: #selector(action_UnreadMessage), for: .touchDown)
        btn_Segment_two.cornerRadius = 10
        btn_Segment_two.mainColor = UIColor.paleGray.cgColor
        btn_Segment_two.darkShadowColor = UIColor.darkShadow.cgColor
        btn_Segment_two.lightShadowColor = UIColor.lightShadow.cgColor
        btn_Segment_two.setButtonTitlewithImage(image: umreadMessageImage,font: UIFont.AvenirLTPRo_Demi(size: 25.upperDynamic()), title: umreadMessagelabel)
        btn_Segment_two.isSelected = false
        umreadMessageImage.image =  #imageLiteral(resourceName: "message")
    }
    @objc private func action_Notification() {
        btn_Segment_two.isSelected = false
        btn_Segment_One.isSelected = true
        notificationImage.image  =  #imageLiteral(resourceName: "notification_select")
        umreadMessageImage.image =  #imageLiteral(resourceName: "message")
        viewModel.tableType = .Notification
        viewModel.fetchNotifiactionList()
    }
    @objc private func action_UnreadMessage() {
        btn_Segment_One.isSelected = false
        btn_Segment_two.isSelected = true
        umreadMessageImage.image   = #imageLiteral(resourceName: "message_select")
        notificationImage.image    = #imageLiteral(resourceName: "notification")
        viewModel.tableType = .UnreadMessage
        viewModel.fetchChatUserList()
    }
}

class Cell_ChatTab_Notification: UITableViewCell {
    @IBOutlet weak var view_Back   : SoftUIView!
    @IBOutlet weak var view_Image  : SoftUIView!
    @IBOutlet weak var lbl_Title   : UILabel!
    var imgView_profile            : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        view_Back.type             = .normal
        view_Back.cornerRadius     = 10
        view_Back.mainColor        = UIColor.paleGray.cgColor
        view_Back.darkShadowColor  = UIColor.darkShadow.cgColor
        view_Back.lightShadowColor = UIColor.lightShadow.cgColor
        view_Back.borderWidth      = 1
        view_Back.borderColor      = UIColor.brightPurple.cgColor
        view_Back.isUserInteractionEnabled = false
        
        view_Image.type            = .normal
        view_Image.cornerRadius    = view_Image.frame.height/2
        view_Image.mainColor       = UIColor.paleGray.cgColor
        view_Image.darkShadowColor = UIColor.darkShadow.cgColor
        view_Image.lightShadowColor = UIColor.lightShadow.cgColor
        view_Image.isUserInteractionEnabled = false
        imgView_profile = view_Image.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color:.white, border_Width: 2)
    }
}
class Cell_ChatTab_UnreadMessage: UITableViewCell {
    @IBOutlet weak var view_Back        : SoftUIView!
    @IBOutlet weak var view_Image       : SoftUIView!
    @IBOutlet weak var btn_OnlineStatus : UIButton!
    @IBOutlet weak var lbl_Title        : UILabel!
    var imgView_profile                 : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        view_Back.type             = .normal
        view_Back.cornerRadius     = 10
        view_Back.mainColor        = UIColor.paleGray.cgColor
        view_Back.darkShadowColor  = UIColor.darkShadow.cgColor
        view_Back.lightShadowColor = UIColor.lightShadow.cgColor
        view_Back.borderWidth      = 1
        view_Back.borderColor      = UIColor.brightPurple.cgColor
        view_Back.isUserInteractionEnabled = false
        
        view_Image.type            = .normal
        view_Image.cornerRadius    = view_Image.frame.height/2
        view_Image.mainColor       = UIColor.paleGray.cgColor
        view_Image.darkShadowColor = UIColor.darkShadow.cgColor
        view_Image.lightShadowColor = UIColor.lightShadow.cgColor
        view_Image.isUserInteractionEnabled = false
        imgView_profile = view_Image.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color:.white, border_Width: 2)
    }
}
