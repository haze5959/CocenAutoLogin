//
//  SideMenuModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2021/01/11.
//

import Foundation
import Combine

/// 와이파이 접속 절차
enum SideMenuState {
    case noneOtpKey
    case main(otpKey: String)
    
    /// 해당 절차에서 보여줘야할 섹션들
    var sections: [Section] {
        switch self {
        case .noneOtpKey:
            return [DefaultSection(title: "OTP Key가 없습니다.")]
        case .main(let otpKey):
            return [DefaultSection(title: "OTP Key: \(otpKey)"),
                    DefaultSection(title: "OTP Key 삭제")]
        }
    }
}

