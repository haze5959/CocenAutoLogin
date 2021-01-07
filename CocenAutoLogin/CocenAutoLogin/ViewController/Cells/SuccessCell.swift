//
//  SuccessCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import Combine

class SuccessCell: UICollectionViewCell {
    var retryPub: PassthroughSubject<Void, Never>?
    
    @IBAction func pressRetryBtn(_ sender: Any) {
        retryPub?.send()
    }
}

struct SuccessSection: Section {
    let numberOfItems = 1
    let retryPub: PassthroughSubject<Void, Never>
    
    init(retryPub: PassthroughSubject<Void, Never>) {
        self.retryPub = retryPub
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
        cell.retryPub = retryPub
        return cell
    }
}
