//
//  Database.swift
//  NZHerald
//
//  Created by Will Townsend on 23/04/16.
//
//

import Foundation
import YapDatabase

extension YapDatabaseQuery {
    
    class func queryWithFormat(format: String, _ arguments: CVarArgType...) -> YapDatabaseQuery? {
        return withVaList(arguments, { YapDatabaseQuery(format: format, arguments: $0) })
    }
}

public class DatabaseManager {
    
    /// Reference to the current YapDatabase
    public var database: YapDatabase? = nil
    
    /// Internal database connection which is used when querying the database
    var databaseConnection: YapDatabaseConnection?
    
    // MARK: - Initializers
    
    init() {
        self.database = YapDatabase(path: self.databasePath())
        self.databaseConnection = self.database?.newConnection()
        self.createDatabaseViews()
    }
    
    // MARK: - Private
    
    /// Returns the stops database path
    func databasePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = paths[0] + "/database.sqlite"
        print("Using Database Path: \(path)")
        return path
    }
    
    func createDatabaseViews() {
        
        let grouping = YapDatabaseViewGrouping.withRowBlock { (let transaction, let collection, let key, let object, let metadata) -> String? in
            return "articles"
        }
        
        let sorting = YapDatabaseViewSorting.withObjectBlock { (let transaction, let group, let collection1, let key1, let object1, let collection2, let key2, let object2) -> NSComparisonResult in
            
            if let article1 = object1 as? Article, article2 = object2 as? Article {
                return article2.createdDate.compare(article1.createdDate)
            }
            
            return .OrderedAscending
        }
        
        let articleViewExtension = YapDatabaseView(grouping: grouping, sorting: sorting)
        self.database?.registerExtension(articleViewExtension, withName: "latest-articles")
    }
    

}
