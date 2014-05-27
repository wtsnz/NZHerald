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

@interface NZHRootViewController () <NZHIndexViewControllerDelegate, NZHCategoryViewControllerDelegate>

@property (strong, nonatomic) NZHIndexViewController *indexViewController;

@end

@implementation NZHRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (YES) {
        NZHIndexViewController *indexViewController = [[NZHIndexViewController alloc] init];
        indexViewController.delegate = self;
        
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


#pragma mark - NZHIndexViewControllerDelegate

- (void)indexViewController:(NZHIndexViewController *)indexViewController didSelectClassification:(NZHClassification *)classification
{
    NZHCategoryViewController *categoryViewController = [[NZHCategoryViewController alloc] init];
    categoryViewController.categoryViewControllerDelegate = self;
    
    UIViewController *fromViewController = self.indexViewController;
    UIViewController *toViewController = categoryViewController;
    
    [self showViewController:toViewController fromViewController:fromViewController];
}

- (void)showViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController
{
    
    
    //toViewController.view.frame = fromViewController.view.bounds;
    [self addChildViewController:toViewController];
    [fromViewController willMoveToParentViewController:nil];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    toView.layer.affineTransform = CGAffineTransformMakeScale(0.96f, 0.96f);
    toView.top = 20.0f;
    [self.view insertSubview:toView belowSubview:fromView];
    
    CGRect initialFrame = fromViewController.view.frame;
    CGRect offscreenRect = initialFrame;
    offscreenRect.origin.y = initialFrame.origin.y + initialFrame.size.height;
    
    // Animate out
    [UIView animateWithDuration:0.3 animations: ^{
        toView.alpha = 1.0f;
        toView.layer.affineTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
        toView.top = 0.0f;
        fromView.frame = offscreenRect;
        NSInteger r = (NSInteger)(arc4random_uniform(30)) - 8;
        fromView.layer.transform = CATransform3DMakeRotation((float)(r * (M_PI / 180.0f)), 0, 0, 1);
        
    } completion: ^(BOOL finished) {
        
        [toViewController didMoveToParentViewController:self];
        [fromView removeFromSuperview];
        [fromViewController removeFromParentViewController];
        
    }];
    
}

#pragma mark - NZHCategoryViewControllerDelegate

- (void)categoryViewControllerRequestsDismissal:(NZHCategoryViewController *)categoryViewController
{
    [self showViewController:self.indexViewController fromViewController:categoryViewController];
}


@end
