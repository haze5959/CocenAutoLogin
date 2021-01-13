//
//  SideMenuView.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2021/01/11.
//

import UIKit
import Combine

final class SideMenuView: UIView, CommonView {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var leadingCont: NSLayoutConstraint!
    @IBOutlet private weak var panGestureSpace: UIView!
    
    var delOtpKeySub: PassthroughSubject<Void, Never>?
    private lazy var viewModel = SideMenuViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUp()
    }
    
    func bindings() {
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: String(describing: DefaultCell.self), bundle: nil),
                                     forCellWithReuseIdentifier: String(describing: DefaultCell.self))
        self.collectionView.register(UINib(nibName: String(describing: DefaultBtnCell.self), bundle: nil),
                                     forCellWithReuseIdentifier: String(describing: DefaultBtnCell.self))
        
        let output = viewModel.transform()
        output.layout
            .assign(to: \.collectionView.collectionViewLayout, on: self)
            .store(in: &self.cancellables)
        
        output.delOtpKeyComplete
            .sink { [weak self] _ in
                self?.delOtpKeySub?.send()
                self?.close()
            }.store(in: &self.cancellables)
        
        output.sideMenuAction
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &self.cancellables)
        
        panGestureSpace.gesture(.tap())
            .sink { [weak self] _ in
                self?.close()
            }.store(in: &self.cancellables)
        
        panGestureSpace.gesture(.pan())
            .subscribe(on: DispatchQueue.main)
            .sink { [unowned self] gesture in
                guard let panGesture = gesture.get() as? UIPanGestureRecognizer else {
                    return
                }
                
                switch panGesture.state {
                case .changed:
                    guard let view = panGesture.view else {
                        return
                    }
                    
                    let transition = panGesture.translation(in: view)
                    var changedX = leadingCont.constant + transition.x
                    
                    if changedX > 0 {
                        changedX = 0
                    }
                    
                    leadingCont.constant = changedX
                    layoutIfNeeded()
                    
                    panGesture.setTranslation(CGPoint.zero, in: view)
                case .ended:
                    if leadingCont.constant < -80 {
                        close()
                    } else {
                        open()
                    }
                default: break
                }
            }.store(in: &self.cancellables)
    }
    
    func setupView() {
        self.isHidden = true
        leadingCont.constant = -frame.width
        
        reloadView()
    }
    
    func reloadView() {
        if let userId = OQUserDefaults().object(forKey: .idKey) as? String,
           let otpKey = OQUserDefaults().object(forKey: .otpKey) as? String {
            viewModel.input.sideMenuState.send(.main(userId: userId,
                                                     otpKey: otpKey,
                                                     removeInfoEvent: { [weak self] in
                                                        self?.viewModel.input.delOtpKey.send()
                                                     }))
        } else {
            viewModel.input.sideMenuState.send(.noneOtpKey)
        }
    }
}

extension SideMenuView {
    func open() {
        reloadView()
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
        if isOpen {
            close()
        } else {
            open()
        }
    }
    
    var isOpen: Bool {
        return leadingCont.constant >= 0
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
