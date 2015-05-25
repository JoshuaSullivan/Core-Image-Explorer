//
//  AppDelegate.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/13/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "AppDelegate.h"
#import "SampleImageManager.h"
#import "AppConstants.h"

static NSString * const kFilterDataVersionKey = @"filterDataVersion";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[SampleImageManager sharedManager] createSamplesIfNeeded];
//    [self resetFilterData];
    [self createFilterData];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Filter Data Creation

- (void)resetFilterData
{
    NSLog(@"Deleting filter data.");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFilterDataVersionKey];
    [[NSFileManager defaultManager] removeItemAtURL:[AppConstants filterDataURL] error:nil];
}

- (void)createFilterData
{
    NSString *previousDataVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterDataVersionKey];
    NSString *currentSystemVersion = [UIDevice currentDevice].systemVersion;
    if (previousDataVersion && [previousDataVersion isEqualToString:currentSystemVersion]) {
        // No need to update the data.
        NSLog(@"Filter data version strings match. No update required.");
        return;
    }
    NSLog(@"Creating filter data.");
//    NSArray *exclusionList = @[@"CIColorCube", @"CIMaskToAlpha", @"CICrop"];
    NSArray *exclusionList = @[];

    NSArray *allFilterNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSMutableArray *categories = [NSMutableArray array];
    NSMutableDictionary *filterMap = [NSMutableDictionary dictionary];
    NSMutableArray *allFilters = [NSMutableArray arrayWithCapacity:allFilterNames.count];

    for (NSString *name in allFilterNames) {
        if ([exclusionList containsObject:name]) {
            continue;
        }
        CIFilter *filter = [CIFilter filterWithName:name];
        NSString *displayName = filter.attributes[kCIAttributeFilterDisplayName];
        NSDictionary *filterDescriptor = @{
                kCIAttributeFilterName : name,
                kCIAttributeFilterDisplayName : displayName
        };
        [allFilters addObject:filterDescriptor];

        NSArray *filterCategories = filter.attributes[kCIAttributeFilterCategories];
        for (NSString *categoryName in filterCategories) {
            if (![categories containsObject:categoryName]) {
                [categories addObject:categoryName];
            }

            if (!filterMap[categoryName]) {
                filterMap[categoryName] = [NSMutableArray array];
            }

            [((NSMutableArray *)filterMap[categoryName]) addObject:filterDescriptor];
        }
    }

    [categories removeObject:kCICategoryBuiltIn];
    [filterMap removeObjectForKey:kCICategoryBuiltIn];

    NSDictionary *filterData = @{
            FilterDataSections.allFilters : [NSArray arrayWithArray:allFilters],
            FilterDataSections.allCategories : [NSArray arrayWithArray:categories],
            FilterDataSections.filterMap : [NSDictionary dictionaryWithDictionary:filterMap]
    };
    BOOL success = [filterData writeToURL:[AppConstants filterDataURL] atomically:NO];
    NSAssert(success, @"ERROR: Unable to write filter data.");

    [[NSUserDefaults standardUserDefaults] setObject:currentSystemVersion forKey:kFilterDataVersionKey];
}

- (NSString *)enumerateFilter:(CIFilter *)filter
{
    NSDictionary *attributes = filter.attributes;
    NSString *enumString = [NSString stringWithFormat:@"%@ {\n%@}\n", attributes[kCIAttributeFilterName], [self recursivelyDescribeDictionary:attributes
                                                                                                                                 currentDepth:1]];
//    NSLog(@"%@ outputs: %@", attributes[kCIAttributeFilterName],[filter outputKeys]);
    return enumString;
}

- (NSString *)recursivelyDescribeDictionary:(NSDictionary *)dict currentDepth:(NSInteger)depth
{
    NSMutableString *dictString = [NSMutableString string];
    NSString *prefix = @"";
    for (NSInteger i = 0; i < depth; i++) {
        prefix = [prefix stringByAppendingString:@"\t"];
    }
    NSArray *allKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in allKeys) {
        id value = dict[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *dictEnum = [self recursivelyDescribeDictionary:value currentDepth:depth + 1];
            [dictString appendFormat:@"%@%@ : {\n%@%@}\n", prefix, key, dictEnum, prefix];
        } else if ([value isKindOfClass:[NSArray class]]) {
            [dictString appendFormat:@"%@%@ : [%@]\n", prefix, key, [(NSArray *)value componentsJoinedByString:@", "]];
        } else {
            [dictString appendFormat:@"%@%@ : %@\n", prefix, key, value];
        }
        if ([key rangeOfString:@"Image"].location != NSNotFound) {
            NSLog(@"image key: %@", key);
        }
    }
    return [NSString stringWithString:dictString];
}

@end
