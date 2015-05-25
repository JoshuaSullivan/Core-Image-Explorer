//
// Created by Joshua Sullivan on 5/25/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "AppConstants.h"

NSString *kFilterDataFileName = @"FilterData.plist";

const struct FilterDataSections FilterDataSections = {
        .allCategories = @"allCategories",
        .allFilters = @"allFilters",
        .filterMap = @"filterMap",
};

@implementation AppConstants

+ (NSURL *)filterDataURL
{
    NSURL *documentDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                      inDomains:NSUserDomainMask][0];
    NSURL *fileURL = [documentDirectory URLByAppendingPathComponent:kFilterDataFileName];
    return fileURL;
}


@end