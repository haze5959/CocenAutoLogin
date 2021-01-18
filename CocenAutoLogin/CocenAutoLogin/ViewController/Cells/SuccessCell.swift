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
    
    override func layoutSubviews() {
        titleLabel.text = "완료되었습니다. (\(OQUserDefaults().string(forKey: .idKey)))"
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
