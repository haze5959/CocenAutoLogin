//
//  WebViewCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import WebKit
import SystemConfiguration.CaptiveNetwork
import Combine

class WebViewCell: UICollectionViewCell {
    var webView: WKWebView?
    var process: WebProcess?
    var reloadAction: (() -> Void)?
    
    func cellWillAppear() {
        guard let webView = webView,
              let process = process else {
            return
        }
        
        webView.isUserInteractionEnabled = false
        webView.frame = self.bounds
        contentView.addSubview(webView)
        
        switch process {
        case .loadPage(let urlStr):
            load(urlStr: urlStr, with: Constants.wifiSSID)
        case .script(let script):
            webView.evaluateJavaScript(script) { [self] (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    reloadAction?()
                }
            }
        }
    }
    
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    func load(urlStr: String, with wifi: String) {
        guard let url = URL(string: urlStr) else {
            print("url host is nil!")
            reloadAction?()
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            if let ssid = getWiFiSsid(),
               ssid == wifi {
                webView?.load(request)
            } else {
                print("wifi setting...")
                reloadAction?()
            }
        }
    }
}

struct WebViewSection: Section {
    let numberOfItems = 1
    let process: WebProcess
    let webView: WKWebView
    private let action: () -> Void
    
    init(process: WebProcess, webView: WKWebView, action: @escaping () -> Void) {
        self.process = process
        self.webView = webView
        self.action = action
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
        cell.reloadAction = action
        cell.cellWillAppear()
        return cell
    }
}
