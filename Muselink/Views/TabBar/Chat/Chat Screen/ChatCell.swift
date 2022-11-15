//ChatCell.swift
/*
 * ChatUI
 * Created by penumutchu.prasad@gmail.com on 07/04/19
 * Is a product created by abnboys
 * For the ChatUI in the ChatUI
 
 * Here the permission is granted to this file with free of use anywhere in the IOS Projects.
 * Copyright © 2018 ABNBoys.com All rights reserved.
*/

import UIKit

class ChatCell: LKBaseCollectionViewCell {
    
    static let identifier = String(describing: ChatCell.self)
    
    private var imageCache = NSCache<NSString, UIImage>()
    var profileImageURL: URL? {
        didSet{
            self.fetchProfileImage(from: profileImageURL!)
        }
    }
    func fetchProfileImage(from url: URL) {
        
        //If image is available in cache, use it
        if let img = self.imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.profileImageView.image = img
            }
            //Otherwise fetch from remote and cache it for futher use
        } else {
            let session = URLSession.init(configuration: .default)
            session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImageView.image = img
                            self.imageCache.setObject(img, forKey: url.absoluteString as NSString)
                        }
                    }
                }
            }.resume()
        }
    }
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26))
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 30, bottom: 22, right: 30))
    
    var titleTextView: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    var textBubbleView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "SampleUser")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth   = 1
        imageView.layer.borderColor   = UIColor.white.cgColor
        return imageView
    }()
    
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatCell.blueBubbleImage
        return imageView
    }()
    
    var moreBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ChatMore"), for: .normal)
        return btn
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addSubview(titleTextView)
        addSubview(moreBtn)
        profileImageView.backgroundColor = UIColor.clear
        
        textBubbleView.addSubview(bubbleImageView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.messageTextView.text = nil
    }
}

class ChatDarkCell: LKBaseCollectionViewCell {
    
    static let identifier = String(describing: ChatDarkCell.self)
    
    private var imageCache = NSCache<NSString, UIImage>()
    var profileImageURL: URL? {
        didSet{
            self.fetchProfileImage(from: profileImageURL!)
        }
    }
    func fetchProfileImage(from url: URL) {
        
        //If image is available in cache, use it
        if let img = self.imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.profileImageView.image = img
            }
            //Otherwise fetch from remote and cache it for futher use
        } else {
            let session = URLSession.init(configuration: .default)
            session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImageView.image = img
                            self.imageCache.setObject(img, forKey: url.absoluteString as NSString)
                        }
                    }
                }
            }.resume()
        }
    }
    
    static let grayBubbleImage = UIImage(named: "bubble_darkGray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26))
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 30, bottom: 22, right: 30))
    
    var titleTextView: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.AvenirLTPRo_Demi(size: 15)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.AvenirLTPRo_Regular(size: 15)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    var textBubbleView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "SampleUser")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth   = 1
        imageView.layer.borderColor   = UIColor.white.cgColor
        return imageView
    }()
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatCell.blueBubbleImage
        return imageView
    }()
    var moreBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ChatMore"), for: .normal)
        return btn
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addSubview(titleTextView)
        addSubview(moreBtn)
        profileImageView.backgroundColor = UIColor.clear
        
        textBubbleView.addSubview(bubbleImageView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.messageTextView.text = nil
    }
}
