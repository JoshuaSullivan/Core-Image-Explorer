//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIFilter;
@protocol FilterConfigurationDelegate;

@protocol FilterConfigurationControl <NSObject>

/** The delegate for FilterConfigurationDelegate messaging. */
@property (weak, nonatomic) id <FilterConfigurationDelegate> filterConfigurationDelegate;

/** The filter to be configured. */
@property (strong, nonatomic) CIFilter *filter;

/** The specific input key on the filter to configure. */
@property (strong, nonatomic) NSString *inputKeyToConfigure;

@property (readonly, nonatomic) CGSize controlSize;

@end

@protocol FilterConfigurationDelegate <NSObject>

- (void)filterConfigurationControl:(id <FilterConfigurationControl>)control didModifyFilter:(CIFilter *)filter;

@end
