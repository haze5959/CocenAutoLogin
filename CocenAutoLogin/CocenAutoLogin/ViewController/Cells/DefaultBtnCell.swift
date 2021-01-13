//
//  DefaultBtnCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import Combine

class DefaultBtnCell: UICollectionViewCell {
    @IBOutlet weak var titleButton: UIButton!
    
    var title: String? {
        didSet {
            titleButton.setTitle(title, for: .normal)
        }
    }
    
    var action: (() -> Void)?
    
    @IBAction func pressTitleBtn(_ sender: Any) {
        action?()
    }
}

struct DefaultBtnSection: Section {
    let numberOfItems = 1
    private let title: String
    private let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DefaultBtnCell.self), for: indexPath) as! DefaultBtnCell
        cell.title = title
        cell.action = action
        return cell
    }
}
