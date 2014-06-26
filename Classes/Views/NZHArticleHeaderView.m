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
#import <NSDate+NVTimeAgo.h>

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

#pragma mark - Instance

- (id)initWithArticle:(NZHArticle *)article
{
    if (self = [super init]) {
        
        _article = article;
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        // Add Subviews
        [self addSubview:self.articleImageView];
        [self addSubview:self.reversedArticleImageView];
        
        [self.layer addSublayer:self.backgroundGradient];
        
        [self addSubview:self.headingLabel];
        [self addSubview:self.introLabel];
        [self addSubview:self.publishedLabel];
        
        self.headingLabel.text = self.article.headline;
        self.introLabel.attributedText = [self attributedIntroTextWithArticle:self.article];
        self.publishedLabel.text = [self.article.publishedDate formattedAsTimeAgo];
        
        [self loadImage];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.articleImageView.top = self.imageOffset * 0.8f;
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

- (void)loadImage
{
    NSURL *imageUrl = [NSURL URLWithString:[self.article.imageUrls firstObject]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // AFImageResponseSerializer will garentee that we've an image response.
        self.articleImage = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error.localizedDescription);
    }];
    
    [requestOperation start];
}

- (NSAttributedString *)attributedIntroTextWithArticle:(NZHArticle *)article
{
    // Create paragraph styles
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    
    // Create the mutable attributed string
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithData:[article.introText dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    // Add text attributes
    NSRange textRange = NSMakeRange(0, [introText length]);
    [introText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:textRange];
    [introText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Georgia-Italic" size:18] range:textRange];
    [introText addAttribute:NSParagraphStyleAttributeName value:style range:textRange];
    
    return introText;
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
    self.articleImageView.top = self.imageOffset * 0.8f;
    self.reversedArticleImageView.top = self.articleImageView.bottom;
}

- (void)setArticleImage:(UIImage *)articleImage
{
    _articleImage = articleImage;
    
    self.articleImageView.image = articleImage;
    self.reversedArticleImageView.image = articleImage;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.articleImageView.alpha = 1.0f;
        self.reversedArticleImageView.alpha = 1.0f;
    }];
}

#pragma mark - Getters

- (UIImageView *)articleImageView
{
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] init];
        _articleImageView.alpha = 0.0f;
    }
    return _articleImageView;
}

- (UIImageView *)reversedArticleImageView
{
    if (!_reversedArticleImageView) {
        _reversedArticleImageView = [[UIImageView alloc] init];
        _reversedArticleImageView.layer.transform = CATransform3DMakeRotation((float)(M_PI), 1.0f, 0, 0);
        _reversedArticleImageView.layer.doubleSided = YES;
        _reversedArticleImageView.alpha = 0.0f;
    }
    return _reversedArticleImageView;
}

- (CAGradientLayer *)backgroundGradient
{
    if (!_backgroundGradient) {
        _backgroundGradient = [CAGradientLayer layer];
        _backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        _backgroundGradient.startPoint = CGPointMake(0, 0.2f);
        _backgroundGradient.endPoint = CGPointMake(0, 0.8f);
    }
    return _backgroundGradient;
}

- (UILabel *)headingLabel
{
    if (!_headingLabel) {
        _headingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headingLabel.textColor = [UIColor whiteColor];
        _headingLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:34];
        _headingLabel.numberOfLines = 0;
    }
    return _headingLabel;
}

- (UILabel *)introLabel
{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introLabel.textColor = [UIColor whiteColor];
        _introLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18];
        _introLabel.numberOfLines = 0;
    }
    return _introLabel;
}

- (UILabel *)publishedLabel
{
    if (!_publishedLabel) {
        _publishedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _publishedLabel.textColor = [UIColor whiteColor];
        _publishedLabel.font = [UIFont fontWithName:@"Georgia" size:12];
        _publishedLabel.numberOfLines = 0;
    }
    return _publishedLabel;
}

@end
