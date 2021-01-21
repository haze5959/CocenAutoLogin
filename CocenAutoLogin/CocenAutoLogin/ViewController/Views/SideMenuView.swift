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
    
    private let sideViewW: CGFloat = 300
    private let interaciveW: CGFloat = 40
    var delOtpKeySub: PassthroughSubject<Void, Never>?
    
    private var gestureBeginPos = CGPoint.zero
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
        
        gesture(.tap())
            .sink { [unowned self] gesture in
                let position = gesture.get().location(in: self)
                if position.x > sideViewW {
                    self.close()
                }
            }.store(in: &self.cancellables)
        
        gesture(.pan())
            .subscribe(on: DispatchQueue.main)
            .sink { [unowned self] gesture in
                guard let panGesture = gesture.get() as? UIPanGestureRecognizer,
                      let view = panGesture.view else {
                    return
                }
                
                let transition = panGesture.translation(in: view)
                
                switch panGesture.state {
                case .began:
                    gestureBeginPos = transition
                case .changed:
                    var changedX = leadingCont.constant + transition.x
                    
                    if changedX > 0 {
                        changedX = 0
                    }
                    
                    
                    self.backgroundColor = UIColor.black.withAlphaComponent(((sideViewW + changedX) / sideViewW) * 0.5)
                    
                    leadingCont.constant = changedX
                    layoutIfNeeded()
                    
                    panGesture.setTranslation(CGPoint.zero, in: view)
                case .ended:
                    if gestureBeginPos.x < 0 {
                        if leadingCont.constant > -interaciveW {
                            open()
                        } else {
                            close()
                        }
                    } else {
                        if leadingCont.constant < -sideViewW + interaciveW {
                            close()
                        } else {
                            open()
                        }
                    }
                default: break
                }
            }.store(in: &self.cancellables)
    }
    
    func setupView() {
        leadingCont.constant = -sideViewW
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
        self.leadingCont.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    func close() {
        leadingCont.constant = -self.sideViewW
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.backgroundColor = UIColor.black.withAlphaComponent(0)
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

// MARK: - UICollectionViewDataSource
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

// MARK: - hitTest
extension SideMenuView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if leadingCont.constant == 0 {
            return hitView
        } else {
            if point.x < interaciveW {
                return self
            } else {
                return hitView == self ? nil : hitView
            }
        }
    }
}
