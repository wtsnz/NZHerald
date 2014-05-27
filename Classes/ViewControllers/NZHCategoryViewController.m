//
//  NZHCategoryViewController.m
//  NZ Herald 2
//
//  Created by Will Townsend on 25/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import "NZHCategoryViewController.h"

#import "NZHArticleViewController.h"
#import "NZHArticle.h"

@interface NZHCategoryViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *articles;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation NZHCategoryViewController

- (id)init
{
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil]) {
        
        
        NSURL *imageUrl = [NSURL URLWithString:@"http://rss.nzherald.co.nz/touch/?version=2.2&method=stories.getLatest&cId=698&maxrows=35&fullContent=1&appID=41&apiKey=41:1401105000:1631861A2A8F57DB49E56A6DBD37D06B40F58501"];
        //imageUrl = [NSURL URLWithString:@"http://rss.nzherald.co.nz/touch/?version=2.2&method=stories.getLatest&cId=1&maxrows=35&fullContent=1&appID=41&apiKey=41:1401105000:1631861A2A8F57DB49E56A6DBD37D06B40F58501"];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            DLog(@"%@", [responseObject class]);
            
            NSArray *articles = [MTLJSONAdapter modelsOfClass:NZHArticle.class fromJSONArray:responseObject error:nil];

            self.articles = articles;
            
            NZHArticleViewController *articleViewController = [self viewControllerAtIndex:0];
            NSArray *viewControllers = @[articleViewController];
            [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        
        [requestOperation start];
        
        self.delegate = self;
        self.dataSource = self;
        self.view.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show a loading thing
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    self.headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:self.headerView];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
