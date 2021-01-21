//
//  DefaultCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import Combine

class DefaultCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}

struct DefaultSection: Section {
    let numberOfItems = 1
    private let title: String
    
    init(title: String) {
        self.title = title
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DefaultCell.self), for: indexPath) as! DefaultCell
        cell.title = self.title
        return cell
    }
}
