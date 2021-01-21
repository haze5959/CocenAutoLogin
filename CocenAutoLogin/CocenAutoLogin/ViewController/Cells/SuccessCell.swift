//
//  SuccessCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import Combine

class SuccessCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var retrySub: PassthroughSubject<Void, Never>?
    
    @IBAction func pressRetryBtn(_ sender: Any) {
        retrySub?.send()
    }
    
    @IBAction func pressOpenSetting(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    override func layoutSubviews() {
        var text = "완료되었습니다. (\(OQUserDefaults().string(forKey: .idKey)))"
        if Constants.isConnectedInApp {
            text += "\niOS 정책상 해당 앱에서 연결한 와이파이는 앱을 나가면 몇초후에 연결이 끊기게 됩니다."
                + "\n설정으로 이동하셔서 다시 연결해주세요."
        }
        titleLabel.text = text
    }
}

struct SuccessSection: Section {
    let numberOfItems = 1
    let retrySub: PassthroughSubject<Void, Never>
    
    init(retrySub: PassthroughSubject<Void, Never>) {
        self.retrySub = retrySub
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SuccessCell.self), for: indexPath) as! SuccessCell
        cell.retrySub = retrySub
        return cell
    }
}
