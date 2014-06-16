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

#import "NZHIndexHeaderView.h"

#import "NZHAPIClient.h"

#import "NZHInteractiveTransition.h"

@interface NZHIndexViewController () <UITableViewDataSource, UITableViewDelegate, NZHCategoryViewControllerDelegate>

@property (strong, nonatomic) NZHIndexHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NZHInteractiveTransition *interactiveTransitionController;

@property (weak, nonatomic) UITableViewCell *lastSelectedTableViewCell;

@property (strong, nonatomic) NSArray *classifications;

@end

@implementation NZHIndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interactiveTransitionController = [NZHInteractiveTransition new];
    
    self.classifications = [NSArray array];
    
    [self.view addSubview:self.tableView];
    
    self.headerView = [[NZHIndexHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [self.view addSubview:self.headerView];
    
    [[NZHAPIClient shared] fetchClassificationsWithCompletion:^(NSError *error, NSArray *classifications) {
        
        if (!error) {
            self.classifications = classifications;
            [self.tableView reloadData];
        }
        
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.headerView.width = self.view.width;
    self.headerView.height = 100;
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    self.tableView.frame = self.view.bounds;

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.classifications count];
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
    
    NZHClassification *classification = self.classifications[(NSUInteger)indexPath.row];
    
    cell.textLabel.text = classification.name;
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:24];
    
    return cell;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastSelectedTableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.interactiveTransitionController.sourceTableViewCell = self.lastSelectedTableViewCell;
    
    NZHClassification *classification = self.classifications[(NSUInteger)indexPath.row];
    
    NZHCategoryViewController *categoryViewController = [[NZHCategoryViewController alloc] initWithClassification:classification];
    categoryViewController.categoryViewControllerDelegate = self;
    categoryViewController.transitioningDelegate = self.interactiveTransitionController;
    categoryViewController.modalPresentationStyle = UIModalPresentationCustom;
    categoryViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:categoryViewController animated:YES completion:^{
        self.interactiveTransitionController.reversed = YES;
    }];
    
}

#pragma mark - NZHCategoryViewControllerDelegate

- (void)categoryViewControllerRequestsDismissal:(NZHCategoryViewController *)categoryViewController
{
    [categoryViewController dismissViewControllerAnimated:YES completion:^{
        self.interactiveTransitionController.reversed = NO;
    }];
    
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
