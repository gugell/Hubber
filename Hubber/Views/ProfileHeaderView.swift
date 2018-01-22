//
//  ProfileHeaderView.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/20/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var forksCountLabel: UILabel!
    private var starsCountLabel: UILabel!
    private var readMeButton: UIButton!

    func configure(title: String, description: String, forksCount: String, starsCount: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        forksCountLabel.text = "\(forksCount) forks"
        starsCountLabel.text = "\(starsCount) stars"

    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViewConfiguration()
    }

    func setupViewConfiguration() {

        titleLabel = UILabel()
        forksCountLabel = UILabel()
        starsCountLabel = UILabel()

        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.text = description

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        forksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        starsCountLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        forksCountLabel.sizeToFit()
        starsCountLabel.sizeToFit()

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(forksCountLabel)
        self.contentView.addSubview(starsCountLabel)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
