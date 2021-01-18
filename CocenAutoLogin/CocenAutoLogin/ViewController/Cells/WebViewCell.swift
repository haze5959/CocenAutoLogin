//
//  WebViewCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import WebKit

class WebViewCell: UICollectionViewCell {
    var webView: WKWebView?
    var process: WebProcess?
    
    override func prepareForReuse() {
        guard let webView = webView,
              let process = process else {
            return
        }
        
        webView.isUserInteractionEnabled = false
        webView.frame = contentView.frame
        contentView.addSubview(webView)
        
        switch process {
        case .loadPage(let urlStr):
            guard let url = URL(string: urlStr) else {
                print("url host is nil!")
                return
            }
            
            let request = URLRequest(url: url)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                webView.load(request)
            }
        case .script(let script):
            webView.evaluateJavaScript(script) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct WebViewSection: Section {
    let numberOfItems = 1
    let process: WebProcess
    let webView: WKWebView
    
    init(process: WebProcess, webView: WKWebView) {
        self.process = process
        self.webView = webView
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WebViewCell.self), for: indexPath) as! WebViewCell
        cell.webView = webView
        cell.process = process
        return cell
    }
}
