//
//  WebProcessModel.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import Foundation

enum WebProcess {
    case loadPage(url: String)
    case script(script: String)
}
