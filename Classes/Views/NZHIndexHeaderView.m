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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New_Zealand_Herald_logo"]];
        self.imageView.contentMode = UIViewContentModeCenter;
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

@end
