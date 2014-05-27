//
//  NZHArticleViewController.m
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHArticleViewController.h"
#import "NZHArticleHeaderView.h"

#import "NZHArticle.h"

#import <UIImageView+AFNetworking.h>

@interface NZHArticleViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NZHArticle *article;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) CALayer *blackBackground;

@property (strong, nonatomic) NZHArticleHeaderView *articleHeaderView;

@end

@implementation NZHArticleViewController

- (id)initWithArticle:(NZHArticle *)article
{
    if (self = [super init]) {
        _article = article;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.blackBackground = [CALayer layer];
    self.blackBackground.backgroundColor = [UIColor blackColor].CGColor;
    [self.scrollView.layer addSublayer:self.blackBackground];
    
    self.articleHeaderView = [[NZHArticleHeaderView alloc] initWithArticle:self.article];
    [self.scrollView addSubview:self.articleHeaderView];

    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.text = self.article.content;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
    self.contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.contentLabel];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    
    // Quick way to test if this improves perfomance
    self.contentLabel.alpha = 0.0f;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[self.article.content dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        
        NSRange textRange = NSMakeRange(0, [content length]);
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:textRange];
        [content addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Georgia" size:18] range:textRange];
        [content addAttribute:NSParagraphStyleAttributeName value:style range:textRange];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            self.contentLabel.attributedText = content;
            
            [UIView animateWithDuration:0.1 animations:^{
                self.contentLabel.alpha = 1.0f;
            }];
        });
    });

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.width = self.view.width;
    self.scrollView.height = self.view.height;
    
    self.blackBackground.frame = CGRectMake(0, -500, self.view.width, self.view.height + 500);
    
    self.articleHeaderView.width = self.view.width;
    self.articleHeaderView.height = self.view.height;
    
    self.contentLabel.width = self.view.width - 30;
    self.contentLabel.left = 15;
    [self.contentLabel sizeToFit];
    self.contentLabel.top = self.articleHeaderView.bottom + 15;
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.contentLabel.bottom + 15);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        self.articleHeaderView.top = 0;
        [self.articleHeaderView setTextOffset:0];
        [self.articleHeaderView setImageOffset:scrollView.contentOffset.y];
    } else {
        self.articleHeaderView.top = scrollView.contentOffset.y;
        [self.articleHeaderView setImageOffset:0];
        [self.articleHeaderView setTextOffset:-scrollView.contentOffset.y * 2];
    }
}

@end
