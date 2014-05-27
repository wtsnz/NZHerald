//
//  NZHInteractiveTransition.h
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZHInteractiveTransition : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) UITableViewCell *sourceTableViewCell;

@property (nonatomic) BOOL presenting;
@property (nonatomic) BOOL reversed;

@end
