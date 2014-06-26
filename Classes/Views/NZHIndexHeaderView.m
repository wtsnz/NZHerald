//
//  NZHIndexHeaderView.m
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHIndexHeaderView.h"

@interface NZHIndexHeaderView ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation NZHIndexHeaderView

#pragma mark - Instance

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Configure View
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.width;
    self.imageView.height = self.height;
    
}

#pragma mark - Getters

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New_Zealand_Herald_logo"]];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

@end
