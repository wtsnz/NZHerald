//
//  NZHCategoryViewController.m
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHCategoryViewController.h"

#import "NZHClassification.h"

#import "NZHArticleViewController.h"
#import "NZHArticle.h"

#import "NZHCategoryHeaderView.h"

#import "NZHAPIClient.h"

@interface NZHCategoryViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *articles;
@property (strong, nonatomic) NZHCategoryHeaderView *headerView;
@property (strong, nonatomic) NZHClassification *classification;

@end

@implementation NZHCategoryViewController

- (id)initWithClassification:(NZHClassification *)classification
{
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.view.backgroundColor = [UIColor blackColor];
        
        self.classification = classification;
        
        // viewDidLoad has already been called at this point. Something random with subclassing UIPageViewController I presume.
        self.headerView.title = classification.name;
        
        DLog(@"Loading cID: %@", @(classification.classificationId));
        
        [[NZHAPIClient shared] fetchArticlesForClassificationId:classification.classificationId withCompletion:^(NSError *error, NSArray *articles) {
            
            if (!error) {
                
                if ([articles count]) {
                    self.articles = articles;
                    NZHArticleViewController *articleViewController = [self viewControllerAtIndex:0];
                    NSArray *viewControllers = @[articleViewController];
                    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                }
            }
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show a loading thing?
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapClose)];
    
    self.headerView = [[NZHCategoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    self.headerView.title = self.classification.name;
    [self.headerView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.headerView];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Actions

- (void)didTapClose
{
    if ([self.categoryViewControllerDelegate respondsToSelector:@selector(categoryViewControllerRequestsDismissal:)]) {
        [self.categoryViewControllerDelegate categoryViewControllerRequestsDismissal:self];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NZHArticleViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NZHArticleViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.articles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NZHArticleViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ([self.articles count] == 0) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    NZHArticleViewController *articleViewController = [[NZHArticleViewController alloc] initWithArticle:self.articles[index]];
    articleViewController.pageIndex = index;
    return articleViewController;
}

@end
