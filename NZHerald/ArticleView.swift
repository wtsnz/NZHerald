//
//  ArticleView.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit
import DTCoreText

class ArticleView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var textLabel: DTAttributedTextContentView = {
        let textLabel = DTAttributedTextContentView()
        return textLabel
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.textLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.scrollView)
            make.left.equalTo(self.scrollView)
            make.right.equalTo(self.scrollView)
            make.bottom.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
