//
//  NZHAPIClient.m
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHAPIClient.h"

@implementation NZHAPIClient

static NSString * const kServerBaseURL = @"http://rss.nzherald.co.nz/touch/?version=2.2&method=";
static NSString * const kAPIMethodClassifications = @"config.getMenuItems";
static NSString * const kAPIMethodArticles = @"stories.getLatest";
static NSString * const kAPIAppID = @"41";

#pragma mark - Class

+ (NZHAPIClient *)shared
{
    static NZHAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

+ (NSString *)generateUUID
{
    CFUUIDRef UUID = CFUUIDCreate(NULL);
    CFStringRef UUIDString = CFUUIDCreateString(NULL, UUID);
    CFRelease(UUID);
    return (__bridge NSString *)UUIDString;
}

#pragma mark - Instance

- (NSString *)authorizationString
{
    // From investigation, the only required parameter for authorization is the appId.
    // The apiKey is optional for some reason, but easy enough to guess (AppId:InstallTimestamp:UUID - maybe advertisers?)
    // This will just make something that looks like a legit one, though obviously it's not.
    
    NSString *uuid = [[NZHAPIClient generateUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSInteger timestamp = (NSInteger)[[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"&appID=%@&apikey=%@:%@:%@", kAPIAppID, kAPIAppID, @(timestamp), uuid];
}

- (void)fetchArticlesForClassificationId:(NSInteger)classificationId withCompletion:(void (^)(id JSON))completionBlock onFailure:(void (^)())failureBlock
{
    // Create the API URL
    NSString *url = [kServerBaseURL stringByAppendingString:kAPIMethodArticles];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&cId=%@&maxrows=35&fullContent=1", @(classificationId)]];
    url = [url stringByAppendingString:[self authorizationString]];
    
    NSURL *requestURL = [NSURL URLWithString:url];
    
    [self fetchRequestWithURL:requestURL onCompletion:completionBlock onFailure:failureBlock];
}

- (void)fetchClassificationsWithCompletion:(void (^)(id JSON))completionBlock onFailure:(void (^)())failureBlock
{
    // Create the API URL
    NSString *url = [kServerBaseURL stringByAppendingString:kAPIMethodClassifications];
    url = [url stringByAppendingString:[self authorizationString]];
    
    NSURL *requestURL = [NSURL URLWithString:url];
    
    [self fetchRequestWithURL:requestURL onCompletion:completionBlock onFailure:failureBlock];
}

- (void)fetchRequestWithURL:(NSURL *)url onCompletion:(void (^)(id JSON))completionBlock onFailure:(void (^)())failureBlock
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionBlock(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        failureBlock();
        
    }];
    
    [requestOperation start];
}

@end
