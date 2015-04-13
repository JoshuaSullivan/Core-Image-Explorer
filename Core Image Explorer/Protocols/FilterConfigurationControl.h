//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIFilter;
@protocol FilterConfigurationDelegate;

@protocol FilterConfigurationControl <NSObject>

@property (weak, nonatomic) id <FilterConfigurationDelegate> filterConfigurationDelegate;

- (void)configureInputKey:(NSString *)key forFilter:(CIFilter *)filter;

@end

@protocol FilterConfigurationDelegate <NSObject>

- (void)filterConfigurationControl:(id <FilterConfigurationControl>)control didModifyFilter:(CIFilter *)filter;

@end
