//
//  LoginViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private lazy var usernameTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入账号")
            .returnKeyType(.next)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728")).build
    }()
    
    private lazy var passwordTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入密码")
            .isSecureTextEntry(true)
            .returnKeyType(.go)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728")).build
    }()
    
    private lazy var loginButton: UIButton = {
        return UIButton(type: .custom).chain
            .backgroundColor(UIColor.cyan)
            .cornerRadius(5)
            .masksToBounds(true)
            .backgroundImage(#imageLiteral(resourceName: "login_button_enabled"), for: .normal)
            .backgroundImage(#imageLiteral(resourceName: "login_button_disabled"), for: .disabled)
            .title("登录", for: .normal)
            .isEnabled(false).build
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigation()
        buildSubviews()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func buildNavigation() {
        navigation.item.title = "登录"
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "注册").chain.tintColor(UIColor.white).build
        navigation.item.rightBarButtonItem?.rx.tap.bind(to: rx.gotoRegister).disposed(by: disposeBag)
    }
    
    private func buildSubviews() {
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.width - 60, height: 36))
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.centerX.size.equalTo(usernameTextField)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.centerX.size.equalTo(passwordTextField)
        }
    }

    private func bindViewModel() {
        let viewModel = LoginViewModel()
        let input = LoginViewModel.Input(username: usernameTextField.rx.text.orEmpty,
                                         password: passwordTextField.rx.text.orEmpty,
                                         login: loginButton.rx.tap)
        
        let output = viewModel.transform(input)
        output.validation.drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
        output.login.bind(to: rx.dismiss).disposed(by: disposeBag)
    }
}
