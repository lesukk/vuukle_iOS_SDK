//
//  VuukleNewsViewController.swift
//  VukkleExample
//
//  Created by Valodya Galstyan on 11/22/20.
//  Copyright © 2020 MAC_7. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class VuukleNewsViewController: UIViewController {

    var wkWebView: WKWebView!
    var configuration = WKWebViewConfiguration()
    
    var urlString = ""
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    var cookies: [HTTPCookie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "VUUKLE NEWS"
        
        addWKWebView()
        self.navigationController?.setToolbarHidden(false, animated: true)
        if #available(iOS 13.0, *) {
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                style: .plain,
                target: self.wkWebView,
                action: #selector(WKWebView.goBack))
            self.backButton = backButton
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            let forwardButton = UIBarButtonItem(
                image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                style: .plain,
                target: self.wkWebView,
                action: #selector(WKWebView.goForward))
            self.forwardButton = forwardButton
        } else {
            // Fallback on earlier versions
        }
        
        navigationItem.rightBarButtonItems = [self.forwardButton!, self.backButton!]
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("updateWebViews"), object: nil)
    }
    
   @objc func configureWebView() {
            wkWebView.reload()
    }

    private func addWKWebView() {
        
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
        let cookies = HTTPCookieStorage.shared.cookies ?? [HTTPCookie]()
        cookies.forEach({ if #available(iOS 11.0, *) {
            config.websiteDataStore.httpCookieStore.setCookie($0, completionHandler: nil)
        } else {

        } })
                  
        wkWebView = WKWebView(frame: self.view.frame, configuration: config)
        self.view.addSubview(wkWebView)

        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        self.wkWebView.isHidden = true
        self.view.backgroundColor = .white
        
        if let url = URL(string: urlString) {
            wkWebView.load(URLRequest(url: url))
        }
    }
}

extension VuukleNewsViewController:  WKNavigationDelegate, WKUIDelegate  {
    // MARK: WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.wkWebView.isHidden = false
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in

                })
            }
        })
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        webView.load(navigationAction.request)
        webView.evaluateJavaScript("window.open = function(open) { return function (url, name, features) { window.location.href = url; return window; }; } (window.open);", completionHandler: nil)
        webView.evaluateJavaScript("window.close = function() { window.location.href = 'myapp://closewebview'; }", completionHandler: nil)
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        present(alertController, animated: true)
        alertController.addTextField(configurationHandler: nil)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
            completionHandler(alertController.textFields?.first?.text)
        }))
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        if navigationAction.navigationType == .other {
            openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "")
        }
        
        decisionHandler(.allow)
        return
    }
    
    private func openNewWindow(newURL: String) {
        if newURL == VUUKLE_FACEBOOK_LOGIN {
            self.openNewWindow(withURL: VUUKLE_FACEBOOK_LOGIN)
        } else if newURL == VUUKLE_TWITTER_LOGIN {
            self.openNewWindow(withURL: VUUKLE_TWITTER_LOGIN)
        } else if newURL == VUUKLE_GOOGLE_LOGIN {
            self.openNewWindow(withURL: VUUKLE_GOOGLE_LOGIN)
        } else if newURL.hasPrefix(VUUKLE_FB_SHARE) {
            self.openNewWindow(withURL: newURL)
        } else if newURL.hasPrefix(VUUKLE_TWITTER_SHARE) {
            self.openNewWindow(withURL: newURL)
        } else if newURL == VUUKLE_PRIVACY {
            self.openNewWindow(withURL: VUUKLE_PRIVACY)
        } else if newURL == VUUKLE_RESET_PASSWORD {
            self.openNewWindow(withURL: VUUKLE_RESET_PASSWORD)
        }
    }
    
    func openNewWindow(withURL: String) {
        let newWindow = WindowViewController()
        newWindow.wkWebView = self.wkWebView
        newWindow.configuration = self.configuration
        newWindow.urlString = withURL
        self.navigationController?.pushViewController(newWindow, animated: true)
        
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(true)
    }
    

}
