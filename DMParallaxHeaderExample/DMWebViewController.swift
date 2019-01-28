//
//  DMWebViewController.swift
//  DMParallaxHeaderExample
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import WebKit
import DMParallaxHeader

class DMWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
//    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: "https://dribbble.com/search?q=spaceship")!)
        webView.loadRequest(request)
//        webView.load(request)
    }
    
    @IBAction func back(_ sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        webView.reload()
    }
}

