//
//  NZHAPIClient.h
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "AFURLSessionManager.h"

@interface NZHAPIClient : AFURLSessionManager

+ (NZHAPIClient *)shared;

- (void)fetchArticlesForClassificationId:(NSInteger)classificationId withCompletion:(void (^)(NSError *error, NSArray *articles))completionBlock;
- (void)fetchClassificationsWithCompletion:(void (^)(NSError *error, NSArray *classifications))completionBlock;

@end
