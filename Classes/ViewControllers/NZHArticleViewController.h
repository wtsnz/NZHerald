//
//  NZHArticleViewController.h
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NZHArticle;

@interface NZHArticleViewController : UIViewController

- (id)initWithArticle:(NZHArticle *)article;

@property (nonatomic) NSUInteger pageIndex;

@end
