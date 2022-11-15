//
//  ChatVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 04/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import AVKit

class ChatVC: BaseClassVC {
    @IBOutlet weak var btn_back          : SoftUIView!
    @IBOutlet weak var btn_More          : SoftUIView!
    @IBOutlet weak var view_Bottom       : SoftUIView!
    @IBOutlet weak var btn_AddImages     : SoftUIView!
    @IBOutlet weak var View_TextViewback : SoftUIView!
    @IBOutlet weak var contentView       : UIView!
    @IBOutlet weak var chatCollView      : UICollectionView!
    @IBOutlet weak var lbl_ReceiverName  : UILabel!
    @IBOutlet weak var inputViewContainerBottomConstraint: NSLayoutConstraint!
    private var imagePicker : SKImagePicker!
    private lazy var chatTextView: GrowingTextView = {
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
    var isFromMatch  = false
    var receiverID   = ""
    var receiverName = ""
    private lazy var sendButton : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onSendChat), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "send_arrow"), for: .normal)
        return btn
    }()
    @IBOutlet weak var inputViewContainerHeightConstraint: NSLayoutConstraint!
    private var selectedItems   = [YPMediaItem]()
    private let selectedImageV  = UIImageView()
    private(set) var chatsArray : [ChatModel] = []
    private let viewmodel       = ChatSocketHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewmodel)
        imagePicker = SKImagePicker(presentationController: self, delegate: self)
        viewmodel.configureSocketClient(receiverID: Int(receiverID) ?? 0)
        assignDelegates()
        manageInputEventsForTheSubViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchChatData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.closeConnection()
    }
    private func setUpViews() {
        lbl_ReceiverName.text = receiverName
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_BackAndDismiss), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.paleGray.cgColor
        btn_back.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        btn_back.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        btn_back.borderWidth = 1
        btn_back.borderColor = UIColor.white.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "Back_black"))
        
        btn_More.type = .pushButton
        btn_More.addTarget(self, action: #selector(action_More), for: .touchDown)
        btn_More.cornerRadius = 10
        btn_More.mainColor = UIColor.paleGray.cgColor
        btn_More.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        btn_More.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        btn_More.setButtonImage(image: #imageLiteral(resourceName: "ChatMore"))
        
        view_Bottom.type = .normal
        view_Bottom.cornerRadius = 30
        view_Bottom.mainColor = UIColor.paleGray.cgColor
        view_Bottom.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        view_Bottom.borderWidth = 2
        view_Bottom.borderColor = UIColor.white.cgColor
        
        btn_AddImages.type = .pushButton
        btn_AddImages.addTarget(self, action: #selector(action_AddImage), for: .touchDown)
        btn_AddImages.cornerRadius = 10
        btn_AddImages.mainColor = UIColor.paleGray.cgColor
        btn_AddImages.darkShadowColor = UIColor(white: 0, alpha: 0.10).cgColor
        btn_AddImages.lightShadowColor = UIColor(white: 1, alpha: 0.8).cgColor
        btn_AddImages.setButtonImage(image: #imageLiteral(resourceName: "addImages"))
        
        View_TextViewback.type = .normal
        View_TextViewback.isSelected = true
        View_TextViewback.cornerRadius = 10
        View_TextViewback.mainColor = UIColor.paleGray.cgColor
        View_TextViewback.darkShadowColor = UIColor(white: 0, alpha: 0.10).cgColor
        View_TextViewback.lightShadowColor = UIColor(white: 1, alpha: 0.80).cgColor
        View_TextViewback.borderWidth = 3
        View_TextViewback.borderColor = UIColor.white.cgColor
        View_TextViewback.isUserInteractionEnabled = true
        View_TextViewback.setButtonWithGrowingTextView(btn: sendButton, textView: chatTextView)
    }
    @objc private func action_BackAndDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [unowned self] in
            if self.isFromMatch {
                navigationController?.dismiss(animated: true, completion: nil)
            }
            else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc private func action_More() {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ChatScreenMoreNavC") as! UINavigationController
        if let initVC = VC.viewControllers.first as? ChatScreenMoreVC {
            initVC.callback_Report = { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                    guard let self = self else {return}
                    //self.viewmodel.userBlock(receiverID: self.receiverID)
                }
            }
            initVC.callback_Block = { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                    guard let self = self else {return}
                    self.viewmodel.userBlock(receiverID: self.receiverID)
                }
            }
            initVC.callback_RemoveMatch = { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                    guard let self = self else {return}
                    self.viewmodel.removeMatch(receiverID: self.receiverID)
                }
            }
        }
        VC.modalPresentationStyle = .custom
        VC.transitioningDelegate = self
        tabBarController?.present(VC, animated: true, completion: nil)
    }
    private func fetchChatData() {
        viewmodel.fetchMessage(receiverID: receiverID)
        viewmodel.updateMessages = {[weak self] messages in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.chatsArray.append(contentsOf: messages)
                self.chatCollView.reloadData()
                let lastItem = self.chatsArray.count - 1
                let indexPath = IndexPath(item: lastItem, section: 0)
                //        self.chatCollView.insertItems(at: [indexPath])
                self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
        viewmodel.readMessage(receiverID: receiverID)
    }
    private func manageInputEventsForTheSubViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardFrameChangeNotfHandler(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            inputViewContainerBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    let lastItem = self.chatsArray.count - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    private func assignDelegates() {
        self.chatCollView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        self.chatCollView.register(ChatImageCell.self, forCellWithReuseIdentifier: ChatImageCell.identifier)
        self.chatCollView.dataSource = self
        self.chatCollView.delegate = self
    }
    @objc func onSendChat() {
        guard let chatText = chatTextView.text, chatText.count >= 1 else { return }
        viewmodel.sendMessage(message: chatText, receiverID: receiverID)
        chatTextView.text = ""
    }
    @objc private func action_AddImage() {
        imagePicker.present(from: btn_AddImages)
    }
}
// YPImagePickerDelegate
extension ChatVC: SKImagePickerDelegate {
    func didSelect(image: UIImage?, tag: Int) {
        if let img = image {
            viewmodel.uploadChatImage(image: img, receiverID: receiverID)
        }
    }
}

extension ChatVC: UIViewControllerTransitioningDelegate {
    // 2.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension ChatVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chat = chatsArray[indexPath.item]
        if chat.messageType ?? "Text" == "Text" || chat.messageType ?? "" == "" {
            let cell = chatCollView.dequeueReusableCell(withReuseIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
            cell.messageTextView.text = chat.message
            cell.profileImageURL = URL.init(string: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80")!
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedFrame = NSString(string: chat.message ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            estimatedFrame.size.height += 18
            
            let nameSize = NSString(string: chat.senderName ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], context: nil)
            
            let maxValue = max(estimatedFrame.width, nameSize.width)
            estimatedFrame.size.width = maxValue
            if chat.senderID ?? "" == "\(AppSettings.userID)" {
                cell.profileImageView.frame = CGRect(x: self.chatCollView.bounds.width - 48, y:  8, width: 40, height: 40)
                cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 40, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10 - 40, y: 0, width: estimatedFrame.width + 16 + 16 + 10, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = ChatCell.blueBubbleImage
                cell.messageTextView.textColor = UIColor.white
            } else {
                cell.profileImageView.frame = CGRect(x: 8, y:  8, width: 40, height: 40)
                cell.messageTextView.frame = CGRect(x: 58 + 8, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 58 - 10, y: 0, width: estimatedFrame.width + 16 + 8 + 16 + 12, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = ChatCell.grayBubbleImage
                cell.messageTextView.textColor = UIColor.black
            }
            return cell
        }
        else {
            let cell = chatCollView.dequeueReusableCell(withReuseIdentifier: ChatImageCell.identifier, for: indexPath) as! ChatImageCell
            cell.chatImageURL    = URL.init(string: NetworkManager.chatImageBaseURL + (chat.message ?? ""))!
            cell.profileImageURL = URL.init(string: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80")!
            if chat.senderID ?? "" == "\(AppSettings.userID)" {
                cell.profileImageView.frame = CGRect(x: self.chatCollView.bounds.width - 48, y:  8, width: 40, height: 40)
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - 240 - 16 - 16 - 16 - 10 - 40, y: 0, width: 240 + 16 + 16 + 10, height: 120 + 20 + 20)
                cell.chatImageView.frame = CGRect(x: collectionView.bounds.width - 240 - 16 - 20 - 40, y: 20, width: 240, height: 120)
                cell.bubbleImageView.image = ChatImageCell.blueBubbleImage
            } else {
                cell.profileImageView.frame = CGRect(x: 8, y:  8, width: 40, height: 40)
                cell.chatImageView.frame = CGRect(x: 58 + 8, y: 20, width: 240, height: 120)
                cell.textBubbleView.frame = CGRect(x: 58 - 10, y: 0, width: 240 + 16 + 8 + 16, height: 120 + 20 + 20 + 6)
                cell.bubbleImageView.image = ChatImageCell.grayBubbleImage
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let chat = chatsArray[indexPath.item]
        if let chatCell = cell as? ChatCell {
            chatCell.profileImageURL = URL.init(string: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80")!
        }
        if let chatCell = cell as? ChatImageCell {
            chatCell.profileImageURL = URL.init(string: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80")!
            chatCell.chatImageURL    = URL.init(string: NetworkManager.chatImageBaseURL + (chat.message ?? ""))!
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chat = chatsArray[indexPath.item]
        if chat.messageType ?? "Text" == "Text" || chat.messageType ?? "" == "" {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedFrame = NSString(string: chat.message ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            estimatedFrame.size.height += 18
            
            return CGSize(width: chatCollView.frame.width, height: estimatedFrame.height + 20)
        }
        else {
            return CGSize(width: chatCollView.frame.width, height: 170 )
        }

    }
    
}
extension ChatVC: UITextFieldDelegate ,GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        inputViewContainerHeightConstraint.constant = height
    }
}
