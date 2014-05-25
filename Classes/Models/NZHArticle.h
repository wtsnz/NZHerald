//
//  NZHArticle.h
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZHArticle : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) NSString *introText;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSDate *publishedDate;

@end
