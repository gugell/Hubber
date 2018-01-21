//
//  RepoCell.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit
import SnapKit

class RepoCell: UITableViewCell {
    
     var titleLabel: UILabel!
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
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.purple
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.sizeToFit()
        self.addSubview(descriptionLabel)
        
        languageLabel = UILabel()
        languageLabel.textColor = UIColor.darkGray
        
        languageLabel.sizeToFit()
        self.addSubview(languageLabel)
        
        starsLabel = UILabel()
        starsLabel.textColor = UIColor.darkGray
        starsLabel.sizeToFit()
        self.addSubview(starsLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        var allConstraints = [NSLayoutConstraint]()
        let views: [String: AnyObject] = ["titleLabel": titleLabel,
                                          "descriptionLabel": descriptionLabel,
                                          "languageLabel": languageLabel,
                                          "starsLabel": starsLabel]
        
        let titleLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[titleLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += titleLabelConstraints
        
        let descriptionLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[descriptionLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += descriptionLabelConstraints
        
        let starsAndlanguageLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[languageLabel]-[starsLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += starsAndlanguageLabelConstraints
        
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-[descriptionLabel]-[languageLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += verticalConstraints
        
        let starsLabelverticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-[descriptionLabel]-[starsLabel]-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += starsLabelverticalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
        
    }
    
    func configure(title: String, description: String, language: String, stars: String) {
   
        titleLabel.text = title
        descriptionLabel.text = description
        languageLabel.text = language
        starsLabel.text = stars
    }
}
