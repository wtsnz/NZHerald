//
//  NZHArticle.m
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHArticle.h"

static NSInteger const kMaximumArticleIntroTextLength = 250;

@interface NZHArticle ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation NZHArticle

static NSDateFormatter *kDateFormatter = nil;

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
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter
{
    if (kDateFormatter == nil) {
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss'.'S";
    }
    return kDateFormatter;
}

#pragma mark - Setters

- (void)setIntroText:(NSString *)introText
{
    // Trim the intro text if needed
    if ([introText length] > kMaximumArticleIntroTextLength) {
        NSRange range = {0, kMaximumArticleIntroTextLength - 3};
        range = [introText rangeOfComposedCharacterSequencesForRange:range];
        introText = [NSString stringWithFormat:@"%@...", [introText substringWithRange:range]];
    }
    
    _introText = introText;
}

@end
