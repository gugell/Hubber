//
//  AvatarTableViewCell.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit
import SDWebImage

class AvatarTableViewCell: UITableViewCell {
    
    var contentImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = 50
        contentImageView.sd_setShowActivityIndicatorView(true)
        contentImageView.sd_setIndicatorStyle(.gray)
        self.addSubview(contentImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentImageUrl: String? {
        didSet{
            guard let urlString = self.contentImageUrl, let url = URL(string: urlString) else { return }
            contentImageView.sd_setImage(with: url) { [weak self] (_, _, _, _) in
                guard let center = self?.center else { return }
                self?.contentImageView.center = center
            }
        }
    }
    
}
