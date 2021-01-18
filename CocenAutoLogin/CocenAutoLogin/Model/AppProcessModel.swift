//
//  AppProcessModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import Foundation
import Combine
import WebKit

/// 와이파이 접속 절차
enum AppProcess {
    case initPage(submitSub: PassthroughSubject<(id: String, optKey: String), Never>)   // OTP 준비
    case failOTP(msg: String, retryAction: () -> Void)  // OTP 만들기 실패
    case failEtc(msg: String, retryAction: () -> Void)  // 와이파이 연결이나 인증 페이지에서 실패했을 경우
    case connectWifi    // Cocen 2g 연결 중...
    case loadAuthPage(webView: WKWebView)   // 인증 페이지 로딩 중...
    case auth(webView: WKWebView)   // 인증 중...
    case success(retrySub: PassthroughSubject<Void, Never>)    // 성공nting synthesized conformance of 'AppPro
    
    /// 해당 절차에서 보여줘야할 섹션들
    var sections: [Section] {
        switch self {
        case .initPage(let submitSub):
            return [GuideSection(submitSub: submitSub)]
        case .failOTP(let msg, let retryAction):
            return [OtpFailSection(msg: msg, action: retryAction)]
        case .failEtc(let msg, let retryAction):
            return [OtpEtcSection(msg: msg, action: retryAction)]
        case .connectWifi:
            return [ProgressSection(process: self)]
        case .loadAuthPage(let webView):
            return [ProgressSection(process: self), WebViewSection(process: .loadPage(url: "http://naver.com"), webView: webView)]
        case .auth(let webView):
            return [ProgressSection(process: self), WebViewSection(process: .script(script: "print('oqoqoq');"), webView: webView)]
        case .success(let retrySub):
            return [SuccessSection(retrySub: retrySub)]
        }
    }
    
    var desc: String {
        switch self {
        case .connectWifi: return "와이파이 연결 중... (cocen_2g)"
        case .loadAuthPage: return "인증 페이지 로딩 중..."
        case .auth: return "인증 중..."
        default: return ""
        }
    }
}
