//
//  AppProcessModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import Foundation

enum AppProcess {
    case initPage   // OTP 준비
    case noOTP  // OTP 키 정보 없음
    case failOTP  // OTP 만들기 실패
    case connectWifi    // Cocen 2g 연결 중...
    case loadAuthPage   // 인증 페이지 로딩 중...
    case auth   // 인증 중...
    case success    // 성공
}
