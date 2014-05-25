//
//  NZHArticleHeaderView.m
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHArticleHeaderView.h"

#import "NZHArticle.h"

#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>

#import "NSDate+NVTimeAgo.h"

@interface NZHArticleHeaderView ()

@property (strong, nonatomic) NZHArticle *article;

@property (strong, nonatomic) CAGradientLayer *backgroundGradient;

@property (strong, nonatomic) UIImage *articleImage;
@property (strong, nonatomic) UIImageView *articleImageView;
@property (strong, nonatomic) UIImageView *reversedArticleImageView;

@property (strong, nonatomic) UILabel *headingLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UILabel *publishedLabel;

@property (nonatomic) CGFloat textOffset;
@property (nonatomic) CGFloat imageOffset;

@end

@implementation NZHArticleHeaderView

- (id)initWithArticle:(NZHArticle *)article
{
    if (self = [super init]) {
        _article = article;
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        self.articleImageView = [[UIImageView alloc] init];
        [self addSubview:self.articleImageView];
        
        self.reversedArticleImageView = [[UIImageView alloc] init];
        [self addSubview:self.reversedArticleImageView];
        
        NSURL *imageUrl = [NSURL URLWithString:[self.article.imageUrls firstObject]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
        
        self.articleImageView.alpha = 0.0f;
        self.reversedArticleImageView.alpha = 0.0f;
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            self.articleImage = responseObject;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
        self.backgroundGradient = [CAGradientLayer layer];
        self.backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        self.backgroundGradient.startPoint = CGPointMake(0, 0.2f);
        self.backgroundGradient.endPoint = CGPointMake(0, 0.8f);
        [self.layer addSublayer:self.backgroundGradient];
        
        self.headingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.headingLabel.text = self.article.headline;
        self.headingLabel.textColor = [UIColor whiteColor];
        self.headingLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:34];
        self.headingLabel.numberOfLines = 0;
        [self addSubview:self.headingLabel];
        
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 0;
        
        NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithData:[self.article.introText dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        
        [introText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [introText length])];
        [introText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Georgia-Italic" size:18] range:NSMakeRange(0, [introText length])];
        [introText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [introText length])];
        self.introLabel.attributedText = introText;
        self.introLabel.textColor = [UIColor whiteColor];
        self.introLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18];
        self.introLabel.numberOfLines = 0;
        [self addSubview:self.introLabel];
        
        NSLog(@"%@", self.article.publishedDate);
        
        self.publishedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.publishedLabel.text = [self.article.publishedDate formattedAsTimeAgo];
        self.publishedLabel.textColor = [UIColor whiteColor];
        self.publishedLabel.font = [UIFont fontWithName:@"Georgia" size:12];
        self.publishedLabel.numberOfLines = 0;
        [self addSubview:self.publishedLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.articleImageView.top = self.imageOffset * 0.8;
    self.articleImageView.width = self.width;
    self.articleImageView.height = self.articleImageView.width;
    
    self.reversedArticleImageView.top = self.articleImageView.bottom;
    self.reversedArticleImageView.width = self.width;
    self.reversedArticleImageView.height = self.reversedArticleImageView.width;
    
    self.publishedLabel.width = self.width - 30;
    self.publishedLabel.left = 15;
    [self.publishedLabel sizeToFit];
    self.publishedLabel.bottom = self.bottom - 15 + _textOffset;
    
    self.introLabel.width = self.width - 30;
    self.introLabel.left = 15;
    [self.introLabel sizeToFit];
    self.introLabel.bottom = self.publishedLabel.top - 15;
    
    self.headingLabel.width = self.width - 30;
    self.headingLabel.left = 15;
    [self.headingLabel sizeToFit];
    self.headingLabel.bottom = self.introLabel.top - 15;
    
    self.backgroundGradient.frame = CGRectMake(0, 0, self.width, self.height);
    
}

- (void)setTextOffset:(CGFloat)textOffset
{
    _textOffset = textOffset;
    self.publishedLabel.bottom = self.bottom - 15 + _textOffset;
    self.introLabel.bottom = self.publishedLabel.top - 15;
    self.headingLabel.bottom = self.introLabel.top - 15;
}

- (void)setImageOffset:(CGFloat)imageOffset
{
    _imageOffset = imageOffset;
    self.articleImageView.top = self.imageOffset * 0.8;
    self.reversedArticleImageView.top = self.articleImageView.bottom;
}

- (void)setArticleImage:(UIImage *)articleImage
{
    _articleImage = articleImage;
    
    self.articleImageView.image = articleImage;
    self.reversedArticleImageView.image = [UIImage imageWithCGImage:articleImage.CGImage scale:articleImage.scale orientation: UIImageOrientationDownMirrored];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.articleImageView.alpha = 1.0f;
        self.reversedArticleImageView.alpha = 1.0f;
    }];
}

@end
