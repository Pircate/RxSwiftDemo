//
//  LoginViewController.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import RxGesture

final class LoginViewController: BaseViewController {
    
    private lazy var usernameTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入手机号")
            .returnKeyType(.next)
            .clearButtonMode(.whileEditing)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728"))
            .keyboardType(.numberPad).build
    }()
    
    private lazy var passwordTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入验证码")
            .returnKeyType(.go)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728"))
            .keyboardType(.numberPad).build
    }()
    
    private lazy var captchaButton: UIButton = {
        return UIButton(type: .custom).chain
            .backgroundColor(UIColor(hex: "#4381E8"))
            .cornerRadius(2)
            .masksToBounds(true)
            .title("获取验证码", for: .normal)
            .systemFont(ofSize: 14).build
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
        navigation.item.rightBarButtonItem?.rx.tap.bind(to: rx.push(RegisterViewController.self)).disposed(by: disposeBag)
        navigation.item.leftBarButtonItem = UIBarButtonItem(title: "关闭").chain.tintColor(UIColor.white).build
        let leftTap = navigation.item.leftBarButtonItem!.rx.tap.shareOnce()
        leftTap.bind(to: rx.dismiss).disposed(by: disposeBag)
        leftTap.map(to: true).bind(to: view.rx.endEditing).disposed(by: disposeBag)
    }
    
    private func buildSubviews() {
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(captchaButton)
        view.addSubview(loginButton)
        
        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.width - 60, height: 44))
        }
        
        captchaButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(30)
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.height.equalTo(usernameTextField)
            make.right.equalTo(captchaButton.snp.left).offset(-15)
            make.centerY.equalTo(captchaButton)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.centerX.size.equalTo(usernameTextField)
        }
    }

    private func bindViewModel() {
        let viewModel = LoginViewModel()
        
        let username = usernameTextField.rx.text.orEmpty.shareOnce()
        let password = passwordTextField.rx.text.orEmpty.shareOnce()
        
        // 限制输入框输入位数
        username.asDriver(onErrorJustReturn: "").drive(usernameTextField.rx.prefix(11)).disposed(by: disposeBag)
        password.asDriver(onErrorJustReturn: "").drive(passwordTextField.rx.prefix(6)).disposed(by: disposeBag)
        
        let input = LoginViewModel.Input(username: username,
                                         password: password,
                                         captchaTap: captchaButton.rx.tap,
                                         loginTap: loginButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.isEnabled.drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
        output.captcha.map({ $0.title }).drive(captchaButton.rx.title(for: .normal)).disposed(by: disposeBag)
        output.captcha.map({ $0.isEnabled }).distinctUntilChanged().drive(captchaButton.rx.isEnabled).disposed(by: disposeBag)
        output.captcha.asObservable().take(1).map(to: ()).asDriver(onErrorJustReturn: ()).drive(passwordTextField.rx.becomeFirstResponder).disposed(by: disposeBag)
        output.login.map(to: ()).drive(rx.dismiss).disposed(by: disposeBag)
        output.login.drive(view.rx.endEditing).disposed(by: disposeBag)
        output.state.drive(Toast.rx.state).disposed(by: disposeBag)
        
        view.rx.swipeGesture(.left).when(.recognized).map(to: ()).bind(to: rx.push(RegisterViewController.self)).disposed(by: disposeBag)
    }
}
