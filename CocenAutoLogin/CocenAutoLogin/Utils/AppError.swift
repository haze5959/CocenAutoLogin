//
//  AppError.swift
//  AppstoreOQ
//
//  Created by OQ on 2020/08/23.
//  Copyright © 2020 OQ. All rights reserved.
//

import Foundation

enum AppError: Error {
    case impossible
    case parse(msg: String)
    case Network(status: Int)
    
    // OTP
    case optKey
    case optValue
}
