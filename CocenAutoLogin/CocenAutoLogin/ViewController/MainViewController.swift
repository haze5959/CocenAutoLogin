//
//  MainViewController.swift
//  CocenAutoLogin
//
//  Created by OGyu kwon on 2020/12/23.
//

import UIKit
import Combine

final class MainViewController: UIViewController, CommonView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var barSettingBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        
        return button
    }()
    
    let sideMenuView: SideMenuView = {
        let view = SideMenuView.instanceFromNib() as! SideMenuView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func bindings() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: String(describing: OtpEtcCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: OtpEtcCell.self))
        self.collectionView.register(UINib(nibName: String(describing: GuideCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GuideCell.self))
        self.collectionView.register(UINib(nibName: String(describing: OtpFailCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: OtpFailCell.self))
        self.collectionView.register(UINib(nibName: String(describing: ProgressCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProgressCell.self))
        self.collectionView.register(UINib(nibName: String(describing: SuccessCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SuccessCell.self))
        self.collectionView.register(UINib(nibName: String(describing: WebViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: WebViewCell.self))
        
        let output = viewModel.transform()
        
        output.layout
            .assign(to: \.collectionView.collectionViewLayout, on: self)
            .store(in: &self.cancellables)
        
        output.appProcessAction
            .sink { [weak self] process in
                self?.collectionView.reloadData()
                
                switch process {
                case .initPage:   // OTP 준비
                    self?.initPageView()
                case .connectWifi:    // Cocen 2g 연결 중...
                    self?.connectWifiView()
                case .loadAuthPage:   // 인증 페이지 로딩 중...
                    self?.loadAuthPageView()
                case .auth:   // 인증 중...
                    self?.authView()
                case .success:    // 성공
                    self?.successView()
                case .failOTP:  // OTP 만들기 실패
                    self?.failOTPView()
                case .failEtc:
                    self?.failOTPView()
                }
            }.store(in: &self.cancellables)
        
        output.optValue.sink { [weak self] result in
            switch result {
            case .success(let otp):
                print(otp)
                self?.viewModel.input.appProcess.send(.connectWifi)
            case .failure(let error):
                print(error.localizedDescription)
                self?.viewModel.input.appProcess.send(.failOTP(msg: error.localizedDescription))
            }
        }.store(in: &self.cancellables)
        
        barSettingBtn
            .publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.sideMenuView.toggle()
            })
            .store(in: &self.cancellables)
    }
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barSettingBtn)
        
        view.addSubview(sideMenuView)
        
        // OTP 키가 저장 되어있다면 바로 연결 진행
        if let key = OQUserDefaults().object(forKey: .otpKey) as? String {
            viewModel.input.optKey.send(key)
        } else {
            viewModel.input.appProcess.send(.initPage(submitSub: viewModel.input.otpKeySubmit))
        }
    }
}

// MARK: View Setting
extension MainViewController {
    func initPageView() {
        
    }
    
    func failOTPView() {
        
    }
    
    func connectWifiView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            viewModel.input.appProcess.send(.loadAuthPage)
        }
    }
    
    func loadAuthPageView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            viewModel.input.appProcess.send(.auth)
        }
    }
    
    func authView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            viewModel.input.appProcess.send(.success(retrySub: viewModel.input.retry))
        }
    }
    
    func successView() {
        
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.viewModel.input.selectItem.send(indexPath)
//    }
}

//// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
    }
}
