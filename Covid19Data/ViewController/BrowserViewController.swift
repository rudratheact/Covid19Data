//
//  BrowserViewController.swift
//  Covid19Stats
//
//  Created by Rudra Evolut on 23/02/22.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.isHidden = true
        activity.stopAnimating()
        
        if urlString.contains("https://"), let url = URL(string: urlString){
            print(url)
            webView.isHidden = false
            webView.load(URLRequest(url: url))
        }
    }

}

extension BrowserViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activity.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activity.stopAnimating()
    }
}
