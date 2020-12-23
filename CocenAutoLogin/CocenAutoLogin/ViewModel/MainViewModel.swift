//
//  MainViewModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import Foundation
import Combine
import NetworkExtension
import SwiftOTP

typealias OTPResult = Result<String, AppError>
final class MainViewModel: ViewModelType {
    struct Input {
        let optKey = PassthroughSubject<String, Never>()
        let appProcess = CurrentValueSubject<AppProcess, Never>(.initPage)
    }
    
    struct Output {
        let optValue: AnyPublisher<OTPResult, Never>
        let appProcessValue: AnyPublisher<AppProcess, Never>
    }
    
    let input = Input()
    
    func transform() -> Output {
        let optValAction = input.optKey.flatMap { (key) -> AnyPublisher<OTPResult, Never> in
            guard let data = base32DecodeToData(key),
                  let totp = TOTP(secret: data),
                  let otpString = totp.generate(time: Date()) else {
                return Just(OTPResult.failure(.optKey)).erased
            }
            
            return Just(OTPResult.success(otpString)).erased
        }.erased
        
        let appProcessValAction = input.appProcess.erased
        
        return Output(optValue: optValAction, appProcessValue: appProcessValAction)
    }
}
