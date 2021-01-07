//
//  GuideCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit

class GuideCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}

struct GuideSection: Section {
    let numberOfItems = 1
    private let title: String

    init() {
        self.title = "test"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GuideCell.self), for: indexPath) as! GuideCell
        cell.title = self.title
        return cell
    }
}
