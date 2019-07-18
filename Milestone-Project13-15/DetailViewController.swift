//
//  DetailViewController.swift
//  Milestone-Project13-15
//
//  Created by Denis Goldberg on 18.07.19.
//  Copyright © 2019 Denis Goldberg. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Country?
    var languages = [String]()
    var currencies = [String]()
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        guard let detailItem = detailItem else { return }
        print(detailItem)
        
        for language in detailItem.languages {
            languages.append(language.name)
        }
        
        for currency in detailItem.currencies {
            if let currencyName = currency.name {
                currencies.append(currencyName)
            }
        }

        
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 125%; } </style>
            </head>
            <body>
                <h2>\(detailItem.name)</h2>
                <br>
                <img src="\(detailItem.flag)" alt="Flag of \(detailItem.name) height="100px" width=100%>
                <ul>
                    <li>Capital: \(detailItem.capital)</li>
                    <li>Language(s): \(languages.joined(separator: ", "))</li>
                    <li>Size: \(detailItem.area?.description ?? "n.A.")</li>
                    <li>Population: \(detailItem.population)</li>
                    <li>Currencies: \(currencies.joined(separator: ", "))</li>
                </ul>
            </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)

    }


}

