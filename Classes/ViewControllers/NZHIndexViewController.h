//
//  NZHIndexViewController.h
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NZHIndexViewController;
@class NZHClassification;

@protocol NZHIndexViewControllerDelegate <NSObject>

- (void)indexViewController:(NZHIndexViewController *)indexViewController didSelectClassification:(NZHClassification *)classification;

@end

@interface NZHIndexViewController : UIViewController

@property (weak, nonatomic) id <NZHIndexViewControllerDelegate> delegate;

@end
