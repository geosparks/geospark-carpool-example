//
//  LiveTrackingViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 02/10/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import WebKit

class LiveTrackingViewController: UIViewController,WKNavigationDelegate{
    
    var webView: WKWebView!
    var tripId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Live Tracking"
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        let tripUrl = Utils.tripURL(tripId)
        let url = URL(string:tripUrl)
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    static public func viewController() -> LiveTrackingViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "LiveTrackingViewController") as! LiveTrackingViewController
        return logsDisplayVC
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showHud()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissHud()
    }
    
}
