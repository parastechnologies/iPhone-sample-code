//
//  InstagramWebView.swift
//  InstaApp
//
//  Created by Tushar Gusain on 25/11/19.
//  Copyright © 2019 Hot Cocoa Software. All rights reserved.
//

import UIKit
import WebKit

protocol InstagramWebViewDelegate : class {
    func fetchedInstagram(userID:Int)
}
class InstagramWebView: UIViewController  {
    @IBOutlet weak var webView : WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    //MARK:- Member variables
    var testUserData: InstagramTestUser?
    var instagramApi: InstagramApi      = InstagramApi.shared
    weak var delegate : InstagramWebViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        instagramApi.authorizeApp { [weak self](url) in
            DispatchQueue.main.async {
                self?.webView.load(URLRequest(url: url!))
            }
        }
    }
    @IBAction func action_Close() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension InstagramWebView : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.instagramApi.getTestUserIDAndToken(request: request) { (instagramTestUser) in
            print(instagramTestUser)
            self.delegate?.fetchedInstagram(userID: instagramTestUser.user_id)
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
