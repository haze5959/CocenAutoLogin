//
//  OtpEtcCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit

class OtpEtcCell: UICollectionViewCell {
    @IBOutlet private var msgLabel: UILabel!

    var message: String? {
        didSet {
            msgLabel.text = message
        }
    }
}

struct OtpEtcSection: Section {
    let numberOfItems = 1
    private let title: String

    init(msg: String) {
        self.title = msg
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OtpEtcCell.self), for: indexPath) as! OtpEtcCell
        cell.message = self.title
        return cell
    }
}
