//
//  ArticleIndexCollectionViewCell.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit
import SnapKit
import Kingfisher

class ArticleIndexCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.redColor()
        
        self.imageView.clipsToBounds = true
        
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        
        self.imageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.leading.equalTo(self.contentView).offset(10)
            make.height.equalTo(100)
            make.width.equalTo(self.imageView.snp_height)
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-10)
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.imageView.snp_right).offset(10)
            make.trailing.equalTo(self.contentView).offset(-10)
        }
        
        self.descriptionLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
            make.left.equalTo(self.titleLabel)
            make.trailing.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithArticle(article: Article) {
        self.titleLabel.text = article.headline
//        self.descriptionLabel.text = article.introText
        self.descriptionLabel.text = "TECHNOLOGY"
        self.imageView.kf_setImageWithURL(NSURL(string: article.imageUrl)!, placeholderImage: nil)
    }
    
}
