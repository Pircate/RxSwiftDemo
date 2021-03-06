//
//  RegisterViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    private lazy var usernameTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入账号")
            .returnKeyType(.next)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728"))
            .clearButtonMode(.whileEditing).build
    }()
    
    private lazy var passwordTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入密码")
            .isSecureTextEntry(true)
            .returnKeyType(.go)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728")).build
    }()
    
    private lazy var registerButton: UIButton = {
        return UIButton(type: .custom).chain
            .backgroundColor(UIColor.cyan)
            .cornerRadius(5)
            .masksToBounds(true)
            .backgroundImage(#imageLiteral(resourceName: "login_button_enabled"), for: .normal)
            .backgroundImage(#imageLiteral(resourceName: "login_button_disabled"), for: .disabled)
            .title("注册", for: .normal)
            .isEnabled(false).build
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildSubviews()
        bindViewModel()
    }
    
    private func buildSubviews() {
        navigation.item.title = "注册"
        
        usernameTextField.maxLength = 11
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.width - 60, height: 44))
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.centerX.size.equalTo(usernameTextField)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.centerX.size.equalTo(passwordTextField)
        }
    }
    
    private func bindViewModel() {
        let viewModel = RegisterViewModel()
        let input = RegisterViewModel.Input(username: usernameTextField.rx.text.orEmpty.shareOnce(),
                                            password: passwordTextField.rx.text.orEmpty.shareOnce(),
                                            registerTap: registerButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.isEnabled
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.register
            .map(to: ())
            .drive(rx.popToRoot(animated: true))
            .disposed(by: disposeBag)
        
        output.register
            .drive(view.rx.endEditing)
            .disposed(by: disposeBag)
        
        output.state
            .drive(Toast.rx.state)
            .disposed(by: disposeBag)
    }
}
