//
//  NZHInteractiveTransition.m
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHInteractiveTransition.h"

@interface NZHInteractiveTransition () <UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic) BOOL interactive;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation NZHInteractiveTransition

- (id)init
{
    if (self = [super init]) {
        self.interactive = NO;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (self.interactive) {
        return self;
    }
    
    return nil;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animationEnded:(BOOL)transitionCompleted
{
    self.interactive = NO;
    self.presenting = NO;
    self.transitionContext = nil;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offscreenRect = initialFrame;
    offscreenRect.origin.y = initialFrame.origin.y + initialFrame.size.height;
    
    // Dissmiss the View Controller
    if (self.reversed) {
        [containerView addSubview:toView];
        [containerView sendSubviewToBack:toView];
        
        toView.layer.affineTransform = CGAffineTransformMakeScale(0.96f, 0.96f);
        toView.top = 20.0f;
        
        // Animate out
        [UIView animateWithDuration:duration animations: ^{
            toView.alpha = 1.0f;
            toView.layer.affineTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
            toView.top = 0.0f;
            
            fromView.frame = offscreenRect;
            // Add a little right rotation to the fall
            NSInteger r = (NSInteger)(arc4random_uniform(8) + 4);
            fromView.layer.transform = CATransform3DMakeRotation((float)(r * (M_PI / 180.0f)), 0, 0, 1);
        } completion: ^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
    // Present the View Controller
    else {
        
        // Position the view offscreen (Be sure to add to view before setting frame)
        [containerView insertSubview:toView belowSubview:fromView];
        toView.frame = initialFrame;
        
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.85f initialSpringVelocity:0.3f options:0 animations:^{
            //toView.frame = initialFrame;
            fromView.layer.affineTransform = CGAffineTransformMakeScale(0.96f, 0.96f);
            fromView.top = 20.0f;
            fromView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
}

#pragma mark - UIViewControllerInteractiveTransitioning

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // TODO
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    // TODO
}

- (void)finishInteractiveTransition
{
    // TODO
}

- (void)cancelInteractiveTransition
{
    // TODO
}


@end
