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
            .activeColor(UIColor(hex: "#CE9728")).installed
    }()
    
    private lazy var passwordTextField: EffectTextField = {
        return EffectTextField().chain
            .placeholder("请输入密码")
            .returnKeyType(.go)
            .inactiveColor(UIColor(hex: "#EFEFEF"))
            .activeColor(UIColor(hex: "#CE9728")).installed
    }()
    
    private lazy var registerButton: UIButton = {
        return UIButton(type: .custom).chain
            .backgroundColor(UIColor.cyan)
            .cornerRadius(5)
            .masksToBounds(true)
            .backgroundImage(#imageLiteral(resourceName: "login_button_enabled"), for: .normal)
            .backgroundImage(#imageLiteral(resourceName: "login_button_disabled"), for: .disabled)
            .title("注册", for: .normal)
            .isEnabled(false).installed
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSubviews() {
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.width - 60, height: 36))
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
        let input = RegisterViewModel.Input(username: usernameTextField.rx.text.orEmpty,
                                            password: passwordTextField.rx.text.orEmpty,
                                            register: registerButton.rx.tap)
        
        let output = viewModel.transform(input)
        output.validation.drive(registerButton.rx.isEnabled).disposed(by: disposeBag)
        output.register.subscribe(onNext: { (success) in
            if success {
                self.goBack()
            }
        }).disposed(by: disposeBag)
    }

}
