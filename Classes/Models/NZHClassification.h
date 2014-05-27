//
//  NZHClassification.h
//  NZ Herald
//
//  Created by Will Townsend on 27/05/14.
//  Copyright (c) 2014 WTSNZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZHClassification : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSInteger classificationId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;

@end
