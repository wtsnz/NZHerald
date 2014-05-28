//
//  NZHCategoryViewController.h
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NZHClassification;
@class NZHCategoryViewController;

@protocol NZHCategoryViewControllerDelegate <NSObject>

- (void)categoryViewControllerRequestsDismissal:(NZHCategoryViewController *)categoryViewController;

@end

@interface NZHCategoryViewController : UIPageViewController

@property (weak, nonatomic) id <NZHCategoryViewControllerDelegate> categoryViewControllerDelegate;

- (id)initWithClassification:(NZHClassification *)classification;

@end
