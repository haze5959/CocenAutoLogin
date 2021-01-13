//
//  SideMenuViewModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2021/01/11.
//

import UIKit
import Combine

final class SideMenuViewModel: ViewModelType {
    struct Input {
        let sideMenuState = PassthroughSubject<SideMenuState, Never>()
        let delOtpKey = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let sideMenuAction: AnyPublisher<SideMenuState, Never>
        let layout: AnyPublisher<UICollectionViewLayout, Never>
        let delOtpKeyComplete: AnyPublisher<Void, Never>
    }
    
    let input = Input()
    private(set) var sections = [Section]()
    
    func transform() -> Output {
        let delOtpKeyCompleteAction = input.delOtpKey
            .flatMap { (_) -> AnyPublisher<Void, Never> in
                OQUserDefaults().remove(forKey: .idKey)
                OQUserDefaults().remove(forKey: .otpKey)
                return Just(()).erased
            }.erased
        
        let sideMenuAction = input.sideMenuState.handleEvents(receiveOutput: { [weak self] process in
            self?.sections = process.sections
        }).erased
        
        let updateLayout = sideMenuAction.flatMap { (key) -> AnyPublisher<UICollectionViewLayout, Never> in
            let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
                return self?.sections[sectionIndex].layoutSection()
            }
            
            return Just(layout).erased
        }.erased
        
        return Output(sideMenuAction: sideMenuAction, layout: updateLayout, delOtpKeyComplete: delOtpKeyCompleteAction)
    }
}
