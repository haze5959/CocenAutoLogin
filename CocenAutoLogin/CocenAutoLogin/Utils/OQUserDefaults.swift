//
//  OQUserDefaults.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/29.
//

import Foundation

final class OQUserDefaults {
    // MARK: UserInfo Keys
    enum UserDefaultKey: String {
        case otpKey = "OTPKey.key"
    }
    
    private let userDefaults = UserDefaults()
    
    func setValue(_ value: Any?, forKey: UserDefaultKey) {
        self.userDefaults.setValue(value, forKey: forKey.rawValue)
    }
    
    func remove(forKey: UserDefaultKey) {
        self.userDefaults.removeObject(forKey: forKey.rawValue)
    }
    
    func string(forKey: UserDefaultKey) -> String {
        return self.userDefaults.string(forKey: forKey.rawValue) ?? ""
    }
    
    func bool(forKey: UserDefaultKey) -> Bool {
        return self.userDefaults.bool(forKey: forKey.rawValue)
    }
    
    func object(forKey: UserDefaultKey) -> Any? {
        return self.userDefaults.object(forKey: forKey.rawValue)
    }
}
