//
//  UserCell.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/20/18.
//  Copyright © 2018 Stamax. All rights reserved.
//


import UIKit
import SnapKit
import SDWebImage

class UserCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var avatarImageView: UIImageView!
    var descriptionLabel: UILabel!
    var languageLabel: UILabel!
    var starsLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConfiguration(){
        
        self.avatarImageView = UIImageView()
        self.addSubview(avatarImageView)
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.purple
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.sizeToFit()
        //self.addSubview(descriptionLabel)
        
        languageLabel = UILabel()
        languageLabel.textColor = UIColor.darkGray
        
        // self.addSubview(languageLabel)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.snp.makeConstraints({ make in
            make.top.left.equalTo(self).offset(15)
            make.height.width.equalTo(40)
            make.centerY.equalTo(self)
            //            make.right.left.equalTo(self).offset(10)
            
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(self.avatarImageView)
            make.height.equalTo(30)
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(10)
        })
    }
    
    func configure(title: String, description: String, language: String, avatar: String) {
    
        self.avatarImageView.sd_setImage(with: URL.init(string: avatar), completed: nil)
        titleLabel.text = title
        descriptionLabel.text = description
        languageLabel.text = language
       
    }
}
