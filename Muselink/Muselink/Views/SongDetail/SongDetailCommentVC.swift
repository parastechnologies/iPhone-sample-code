//
//  SongDetailCommentVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 25/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SongDetailCommentVC: UIViewController {
    @IBOutlet weak var img_Profile : SoftUIView!
    @IBOutlet weak var chatCollView : UICollectionView!
    @IBOutlet weak var txt_Message : SoftUIView!
    private   var dataSource       : TableViewDataSource<Cell_Comment,String>!
    private   lazy var chatTextView : GrowingTextView = {
        let textView = GrowingTextView()
        textView.delegate = self
        textView.placeholderColor = .placeholder
        textView.placeholder      = "Type Message..."
        textView.maxLength        = 500
        textView.maxHeight        = 250
        textView.minHeight        = 60
        textView.font             = .AvenirLTPRo_Regular(size: 18)
        textView.textColor        = .white
        textView.backgroundColor  = .clear
        return textView
    }()
    private lazy var sendButton : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onSendChat), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "send_arrow"), for: .normal)
        return btn
    }()
    private var img_UserProfile : UIImageView?
    @IBOutlet weak var inputViewContainerHeightConstraint: NSLayoutConstraint!
    weak var parentVC : SongDetailContainerVC?
    var viewmodel     : SongPopUpViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        viewmodel.didFibishFetch_Comment = {[weak self]  in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.chatCollView.reloadData()
                let lastItem = self.viewmodel.chatsArray.count - 1
                let indexPath = IndexPath(item: lastItem, section: 0)
                //        self.chatCollView.insertItems(at: [indexPath])
                self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpViews()
    }
    private func assignDelegates() {
        self.chatCollView.register(ChatDarkCell.self, forCellWithReuseIdentifier: ChatDarkCell.identifier)
        self.chatCollView.dataSource = self
        self.chatCollView.delegate = self
    }
    private func setUpViews() {
        img_Profile.type             = .normal
        img_Profile.cornerRadius     = img_Profile.frame.height/2
        img_Profile.mainColor        = UIColor.darkBackGround.cgColor
        img_Profile.darkShadowColor  = UIColor.black.cgColor
        img_Profile.lightShadowColor = UIColor.darkGray.cgColor
        img_UserProfile = img_Profile.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color: .white,border_Width: 2)
        
        txt_Message.type = .normal
        txt_Message.isSelected = true
        txt_Message.cornerRadius = 10
        txt_Message.mainColor = UIColor.darkBackGround.cgColor
        txt_Message.darkShadowColor = UIColor.black.cgColor
        txt_Message.lightShadowColor = UIColor.darkGray.cgColor
        txt_Message.borderWidth = 3
        txt_Message.borderColor = UIColor.black.cgColor
        txt_Message.isUserInteractionEnabled = true
        txt_Message.setButtonWithGrowingTextView(btn: sendButton, textView: chatTextView)
        img_UserProfile?.setImage(name: AppSettings.profileImageURL)
    }
    @IBAction func action_ViewAll() {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SongDetailCommentDetailVC") as! SongDetailCommentDetailVC
        newVC.viewmodel = viewmodel
        present(newVC, animated: true, completion: nil)
    }
    @IBAction func action_Emojis(_ sender : UIButton) {
        viewmodel.sendMessage(text: String.emojiArray[sender.tag])
        chatTextView.text = ""
    }
    @objc func onSendChat() {
        guard let chatText = chatTextView.text, chatText.count >= 1 else { return }
        viewmodel.sendMessage(text: chatText)
        chatTextView.text = ""
    }
}
extension SongDetailCommentVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.chatsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatCollView.dequeueReusableCell(withReuseIdentifier: ChatDarkCell.identifier, for: indexPath) as! ChatDarkCell
        if viewmodel.chatsArray.count <= indexPath.row {
            return cell
        }
        let chat = viewmodel.chatsArray[indexPath.item]
        cell.messageTextView.text = chat.comment
        cell.titleTextView.text = chat.userName
        if let imgURl = URL.init(string: NetworkManager.profileImageBaseURL + (chat.profileImage ?? "")) {
            cell.profileImageURL = imgURl
        }
        else {
            cell.profileImageURL = URL.init(string: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80")!
        }
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: chat.comment ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        estimatedFrame.size.height += 30
        
        let nameSize = NSString(string: chat.userName ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], context: nil)
        
        let maxValue = max(estimatedFrame.width, nameSize.width)
        estimatedFrame.size.width   = maxValue
        cell.profileImageView.frame = CGRect(x: 16, y:  16, width: 40, height: 40)
        cell.titleTextView.frame    = CGRect(x: 58 + 12, y:  16, width: 150, height: 20)
        cell.messageTextView.frame  = CGRect(x: 58 + 8, y: 32, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        cell.textBubbleView.frame   = CGRect(x: 0, y: 0, width: estimatedFrame.width + 16 + 8 + 16 + 12 + 58, height: estimatedFrame.height + 20 + 6)
        cell.bubbleImageView.image  = ChatDarkCell.grayBubbleImage
        cell.messageTextView.textColor = UIColor.white
        cell.titleTextView.textColor = UIColor.paleGray
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewmodel.chatsArray.count <= indexPath.row {
            return
        }
        let chat = viewmodel.chatsArray[indexPath.item]
        if let chatCell = cell as? ChatDarkCell {
            if let imgURl = URL.init(string: NetworkManager.profileImageBaseURL + (chat.profileImage ?? "")) {
                chatCell.profileImageURL = imgURl
            }
            else {
                chatCell.profileImageURL = URL.init(string: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80")!
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewmodel.chatsArray.count <= indexPath.row {
            return CGSize.zero
        }
        let chat = viewmodel.chatsArray[indexPath.item]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: chat.comment ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        estimatedFrame.size.height += 18
        
        return CGSize(width: chatCollView.frame.width, height: estimatedFrame.height + 20)
    }
}
extension SongDetailCommentVC: UITextFieldDelegate ,GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        inputViewContainerHeightConstraint.constant = height
    }
}
