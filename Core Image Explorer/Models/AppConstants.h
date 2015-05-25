//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct FilterDataSections {
    __unsafe_unretained NSString *allFilters;
    __unsafe_unretained NSString *allCategories;
    __unsafe_unretained NSString *filterMap;
} FilterDataSections;

@interface AppConstants : NSObject

+ (NSURL *)filterDataURL;

@end