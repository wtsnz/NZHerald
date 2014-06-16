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

@end

@implementation NZHCategoryHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.titleLabel];
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLabel.left = 15.0f;
    self.titleLabel.width = self.width - 40.0f;
    self.titleLabel.height = self.height;
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
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end
