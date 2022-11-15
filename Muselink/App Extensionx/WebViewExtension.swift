//
//  WebViewExtension.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 19/04/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {
    func loadHTML(file:String) {
        if let url = Bundle.main.url(forResource: file, withExtension: "html") {
            let request = URLRequest(url: url)
            self.load(request)
        }
    }
}
