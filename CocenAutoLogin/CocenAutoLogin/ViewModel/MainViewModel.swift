//
//  MainViewModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import UIKit
import Combine
import NetworkExtension
import SwiftOTP

typealias OTPResult = Result<String, AppError>
final class MainViewModel: ViewModelType {
    struct Input {
        let optKey = PassthroughSubject<String, Never>()
        let appProcess = PassthroughSubject<AppProcess, Never>()
        let retry = PassthroughSubject<Void, Never>()
        let userInfoSubmit = PassthroughSubject<(id: String, optKey: String), Never>()
        let userInfoDelete = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let layout: AnyPublisher<UICollectionViewLayout, Never>
        let optValue: AnyPublisher<OTPResult, Never>
        let appProcessAction: AnyPublisher<AppProcess, Never>
    }
    
    let input = Input()
    private(set) var sections = [Section]()
    
    func transform() -> Output {
        let retryAction = input.retry
            .compactMap { [unowned self] _ -> String? in
                if OQUserDefaults().string(forKey: .idKey).isEmpty || OQUserDefaults().string(forKey: .otpKey).isEmpty {
                    input.appProcess.send(.initPage(submitSub: input.userInfoSubmit))
                    return nil
                } else {
                    return OQUserDefaults().string(forKey: .otpKey)
                }
            }
        let submitAction = input.userInfoSubmit
            .handleEvents(receiveOutput: { info in
                OQUserDefaults().setValue(info.id, forKey: .idKey)
            })
            .map({ $0.optKey })
        let optValAction = Publishers.Merge3(retryAction, input.optKey, submitAction)
            .flatMap { (key) -> AnyPublisher<OTPResult, Never> in
                guard let data = base32DecodeToData(key),
                      let totp = TOTP(secret: data),
                      let otpString = totp.generate(time: Date()) else {
                    return Just(OTPResult.failure(.optKey)).erased
                }
                
                OQUserDefaults().setValue(key, forKey: .otpKey)
                return Just(OTPResult.success(otpString)).erased
            }.erased
        
        let deleteAction = input.userInfoDelete.map({ [unowned self] _ in
            AppProcess.initPage(submitSub: input.userInfoSubmit)
        })
        
        let appProcessValAction = Publishers.Merge(input.appProcess, deleteAction)
            .handleEvents(receiveOutput: { [weak self] process in
                self?.sections = process.sections
            }).erased
        
        let updateLayout = appProcessValAction.flatMap { (key) -> AnyPublisher<UICollectionViewLayout, Never> in
            let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
                return self?.sections[sectionIndex].layoutSection()
            }
            
            return Just(layout).erased
        }.erased
        
        return Output(layout: updateLayout, optValue: optValAction, appProcessAction: appProcessValAction)
    }
}
