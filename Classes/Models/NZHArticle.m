//
//  NZHArticle.m
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHArticle.h"

@interface NZHArticle ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation NZHArticle

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"imageUrls": @"images.320x320.src",
             @"introText": @"intro_text",
             @"content": @"content",
             @"headline": @"headline",
             @"publishedDate": @"publish_date"
             };
}

+ (NSValueTransformer *)publishedDateJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate *date = [self.dateFormatter dateFromString:str];
        NSLog(@"%@", date);
        return date;
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

static NSDateFormatter *kDateFormatter;
+ (NSDateFormatter *)dateFormatter
{
    
    
    if (kDateFormatter == nil) {
        kDateFormatter = [[NSDateFormatter alloc] init];
        [kDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss'.'S"];
    }
    
    return kDateFormatter;
}

@end
