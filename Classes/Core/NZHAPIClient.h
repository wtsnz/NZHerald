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

- (void)fetchClassificationsWithCompletion:(void (^)(id JSON))completionBlock onFailure:(void (^)())failureBlock;

@end
