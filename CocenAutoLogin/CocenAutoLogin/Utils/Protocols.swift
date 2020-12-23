//
//  Protocols.swift
//  StampangDeilvery
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import Foundation

/// 뷰모델 공통 타입
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    /// 뷰에 들어갈 액션
    var input: Input { get }
    
    /// Output 변환
    func transform(input: Input) -> Output
}

/// 뷰 공통 인터페이스
protocol CommonView {
    /// 뷰모델 바인딩
    func bindings()
    
    /// 뷰 초기 설정
    func setupView()
}

extension CommonView {
    /// CommonView 공통 작업
    func setUp() {
        bindings()
        setupView()
    }
}
