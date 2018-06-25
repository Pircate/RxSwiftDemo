//
//  TodoItemCell.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/23.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import RxSwift

class TodoItemCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        UILabel().chain.systemFont(ofSize: 16).build
    }()
    
    lazy var followButton: UIButton = {
        UIButton(type: .custom).chain
            .image(#imageLiteral(resourceName: "unlike"), for: .normal)
            .image(#imageLiteral(resourceName: "like"), for: .selected)
            .systemFont(ofSize: 14).build
    }()
    
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.25) {
            self.followButton.transform = highlighted ? CGAffineTransform(scaleX: 0.8, y: 0.8) : CGAffineTransform.identity
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(followButton)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        followButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TodoItemCell {
    
    func bindViewModel(_ item: TodoItemModel) {
        nameLabel.text = item.name
        followButton.isSelected = item.follow
        
        let input = TodoItemModel.Input(followTap: followButton.rx.tap)
        let output = item.transform(input)
        output.isSelected.drive(followButton.rx.isSelected).disposed(by: disposeBag)
        output.state.drive(Toast.rx.state).disposed(by: disposeBag)
    }
}
