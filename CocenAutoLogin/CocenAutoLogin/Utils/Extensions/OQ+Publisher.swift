//
//  OQ+Publisher.swift
//  AppstoreOQ
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import Combine

extension Publisher {
    var erased: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }
}
