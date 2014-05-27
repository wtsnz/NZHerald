//
//  NZHRootViewController.m
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHRootViewController.h"

#import "NZHIndexViewController.h"
#import "NZHCategoryViewController.h"

@interface NZHRootViewController ()

@property (strong, nonatomic) NZHIndexViewController *indexViewController;

@end

@implementation NZHRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (NO) {
        NZHIndexViewController *indexViewController = [[NZHIndexViewController alloc] init];
        [self addChildViewController:indexViewController];
        indexViewController.view.frame = self.view.frame;
        [self.view addSubview:indexViewController.view];
        [indexViewController didMoveToParentViewController:self];
        self.indexViewController = indexViewController;
        
    } else {
        NZHCategoryViewController *indexViewController = [[NZHCategoryViewController alloc] init];
        [self addChildViewController:indexViewController];
        indexViewController.view.frame = self.view.frame;
        [self.view addSubview:indexViewController.view];
        [indexViewController didMoveToParentViewController:self];
    }
    
    
    
}

@end
