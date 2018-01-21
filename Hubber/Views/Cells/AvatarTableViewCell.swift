//
//  AvatarTableViewCell.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class AvatarTableViewCell: UITableViewCell {
    
    var contentImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentImageView = UIImageView()
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = 50
        contentImageView.sd_setShowActivityIndicatorView(true)
        contentImageView.sd_setIndicatorStyle(.gray)
        self.addSubview(contentImageView)
        self.contentImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.height.width.equalTo(100)
            make.centerY.centerX.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentImageUrl: String? {
        didSet{
            guard let urlString = self.contentImageUrl, let url = URL(string: urlString) else { return }
            contentImageView.sd_setImage(with: url)
        }
    }
    
}
