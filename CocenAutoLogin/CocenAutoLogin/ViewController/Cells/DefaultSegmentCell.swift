//
//  DefaultSegmentCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import Combine

class DefaultSegmentCell: UICollectionViewCell {
    @IBOutlet weak var wifiSegment: UISegmentedControl!
    var action: (() -> Void)?
    
    @IBAction func pressSegemt(_ sender: Any) {
        switch wifiSegment.selectedSegmentIndex {
        case 0:
            let wifi = "cocen_2g"
            OQUserDefaults().setValue(wifi, forKey: .wifiKey)
            Constants.wifiSSID = wifi
        default:
            let wifi = "cocen_5g"
            OQUserDefaults().setValue(wifi, forKey: .wifiKey)
            Constants.wifiSSID = wifi
        }
        
        action?()
    }
}

struct DefaultSegmentSection: Section {
    let numberOfItems = 1
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DefaultSegmentCell.self), for: indexPath) as! DefaultSegmentCell
        cell.action = action
        return cell
    }
}
