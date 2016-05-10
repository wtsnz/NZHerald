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
    
    let connection: YapDatabaseConnection
    let mappings = YapDatabaseViewMappings(groups: ["articles"], view: "latest-articles")
    
    let prototypeCell: ArticleIndexCollectionViewCell = ArticleIndexCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
    
    var currentPage = 0
    
    init(services: Services) {
        self.services = services
        self.connection = self.services.databaseManager.database!.newConnection()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 50
        //        layout.estimatedItemSize = CGSizeMake(320, 400)
        
        super.init(collectionViewLayout: layout)
        
        self.collectionView?.registerClass(ArticleIndexCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.connection.beginLongLivedReadTransaction()
        self.connection.readWithBlock { (let transaction) in
            self.mappings.updateWithTransaction(transaction)
        }
        
        self.title = "Latest News"
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ArticleIndexCollectionViewController.databaseModified), name:YapDatabaseModifiedNotification, object: nil)
        
        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        
        // Remove all data from database
        
        self.services.networkController.databaseConnection.readWriteWithBlock { (transaction) in
            transaction.removeAllObjectsInCollection("articles")
        }
        
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
        
        self.services.networkController.performRequest(request) { () in
            print("done")
        }
    }
    
    @objc func databaseModified(notification: NSNotification) {
        
        let notifications = self.connection.beginLongLivedReadTransaction()
        
        self.connection.readWithBlock { (let transaction) in
            self.mappings.updateWithTransaction(transaction)
        }
        
        print("changed: \(notifications)")
        
        self.collectionView?.reloadData()
        return
        
        if let ext = self.connection.ext("latest-articles") as? YapDatabaseViewConnection {
            
            var rowChanges1: NSArray? = nil
            
            ext.getSectionChanges(nil, rowChanges: &rowChanges1, forNotifications: notifications, withMappings: self.mappings)
            
            guard let rowChanges = rowChanges1 as? [YapDatabaseViewRowChange] else {
                print("failed")
                return
            }
            
            if rowChanges.count == 0 {
                print("no changes")
                return
            }
            
            self.collectionView?.performBatchUpdates({
                
                for viewRowChange in rowChanges {
                    
                    switch viewRowChange.type {
                        
                    case .Delete:
                        self.collectionView?.deleteItemsAtIndexPaths([viewRowChange.indexPath])
                    case .Insert:
                        self.collectionView?.insertItemsAtIndexPaths([viewRowChange.indexPath])
                    case .Move:
                        self.collectionView?.moveItemAtIndexPath(viewRowChange.indexPath, toIndexPath: viewRowChange.newIndexPath)
                    case .Update:
                        self.collectionView?.reloadItemsAtIndexPaths([viewRowChange.indexPath])
                    }
                    
                }
                
                }, completion: nil)
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected: \(indexPath)")
        
        var article: Article? = nil
        
        self.connection.readWithBlock { (let transaction) in
            if let transaction = transaction.ext("latest-articles") as? YapDatabaseViewTransaction {
                article = transaction.objectAtIndexPath(indexPath, withMappings: self.mappings) as? Article
            }
        }
        
        if let article = article {
            self.delegate?.articleIndexCollectionViewControllerDidTapArticle(self, article: article)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = Int(self.mappings.numberOfItemsInSection(UInt(section)))
        print(rows)
        return rows
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ArticleIndexCollectionViewCell
        
        var article: Article? = nil
        
        self.connection.readWithBlock { (let transaction) in
            if let transaction = transaction.ext("latest-articles") as? YapDatabaseViewTransaction {
                article = transaction.objectAtIndexPath(indexPath, withMappings: self.mappings) as? Article
            }
        }
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.configureWithArticle(article!)
        
        cell.layer.shadowRadius = 10
        cell.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
        cell.layer.shadowOpacity = 0.5
        //        cell.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let rowCount = Int(self.mappings.numberOfItemsInSection(UInt(indexPath.section)))
        
        print(rowCount)
        print(indexPath.row)
        if indexPath.row > rowCount - 5 {
            self.loadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let targetSize = CGSize.init(width: collectionView.frame.size.width - 40, height: 100)
        
        
        return CGSize(width: targetSize.width, height: 300)
        
        var article: Article? = nil
        
        self.connection.readWithBlock { (let transaction) in
            if let transaction = transaction.ext("latest-articles") as? YapDatabaseViewTransaction {
                article = transaction.objectAtIndexPath(indexPath, withMappings: self.mappings) as? Article
            }
        }
        
        self.prototypeCell.frame = CGRectMake(0, 0, targetSize.width, targetSize.height)
        self.prototypeCell.configureWithArticle(article!)
        self.prototypeCell.setNeedsLayout()
        self.prototypeCell.layoutIfNeeded()
        
        let size = self.prototypeCell.contentView.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        
        return CGSize.init(width: size.width, height: size.height)
    }
    
}

