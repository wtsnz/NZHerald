//
//  ArticleViewController.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit
import DTFoundation
import DTCoreText

protocol ArticleViewControllerDelegate: class {
    func articleViewControllerTappedClose(articleViewController: ArticleViewController)
}

class ArticleViewController: UIViewController {
    
    let services: Services
    let article: Article
    
    weak var delegate: ArticleViewControllerDelegate? = nil
    
    var rootView: ArticleView! { return self.view as! ArticleView }
    
    init(services: Services, article: Article) {
        self.services = services
        self.article = article
        super.init(nibName: nil, bundle: nil)
        
        self.title = article.headline
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(tappedCloseButton))
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ArticleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = self.article.content.dataUsingEncoding(NSUTF8StringEncoding) {
            
            let options: [String: AnyObject] = [
                DTDefaultFontFamily: "SanFranciscoDisplay",
                DTDefaultFontName: "Regular",
                DTDefaultFontSize: 20.0
            ]
            
            let string = DTHTMLAttributedStringBuilder(HTML: data, options: options, documentAttributes: nil)
            
            self.rootView.textLabel.attributedString = string.generatedAttributedString()
            self.rootView.textLabel.edgeInsets = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
            self.rootView.textLabel.invalidateIntrinsicContentSize()
            self.rootView.textLabel.layoutIfNeeded()
            
        }
    }
    
    func tappedCloseButton() {
        self.delegate?.articleViewControllerTappedClose(self)
    }
    
}
