//
//  ArticleIndexCollectionViewController.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit
import YapDatabase
import YapDatabase.YapDatabaseView

protocol ArticleIndexCollectionViewControllerDelegate: class {
    func articleIndexCollectionViewControllerDidTapArticle(viewController: ArticleIndexCollectionViewController, article: Article)
}

class ArticleIndexCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let services: Services
    
    weak var delegate: ArticleIndexCollectionViewControllerDelegate? = nil
    
    let prototypeCell: ArticleIndexCollectionViewCell = ArticleIndexCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
    
    var currentPage = 0
    var articles: [Article] = []
    
    init(services: Services) {
        self.services = services
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 50
        super.init(collectionViewLayout: layout)
        
        self.title = "Latest News"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerClass(ArticleIndexCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView?.backgroundColor = UIColor.whiteColor()
//        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        
        if self.services.networkController.queue.operationCount > 0 {
            return
        }
        
        self.currentPage = self.currentPage + 1
        
        let request = NZHeraldAPI.LatestNews(count: 12, page: self.currentPage)
        
        self.services.networkController.performRequest(request) { (articles) in
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.articles += articles
                self.collectionView?.reloadData()
            })
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected: \(indexPath)")
        
        let article: Article = self.articles[indexPath.row]
        self.delegate?.articleIndexCollectionViewControllerDidTapArticle(self, article: article)
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = self.articles.count
        print(rows)
        return rows
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ArticleIndexCollectionViewCell
        
        let article: Article = self.articles[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.configureWithArticle(article)
        
//        cell.layer.shadowRadius = 10
//        cell.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
//        cell.layer.shadowOpacity = 0.5
        //        cell.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let rowCount = self.articles.count
        
        print(rowCount)
        print(indexPath.row)
        if indexPath.row > rowCount - 5 {
            self.loadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let targetSize = CGSize.init(width: collectionView.frame.size.width - 40, height: 100)
        
        
        return CGSize(width: targetSize.width, height: 300)
//        
//        let article: Article = self.articles[indexPath.row]
//
//        
//        self.prototypeCell.frame = CGRectMake(0, 0, targetSize.width, targetSize.height)
//        self.prototypeCell.configureWithArticle(article!)
//        self.prototypeCell.setNeedsLayout()
//        self.prototypeCell.layoutIfNeeded()
//        
//        let size = self.prototypeCell.contentView.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
//        
//        return CGSize.init(width: size.width, height: size.height)
    }
    
}

