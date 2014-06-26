//
//  NZHCategoryHeaderView.m
//  NZ Herald
//
//  Created by Will Townsend on 16/06/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHCategoryHeaderView.h"

@interface NZHCategoryHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) CAGradientLayer *backgroundGradient;
@property (strong, nonatomic) UIImageView *arrowIconImageView;

@end

@implementation NZHCategoryHeaderView

#pragma mark - Instance

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self.layer addSublayer:self.backgroundGradient];
        [self addSubview:self.titleLabel];
        [self addSubview:self.arrowIconImageView];
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundGradient.frame = self.bounds;
    
    self.titleLabel.left = 15.0f;
    self.titleLabel.width = self.width - 30.0f;
    self.titleLabel.height = self.height;
    
    self.arrowIconImageView.right = self.right - 15.0f;
    self.arrowIconImageView.top = self.height / 2 - self.arrowIconImageView.height / 2;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:@"Georgia" size:24];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (CAGradientLayer *)backgroundGradient
{
    if (!_backgroundGradient) {
        _backgroundGradient = [CAGradientLayer layer];
        _backgroundGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor, (id)[[UIColor clearColor] CGColor], nil];
        _backgroundGradient.startPoint = CGPointMake(0, 0.0f);
        _backgroundGradient.endPoint = CGPointMake(0, 1.0f);
    }
    return _backgroundGradient;
}

- (UIImageView *)arrowIconImageView
{
    if (!_arrowIconImageView) {
        _arrowIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _arrowIconImageView;
}

@end
