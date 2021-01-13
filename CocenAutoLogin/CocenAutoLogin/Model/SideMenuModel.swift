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
    case main(userId: String, otpKey: String, removeInfoEvent: () -> Void)
    
    /// 해당 절차에서 보여줘야할 섹션들
    var sections: [Section] {
        switch self {
        case .noneOtpKey:
            return [DefaultSection(title: "아이디와 OTP 키를 입력해주세요.")]
        case .main(let userId, let otpKey, let removeInfoEvent):
            return [DefaultSection(title: "ID: \(userId)"),
                    DefaultSection(title: "OTP Key: \(otpKey)"),
                    DefaultBtnSection(title: "입력 정보 초기화", action: removeInfoEvent)]
        }
    }
}

