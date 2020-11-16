//
//  ViewController.swift
//  VukkleExample
//
//  Created by MAC_7 on 12/21/17.
//  Copyright © 2017 MAC_7. All rights reserved.
//

import UIKit
import WebKit

final class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWKWebViewForScript()
        addWKWebViewForEmoji()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addWKWebViewForScript() {
        let name = "Ross"
        let email = "email@sda"
        
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
        
        wkWebViewWithScript.topAnchor.constraint(equalTo: self.containerwkWebViewWithScript.topAnchor).isActive = true
        wkWebViewWithScript.bottomAnchor.constraint(equalTo: self.containerwkWebViewWithScript.bottomAnchor).isActive = true
        wkWebViewWithScript.leftAnchor.constraint(equalTo: self.containerwkWebViewWithScript.leftAnchor).isActive = true
        wkWebViewWithScript.rightAnchor.constraint(equalTo: self.containerwkWebViewWithScript.rightAnchor).isActive = true
        
        let urlString = "https://cdn.vuukle.com/widgets/index.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&darkMode=false&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New&post&22&url=https://smalltester.000webhostapp.com/2017/12/new-post-22&emotesEnabled=true&firstImg=&secondImg=&thirdImg=&fourthImg=&fifthImg=&sixthImg=&refHost=smalltester.000webhostapp.com&authors=JTIySlRWQ0pUZENKVEl5Ym1GdFpTVXlNam9sTWpBbE1qSmhaRzFwYmlVeU1pd2xNakFsTWpKbGJXRnBiQ1V5TWpvbE1qSWxNaklzSlRJeWRIbHdaU1V5TWpvbE1qQWxNakpwYm5SbGNtNWhiQ1V5TWlVM1JDVTFSQT09JTIy&tags=&lang=en&l_d=false&totWideImg=false&articlesProtocol=http&color=108ee9&hideArticles=false&d=false&maxChars=3000&commentsToLoad=5&toxicityLimit=80&gr=false&customText=%7B%7D&hideCommentBox=false"
        
        if let url = URL(string: urlString) {
            wkWebViewWithScript.load(URLRequest(url: url))
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
        
        let urlString = "https://cdn.vuukle.com/widgets/emotes.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&darkMode=false&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New&post&22&url=https://smalltester.000webhostapp.com/2017/12/new-post-22&emotesEnabled=true&firstImg=&secondImg=&thirdImg=&fourthImg=&fifthImg=&sixthImg=&totWideImg=false&articlesProtocol=http&hideArticles=false&disable=[]&iconsSize=70&first=HAPPY&second=INDIFFERENT&third=AMUSED&fourth=EXCITED&fifth=ANGRY&sixth=SAD&customText=%7B%7D"
        
        if let url = URL(string: urlString) {
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
    
    // MARK: WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                    self.heightWKWebViewWithScript.constant = height as! CGFloat
                })
            }
        })
    }
    
    // MARK: WKUIDelegate methods
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        present(alertController, animated: true)
        alertController.addTextField(configurationHandler: nil)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
            completionHandler(alertController.textFields?.first?.text)
        }))
    }
}

