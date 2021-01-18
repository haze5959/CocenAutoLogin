//
//  GuideCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import Combine

class GuideCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    
    var submitSub: PassthroughSubject<(id: String, optKey: String), Never>?
    
    @IBAction func pressSubmitBtn(_ sender: Any) {
        guard let idStr = idTextField.text,
              !idStr.isEmpty else {
            titleLabel.text = "아이디가 입력되지 않았습니다."
            return
        }
        
        guard let otpKey = otpTextField.text else {
            titleLabel.text = "OTP Key가 입력되지 않았습니다."
            return
        }
        
        guard otpKey.count == 16 else {
            titleLabel.text = "OTP Key는 16자리 입니다."
            return
        }
        
        submitSub?.send((idStr, otpKey))
    }
    
    @IBAction func pressIdFieldReturnKey(_ sender: Any) {
        otpTextField.becomeFirstResponder()
    }
    
    @IBAction func pressReturnKey(_ sender: Any) {
        pressSubmitBtn(sender)
    }
}

struct GuideSection: Section {
    let numberOfItems = 1
    var submitSub: PassthroughSubject<(id: String, optKey: String), Never>

    init(submitSub: PassthroughSubject<(id: String, optKey: String), Never>) {
        self.submitSub = submitSub
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
        cell.submitSub = submitSub
        return cell
    }
}
