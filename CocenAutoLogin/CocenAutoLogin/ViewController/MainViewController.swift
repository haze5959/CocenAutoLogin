//
//  MainViewController.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import UIKit
import Combine

final class MainViewController: UIViewController, CommonView {
    private lazy var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func bindings() {
        let output = viewModel.transform()
        
        output.appProcessValue.sink { process in
            
        }.store(in: &self.cancellables)
        
        output.optValue.sink { otp in
            print(otp)
        }.store(in: &self.cancellables)
    }
    
    func setupView() {
        <#code#>
    }
}

