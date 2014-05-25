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
        
        NZHArticle *article = [NZHArticle new];
        article.headline = @"Woman's disappearance baffles police";
        //article.imageUrl = @"http://media.nzherald.co.nz/webcontent/image/jpg/201422/260514NZHRGRCOP16_320x320.jpg";
        article.introText = @"Appeals for information surrounding the disappearance of a missing Auckland mother-of-two are continuing, 24 hours after she was due home.";
        article.content = @"Appeals for information surrounding the disappearance of a missing Auckland mother-of-two are continuing, 24 hours after she was due home.<br /><br />Blesilda Gotingco, known as Blessie, was last heard from at 6.21pm on Saturday when she spoke to her adult son to say she would be leaving her job at Tower Insurance in Auckland's CBD about 7pm to catch a bus home.<br /><br />Her son then went to work, and Mrs Gotingco's adult daughter, who works late shifts, arrived home about 3.15am to find her mother was not home as expected.<br /><br />She contacted her two brothers and they notified police around 3.30am.<br /><br />Waitemata police Detective Senior Sergeant Stan Brown today said police had serious concerns for Mrs Gotingco, 56.<br /><br />He said her daughter tracked Mrs Gotingco's mobile phone via its inbuilt locater system, and found it was polling a short distance from their home on Salisbury Rd, Birkdale.<br /><br />She went along the road where she found it, along with some more of her mother's personal items, and immediately notified police about 5.40am.<br /><br />\"We obviously want to hear of any sightings of Blessie since 7pm last evening,\" Mr Brown said.<br /><br />She is of medium to slim build, about 5'3\" tall and has dark shoulder-length hair. She was last seen wearing a white top and and light coloured trousers.\"<br /><br />The circumstances of Mrs Gotingco's disappearance and the location of some of her belongings gave rise to serious concerns for her safety, Mr Brown said.<br /><br />Residents near the cordoned scene had been asked to search their properties for anything that may have been out of place.<br /><br />3 News reported a neighbour saying she heard loud and frightened screams about 8pm, followed by the sound of a loud \"low-slung\" car driving away.<br /><br />Mr Brown said it was unknown what had happened to Mrs Gotingco after she got off the bus.<br /><br />\"We actually don't know what happened after that. Blessie was a family woman and she was reported missing by one of her adult children who she lives with.<br /><br />\"They're very concerned about what's happening with Blessie at the moment.\"<br /><br />Mrs Gotingco's personal belongings, including her shoes were later found in disarray, Mr Brown said.<br /><br />\"It actually may have been a tragic accident. She may have have been knocked down by a motorist going too fast.<br /><br />\"There could be a car somewhere in a carport or in a car shed, or something more sinister ... we don't know,\" Mr Brown said.<br /><br />\"We'd like people that have information to please come forward to the police.<br /><br />\"She could be laying injured somewhere, she may need the help of that phone call.\"<br /><br />Police were considering whether Mrs Gotingco had crawled away somewhere or was lying injured under a house, \"versus the worst-case scenario -- someone removed her in a vehicle, which is also a possibility.\"<br /><br />Mrs Gotingco's children were \"distraught\" and were being supported by Victim Support, Mr Brown said. \"They are beside themselves to say the least.\"<br /><br />Mr Brown appealed for anyone with information regarding Mrs Gotingco to contact Waitemata CIB on 09 213 7890 [must dial the 09].<br /><br />Anonymous information can go to Crimestoppers on 0800 555 111.";
        
        NZHArticle *article2 = [NZHArticle new];
        article2.headline = @"No respite from gloomy weather";
        //article2.imageUrl = @"http://media.nzherald.co.nz/webcontent/image/jpg/201422/Weather_1024x768_320x320.jpg";
        article2.introText = @"About 4500 properties across the lower North Island have lost power due to the severe weather this weekend, and gale-force winds are expected to continue this evening.";
        article2.content = @"<i><strong>are you being affected by the terrible weather? Contact the Herald with your stories and photos <a href=\"mailto:newsdesk@nzherald.co.nz\">here</a>.</strong></i></P><br /><br />About 4500 properties across the lower North Island have lost power due to the severe weather this weekend, and gale-force winds are expected to continue this evening.<br /><br />Powerco Acting Network Operations Manager Dean Stevenson said 400 customers remained without power in Tararua and Wairarapa.<br /><br />Field crews are working to restore power in a safe and timely manner, he said.<br /><br />\"We are expecting supply to be restored to the majority of customers by tonight. However, severe weather is forecast later today, so there could be more power cuts.\"<br /><br />He said strong winds had made it too dangerous for field staff to work on parts of the network in Tararua yesterday.<br /><br />Remote areas in Wairarapa were proving difficult to access today, delaying restoration efforts for a small number of customers.<br /><br />\"These properties face having no power overnight. We're doing all we can to restore supply, and additional crews are helping repair the network damage.\"<br /><br />He warned there had been several incidents of power lines falling to the ground.<br /><br />MetService meteorologist Elke Louw said winds gusting up to 120km/h could be expected today in Wellington, Wairarapa and Hawke's Bay south of Napier.<br /><br />Meanwhile, a significant cold outbreak advisory has been issued for Dunedin, Southland and Clutha and heavy snow is expected to fall, she said.<br /><br />Power has been restored to Outram, Otago this morning after residents were left in the cold and dark overnight following an outage in the township caused by yesterday's wild weather.<br /><br />While many areas in the south experienced outages yesterday, Outram and Waldronville were among the hardest hit.<br /><br />Clutha and Dunedin will have snowfall to 200 metres and 300 metres today, while in Southland snow could fall to sea level.<br /><br />Along with the snow fall, gale force winds are expected in the south.<br /><br />\"With that cold air and the strong winds there's going to be quite a serious wind-chill factor,\" Ms Louw said.<br /><br />The severe weather will be felt in the West Coast, where a heavy rain warning has been issued.<br /><br />\"This could have a serious affect on rivers in the Westland ranges north of Haast Pass,\" she said.<br /><br />MetService urged people to take care around rivers that could rapidly rise with the heavy rain.<br /><br /><strong><i><a href='http://m.nzherald.co.nz/national/news/video.cfm?c_id=1503075&gal_cid=1503075&gallery_id=143225' target='_blank'>Watch: Car 'airborne' after hitting fallen tree</a></i></strong><br /><nzh-inline-video id=\"143225\" position=\"center\" media-id=\"15279481\" /><br /><br />Weather forecast for main centres:<br /><br />* Auckland: A few showers can be overnight. Westerly winds turn southerly, bringing cool winds and a crisp high of 17C tomorrow <br /><br />* Hamilton: Westerlies turn fresh southwesterlies overnight and tomorrow, bringing a chance of showers tomorrow morning and a high of 15C.<br /><br />* Wellington: Severe and gusty northwesterlies will ease overnight and turn fresh southwesterlies with a high 14C tomorrow.<br /><br />* Christchurch: Northwesterly gales and rain continue overnight but winds turn southwesterly and rain will ease after morning showers. Snow in the high country. Winds will be strong and cold tomorrow, with a high of 8C.<br /><br />* Dunedin: Sleety showers and gales expected through the night and into tomorrow. Gusts of up to 120km/h and rain expected tomorrow. Snow to 300m overnight. High of 7C tomorrow.";
        
        
        NSURL *imageUrl = [NSURL URLWithString:@"http://rss.nzherald.co.nz/touch/?version=2.2&method=stories.getLatest&cId=698&maxrows=35&fullContent=1&appID=41&apiKey=41:1401105000:1631861A2A8F57DB49E56A6DBD37D06B40F58501"];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"Response: %@", responseObject);
            
            NSArray *articles = [MTLJSONAdapter modelsOfClass:NZHArticle.class fromJSONArray:responseObject error:nil];

            self.articles = articles;
            
            NZHArticleViewController *articleViewController = [self viewControllerAtIndex:0];
            NSArray *viewControllers = @[articleViewController];
            [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            //NSLog(@"%@", self.articles);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
        
        //self.articles = @[article, article2];
        self.delegate = self;
        self.dataSource = self;
        
        self.view.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NZHArticleViewController *articleViewController = [self viewControllerAtIndex:0];
    //NSArray *viewControllers = @[articleViewController];
    //[self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    // Do any additional setup after loading the view.
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    self.headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:self.headerView];
    
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
