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
        self.presenting = NO;
        return self;
    }
    
    return nil;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animationEnded:(BOOL)transitionCompleted
{
    //self.interactive = NO;
    //self.presenting = NO;
    //self.transitionContext = nil;
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
    
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offscreenRect = initialFrame;
    offscreenRect.origin.y = initialFrame.origin.y + initialFrame.size.height;
    
    // Hide Category View
    if (self.reversed) {
        
        toView.alpha = 1.0f;
        
        // Find Frames
        CGRect tableViewCellFrame = [containerView convertRect:self.sourceTableViewCell.frame fromView:self.sourceTableViewCell.superview];
        CGRect aboveCellFrame = CGRectMake(0, 0, tableViewCellFrame.size.width, tableViewCellFrame.origin.y);
        CGRect belowCellFrame = CGRectMake(0, tableViewCellFrame.origin.y + tableViewCellFrame.size.height, tableViewCellFrame.size.width, initialFrame.size.height - tableViewCellFrame.origin.y + tableViewCellFrame.size.height);
        
        // Create snapshots
        UIView *cellSnapshot = [self.sourceTableViewCell snapshotViewAfterScreenUpdates:YES];
        UIView *aboveCellSnapshot = [toView resizableSnapshotViewFromRect:aboveCellFrame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        UIView *belowCellSnapshot = [toView resizableSnapshotViewFromRect:belowCellFrame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        
        toView.alpha = 0.0f;
        cellSnapshot.alpha = 0.0f;
        
        // Set frames
        aboveCellSnapshot.bottom = 0;
        cellSnapshot.top = 0.0f;
        belowCellSnapshot.top = containerView.frame.size.height;
        
        // Add Snapshots
        [containerView addSubview:aboveCellSnapshot];
        [containerView addSubview:cellSnapshot];
        [containerView addSubview:belowCellSnapshot];
        
        [containerView addSubview:toView];
        [containerView bringSubviewToFront:toView];
        
        // Animate out
        [UIView animateWithDuration:duration animations: ^{
            
            cellSnapshot.alpha = 1.0f;
            cellSnapshot.frame = tableViewCellFrame;
            aboveCellSnapshot.bottom = cellSnapshot.top;
            belowCellSnapshot.top = cellSnapshot.bottom;
            
            fromView.layer.affineTransform = CGAffineTransformMakeScale(0.96f, 0.96f);
            fromView.alpha = 0.1f;
            
        } completion: ^(BOOL finished) {
            
            toView.alpha = 1.0f;
            
            [fromView removeFromSuperview];
            
            [aboveCellSnapshot removeFromSuperview];
            [cellSnapshot removeFromSuperview];
            [belowCellSnapshot removeFromSuperview];
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
    // Show Category View Controller
    else {
        
        
        toView.layer.affineTransform = CGAffineTransformMakeScale(0.96f, 0.96f);
        
        // Find Frames
        CGRect tableViewCellFrame = [containerView convertRect:self.sourceTableViewCell.frame fromView:self.sourceTableViewCell.superview];
        CGRect aboveCellFrame = CGRectMake(0, 0, tableViewCellFrame.size.width, tableViewCellFrame.origin.y);
        CGRect belowCellFrame = CGRectMake(0, tableViewCellFrame.origin.y + tableViewCellFrame.size.height, tableViewCellFrame.size.width, initialFrame.size.height - tableViewCellFrame.origin.y + tableViewCellFrame.size.height);
        
        // Create snapshots
        UIView *cellSnapshot = [self.sourceTableViewCell snapshotViewAfterScreenUpdates:NO];
        UIView *aboveCellSnapshot = [fromView resizableSnapshotViewFromRect:aboveCellFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        UIView *belowCellSnapshot = [fromView resizableSnapshotViewFromRect:belowCellFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    
        // Set frames
        cellSnapshot.frame = tableViewCellFrame;
        belowCellSnapshot.top = cellSnapshot.bottom;
        
        // Add Snapshots
        [containerView addSubview:aboveCellSnapshot];
        [containerView addSubview:cellSnapshot];
        [containerView addSubview:belowCellSnapshot];
        
        [fromView removeFromSuperview];
        
        [UIView animateWithDuration:0.8 delay:0.0f usingSpringWithDamping:0.85f initialSpringVelocity:0.3f options:0 animations:^{
            
            toView.layer.affineTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
            fromView.layer.affineTransform = CGAffineTransformMakeScale(1.04f, 1.04f);
            fromView.top = 20.0f;
            fromView.alpha = 0.0f;
            
            aboveCellSnapshot.bottom = 0.0f;
            cellSnapshot.alpha = 0.0f;
            cellSnapshot.top = 0.0f;
            
            belowCellSnapshot.top = initialFrame.size.height;
            
        } completion:^(BOOL finished) {
            
            [aboveCellSnapshot removeFromSuperview];
            [cellSnapshot removeFromSuperview];
            [belowCellSnapshot removeFromSuperview];
            
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
