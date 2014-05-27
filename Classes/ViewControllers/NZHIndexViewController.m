//
//  NZHIndexViewController.m
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHIndexViewController.h"

#import "NZHClassification.h"
#import "NZHCategoryViewController.h"

#import "NZHInteractiveTransition.h"

@interface NZHIndexViewController () <UITableViewDataSource, UITableViewDelegate, NZHCategoryViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NZHInteractiveTransition *interactiveTransitionController;

@end

@implementation NZHIndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interactiveTransitionController = [NZHInteractiveTransition new];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Category";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NZHCategoryViewController *categoryViewController = [[NZHCategoryViewController alloc] init];
    categoryViewController.categoryViewControllerDelegate = self;
    categoryViewController.transitioningDelegate = self.interactiveTransitionController;
    categoryViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:categoryViewController animated:YES completion:^{
        self.interactiveTransitionController.reversed = YES;
    }];
    
    // Show view controller from rootview
    if ([self.delegate respondsToSelector:@selector(indexViewController:didSelectClassification:)]) {
        //[self.delegate indexViewController:self didSelectClassification:[NZHClassification new]];
    }
}

#pragma mark - NZHCategoryViewControllerDelegate

- (void)categoryViewControllerRequestsDismissal:(NZHCategoryViewController *)categoryViewController
{
    [categoryViewController dismissViewControllerAnimated:YES completion:^{
        self.interactiveTransitionController.reversed = NO;
    }];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NZHInteractiveTransition *animationController = [NZHInteractiveTransition new];
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NZHInteractiveTransition *animationController = [NZHInteractiveTransition new];
    animationController.reversed = YES;
    return animationController;
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

@end
