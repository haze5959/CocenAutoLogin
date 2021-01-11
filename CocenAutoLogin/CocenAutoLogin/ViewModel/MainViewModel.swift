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
        let otpKeySubmit = PassthroughSubject<String, Never>()
        let otpKeyDelete = PassthroughSubject<Void, Never>()
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
            .map({ OQUserDefaults().string(forKey: .otpKey) })
        let optValAction = Publishers.Merge3(retryAction, input.optKey, input.otpKeySubmit)
            .flatMap { (key) -> AnyPublisher<OTPResult, Never> in
                guard let data = base32DecodeToData(key),
                      let totp = TOTP(secret: data),
                      let otpString = totp.generate(time: Date()) else {
                    return Just(OTPResult.failure(.optKey)).erased
                }
                
                return Just(OTPResult.success(otpString)).erased
            }.erased
        
        let appProcessValAction = input.appProcess.handleEvents(receiveOutput: { [weak self] process in
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
