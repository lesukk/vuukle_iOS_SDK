//
//  ViewController.swift
//  VukkleExample
//
//  Created by MAC_7 on 12/21/17.
//  Copyright © 2017 MAC_7. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

final class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var containerForWKWebView: UIView!
    @IBOutlet weak var containerwkWebViewWithScript: UIView!
    @IBOutlet weak var someTextLabel: UILabel!
    @IBOutlet weak var heightWKWebViewWithScript: NSLayoutConstraint!
    @IBOutlet weak var heightWKWebViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var wkWebViewWithScript: WKWebView!
    private var wkWebViewWithEmoji: WKWebView!
    private let configuration = WKWebViewConfiguration()
    private var scriptWebViewHeight: CGFloat = 0
    
    let name = "Ross"
    let email = "email@sda"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VUUKLE"
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.configureWebView), name: NSNotification.Name("updateWebViews"), object: nil)
        
        configureWebView()
        askCameraAccess()
    }
   
    @objc func configureWebView() {
        addWKWebViewForScript()
        addWKWebViewForEmoji()
    }
    
    // Ask permission to use camera For adding photo in the comment box
    func askCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addWKWebViewForScript() {
        
        let contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: "signInUser('\(name)', '\(email)')",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController
        
        wkWebViewWithScript = WKWebView(frame: .zero, configuration: configuration)
        wkWebViewWithScript.navigationDelegate = self
        wkWebViewWithScript.uiDelegate = self
        self.containerwkWebViewWithScript.addSubview(wkWebViewWithScript)
        
        wkWebViewWithScript.translatesAutoresizingMaskIntoConstraints = false
        wkWebViewWithScript.scrollView.layer.masksToBounds = false

        wkWebViewWithScript.topAnchor.constraint(equalTo: self.containerwkWebViewWithScript.topAnchor).isActive = true
        wkWebViewWithScript.bottomAnchor.constraint(equalTo: self.containerwkWebViewWithScript.bottomAnchor).isActive = true
        wkWebViewWithScript.leftAnchor.constraint(equalTo: self.containerwkWebViewWithScript.leftAnchor).isActive = true
        wkWebViewWithScript.rightAnchor.constraint(equalTo: self.containerwkWebViewWithScript.rightAnchor).isActive = true
        
        // Added this Observer for detect wkWebView's scrollview contentSize height updates
        wkWebViewWithScript.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        wkWebViewWithScript.scrollView.isScrollEnabled = false
        if let url = URL(string: VUUKLE_IFRAME) {
            wkWebViewWithScript.load(URLRequest(url: url))
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let scroll = object as? UIScrollView {
                if scroll.contentSize.height > 0 {
                    self.heightWKWebViewWithScript.constant = scroll.contentSize.height
                    scriptWebViewHeight = scroll.contentSize.height
                }
            }
        }
    }
    
    private func addWKWebViewForEmoji() {
        wkWebViewWithEmoji = WKWebView(frame: .zero, configuration: configuration)
        
        self.containerForWKWebView.addSubview(wkWebViewWithEmoji)
        
        wkWebViewWithEmoji.translatesAutoresizingMaskIntoConstraints = false
        wkWebViewWithEmoji.topAnchor.constraint(equalTo: self.containerForWKWebView.topAnchor).isActive = true
        wkWebViewWithEmoji.bottomAnchor.constraint(equalTo: self.containerForWKWebView.bottomAnchor).isActive = true
        wkWebViewWithEmoji.leftAnchor.constraint(equalTo: self.containerForWKWebView.leftAnchor).isActive = true
        wkWebViewWithEmoji.rightAnchor.constraint(equalTo: self.containerForWKWebView.rightAnchor).isActive = true

        if let url = URL(string: VUUKLE_EMOTES) {
            wkWebViewWithEmoji.load(URLRequest(url: url))
        }
    }
    
    // MARK: - Clear cookie
    
    private func clearAllCookies() {
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    private func clearCookiesFromSpecificUrl(yourUrl: String) {
        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: URL(string: yourUrl)!)
        for cookie in cookies! {
            cookieStorage.deleteCookie(cookie as HTTPCookie)
        }
    }
    
    private func openNewWindow(newURL: String) {
        
        switch newURL {
        case VUUKLE_FACEBOOK_LOGIN, VUUKLE_TWITTER_LOGIN, VUUKLE_GOOGLE_LOGIN, VUUKLE_PRIVACY, VUUKLE_RESET_PASSWORD:
            wkWebViewWithScript.load(URLRequest(url: URL(string: "about:blank")!))
            self.openNewWindow(withURL: newURL)
        default: break
        }
        
        if newURL.hasPrefix(VUUKLE_FB_SHARE) || newURL.hasPrefix(VUUKLE_TWITTER_SHARE) {
            wkWebViewWithScript.load(URLRequest(url: URL(string: "about:blank")!))
            self.openNewWindow(withURL: newURL)
        } else if newURL.hasPrefix(VUUKLE_NEWS_BASE_URL) {
            wkWebViewWithScript.load(URLRequest(url: URL(string: "about:blank")!))
            self.openNewsWindow(withURL: newURL)
        }
    }
    
    // MARK: - WKNavigationDelegate methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                    // You can detect webView's scrollView contentSize height
                })
            }
        })
    }
    
    // MARK: - WKUIDelegate methods
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        present(alertController, animated: true)
        alertController.addTextField(configurationHandler: nil)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            completionHandler(nil)
        }))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
            completionHandler(alertController.textFields?.first?.text)
        }))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "")
        
        webView.evaluateJavaScript("window.open = function(open) { return function (url, name, features) { window.location.href = url; return window; }; } (window.open);", completionHandler: nil)
        webView.evaluateJavaScript("window.close = function() { window.location.href = 'myapp://closewebview'; }", completionHandler: nil)
        
        return nil
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        self.heightWKWebViewWithScript.constant = scriptWebViewHeight
        if navigationAction.navigationType == .linkActivated {
                openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "")
            decisionHandler(.allow)
            return
        }
        decisionHandler(.allow)
        return
    }
    
    func openNewWindow(withURL: String) {
        let newWindow = WindowViewController()
        newWindow.wkWebView = self.wkWebViewWithScript
        newWindow.configuration = self.configuration
        newWindow.urlString = withURL
        self.navigationController?.pushViewController(newWindow, animated: true)
    }
    
    func openNewsWindow(withURL: String) {
        let newsWindow = VuukleNewsViewController()
        newsWindow.wkWebView = self.wkWebViewWithScript
        newsWindow.configuration = self.configuration
        newsWindow.urlString = withURL
        self.navigationController?.pushViewController(newsWindow, animated: true)
    }
    
}
