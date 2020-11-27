//
//  WindowViewController.swift
//  VukkleExample
//
//  Created by Valodya Galstyan on 11/19/20.
//  Copyright © 2020 MAC_7. All rights reserved.
//

import UIKit
import WebKit

class WindowViewController: UIViewController {
    
    @IBOutlet weak var webConfigureView: UIView!
    var wkWebView: WKWebView!
    var configuration = WKWebViewConfiguration()
    
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        addWKWebView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        edgesForExtendedLayout = []
    }
    
    func setTitle() {
        switch urlString {
        case VUUKLE_FACEBOOK_LOGIN:
            self.title = "FACEBOOK LOGIN"
        case VUUKLE_GOOGLE_LOGIN:
            self.title = "GOOGLE LOGIN"
        case VUUKLE_TWITTER_LOGIN:
            self.title = "TWITTER LOGIN"
        default: break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("updateWebViews"), object: nil)
    }
    
    private func addWKWebView() {
        
        if urlString == VUUKLE_GOOGLE_LOGIN {
            configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        }
        
        wkWebView = WKWebView(frame: self.view.frame, configuration: configuration)
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

extension WindowViewController:  WKNavigationDelegate, WKUIDelegate  {
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
        
        if (navigationAction.request.url?.absoluteString ?? "") == VUUKLE_GOOGLE_LOGIN {
            self.configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
//            webView.load(navigationAction.request)
//            return WKWebView(frame: webView.frame, configuration: self.configuration)
        }
        //wkWebView = WKWebView(frame: self.view.frame, configuration: configuration)
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
        print("decidePolicyFor url = \(navigationAction.request.url?.absoluteString)")
            if(navigationAction.navigationType == .other) {
                if navigationAction.request.url != nil {
//                    if (navigationAction.request.url?.absoluteString ?? "").contains(VUUKLE_SOCIAL_LOGIN_SUCCESS) {
//                        self.wkWebView.reload()
//                        decisionHandler(.cancel)
//                        return
//                    }
                    //do what you need with url
                    if (navigationAction.request.url?.absoluteString.contains(VUUKLE_SOCIAL_LOGIN_SUCCESS))! {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                decisionHandler(.allow)
                return
            }
            decisionHandler(.allow)
        }
    
   
}
