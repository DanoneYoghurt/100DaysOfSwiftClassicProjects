//
//  DetailViewController.swift
//  project16
//
//  Created by Антон Баскаков on 19.09.2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var placeName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let placeName else { return }
        
        let url = URL(string: "https://en.wikipedia.org/wiki/\(placeName)")!
        webView.load(URLRequest(url: url))
        
        title = webView.url?.absoluteString
    }
}
