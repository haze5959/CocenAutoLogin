//
//  SideMenuView.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2021/01/11.
//

import UIKit
import Combine

final class SideMenuView: UIView, CommonView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leadingCont: NSLayoutConstraint!
    
    var delOtpKeySub: PassthroughSubject<Void, Never>?
    private lazy var viewModel = SideMenuViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUp()
    }
    
    func bindings() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: String(describing: DefaultCell.self), bundle: nil),
                                     forCellWithReuseIdentifier: String(describing: DefaultCell.self))
        
        let output = viewModel.transform()
        output.layout
            .assign(to: \.collectionView.collectionViewLayout, on: self)
            .store(in: &self.cancellables)
        
        output.delOtpKeyComplete
            .sink { [weak self] _ in
                self?.delOtpKeySub?.send()
            }.store(in: &self.cancellables)
        
        output.sideMenuAction
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &self.cancellables)
    }
    
    func setupView() {
        self.isHidden = true
        leadingCont.constant = -frame.width
        
        // OTP 키가 저장 되어있다면 바로 연결 진행
        if let key = OQUserDefaults().object(forKey: .otpKey) as? String {
            viewModel.input.sideMenuState.send(.main(otpKey: key))
        } else {
            viewModel.input.sideMenuState.send(.noneOtpKey)
        }
    }
}

extension SideMenuView {
    func open() {
        layer.removeAllAnimations()
        self.isHidden = false
        self.leadingCont.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    func close() {
        layer.removeAllAnimations()
        leadingCont.constant = -self.frame.width
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { [weak self] (isComplete) in
            if isComplete {
                self?.isHidden = true
            }
        })
    }
    
    func toggle() {
        if self.leadingCont.constant >= 0 {
            self.close()
        } else {
            self.open()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SideMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        self.viewModel.input.selectItem.send(indexPath)
    }
}

//// MARK: - UICollectionViewDataSource
extension SideMenuView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
    }
}
