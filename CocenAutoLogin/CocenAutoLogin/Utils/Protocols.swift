//
//  Protocols.swift
//  StampangDeilvery
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import UIKit

/// 뷰모델 공통 타입
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    /// 뷰에 들어갈 액션
    var input: Input { get }
    
    /// Output 변환
    func transform() -> Output
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

/// 콜랙션뷰 섹션 공통 인터페이스
protocol Section {
    var numberOfItems: Int { get }
    func layoutSection() -> NSCollectionLayoutSection
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
