//
//  ProgressCell.swift
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit
import StepIndicator

class ProgressCell: UICollectionViewCell {
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var descLabel: UILabel!
    
    var process: AppProcess = .connectWifi {
        didSet {
            switch process {
            case .connectWifi:
                stepIndicatorView.currentStep = 0
            case .loadAuthPage:
                stepIndicatorView.currentStep = 1
            case .auth:
                stepIndicatorView.currentStep = 2
            default:
                break
            }
            
            self.descLabel.text = process.desc
        }
    }
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.autoreverse ,.repeat],
                       animations: { [self] in
                        descLabel.alpha = 0.2
                        
                       })
    }
    
    override func prepareForReuse() {
        stepIndicatorView.currentStep = 0
    }
}

struct ProgressSection: Section {
    let numberOfItems = 1
    private let process: AppProcess
    
    init(process: AppProcess) {
        self.process = process
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCell.self), for: indexPath) as! ProgressCell
        cell.process = self.process
        return cell
    }
}
