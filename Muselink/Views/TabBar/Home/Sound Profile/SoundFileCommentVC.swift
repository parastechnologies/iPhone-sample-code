//
//  SoundFileCommentVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 01/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SoundFileCommentVC: UIViewController {
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
        textView.textColor        = .darkBackGround
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
    weak var parentVC : HomeTabVC?
    var viewmodel     : SoundProfileViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        viewmodel.didFibishFetch_CommentAll = {[weak self]  in
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
        
        self.chatCollView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        self.chatCollView.dataSource = self
        self.chatCollView.delegate = self
    }
    private func setUpViews() {
        img_Profile.type             = .normal
        img_Profile.cornerRadius     = img_Profile.frame.height/2
        img_Profile.mainColor        = UIColor.paleGray.cgColor
        img_Profile.darkShadowColor  = UIColor.darkShadow.cgColor
        img_Profile.lightShadowColor = UIColor.lightShadow.cgColor
        img_UserProfile = img_Profile.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color: .white,border_Width: 2)
        
        txt_Message.type = .normal
        txt_Message.isSelected = true
        txt_Message.cornerRadius = 10
        txt_Message.mainColor = UIColor.paleGray.cgColor
        txt_Message.darkShadowColor = UIColor(white: 0, alpha: 0.10).cgColor
        txt_Message.lightShadowColor = UIColor(white: 1, alpha: 0.80).cgColor
        txt_Message.borderWidth = 3
        txt_Message.borderColor = UIColor.white.cgColor
        txt_Message.isUserInteractionEnabled = true
        txt_Message.setButtonWithGrowingTextView(btn: sendButton, textView: chatTextView)
        
        self.chatCollView.reloadData()
        let lastItem = self.viewmodel.chatsArray.count - 1 < 0 ? 0 : self.viewmodel.chatsArray.count - 1
        let indexPath = IndexPath(item: lastItem, section: 0)
        //        self.chatCollView.insertItems(at: [indexPath])
        self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
        txt_Message.isHidden = !AppSettings.hasLogin
        img_Profile.isHidden = !AppSettings.hasLogin
        img_UserProfile?.setImage(name: AppSettings.profileImageURL)
    }
    @IBAction func action_Emojis(_ sender : UIButton){
        if AppSettings.hasLogin {
            viewmodel.sendMessage(text: String.emojiArray[sender.tag])
            chatTextView.text = ""
        }
        else {
            let storyBoard = UIStoryboard(name: "Registration", bundle: .main)
            let VC = storyBoard.instantiateViewController(withIdentifier: "RegistrationNavVC")
            VC.modalPresentationStyle = .custom
            VC.transitioningDelegate = self
            present(VC, animated: true, completion: nil)
        }
    }
    @objc func onSendChat() {
        guard let chatText = chatTextView.text, chatText.count >= 1 else { return }
        viewmodel.sendMessage(text: chatText)
        chatTextView.text = ""
    }
    @IBAction func action_Close() {
        dismiss(animated: true, completion: nil)
    }
}
extension SoundFileCommentVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.chatsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatCollView.dequeueReusableCell(withReuseIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
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
        estimatedFrame.size.width = maxValue
        cell.profileImageView.frame = CGRect(x: 16, y:  16, width: 40, height: 40)
        cell.titleTextView.frame    = CGRect(x: 58 + 12, y:  16, width: 150, height: 20)
        cell.messageTextView.frame  = CGRect(x: 58 + 8, y: 32, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        cell.textBubbleView.frame   = CGRect(x: 0, y: 0, width: estimatedFrame.width + 16 + 8 + 16 + 12 + 58, height: estimatedFrame.height + 20 + 6)
        cell.bubbleImageView.image  = ChatCell.grayBubbleImage
        cell.messageTextView.textColor = UIColor.black
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewmodel.chatsArray.count <= indexPath.row {
            return
        }
        let chat = viewmodel.chatsArray[indexPath.item]
        if let chatCell = cell as? ChatCell {
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
extension SoundFileCommentVC: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension SoundFileCommentVC: UITextFieldDelegate ,GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        inputViewContainerHeightConstraint.constant = height
    }
}
