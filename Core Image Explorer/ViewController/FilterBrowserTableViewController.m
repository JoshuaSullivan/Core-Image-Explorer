//
//  FilterBrowserTableViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/13/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "FilterBrowserTableViewController.h"
#import "OldFilterControlsViewController.h"
#import "FilterDetailViewController.h"

typedef enum {
    TableDisplayModeAlphabetical,
    TableDisplayModeGroupedByType
} TableDisplayMode;

static NSString * const kAlphabeticalButtonLabel = @"A→Z";
static NSString * const kCategoryButtonLabel = @"Category";

static NSString * const kBrowserToDetailSegueIdentifier = @"kBrowserToDetailSegueIdentifier";

@interface FilterBrowserTableViewController ()

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSDictionary *filterMap;
@property (strong, nonatomic) NSArray *allFilters;

@property (assign, nonatomic) TableDisplayMode tableMode;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *tableModeButton;

@end

@implementation FilterBrowserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    [self createFilterData];

    self.tableModeButton.title = kAlphabeticalButtonLabel;
    self.tableMode = TableDisplayModeAlphabetical;
}

- (void)createFilterData
{
//    NSArray *exclusionList = @[@"CIColorCube", @"CIMaskToAlpha", @"CICrop"];
    NSArray *exclusionList = @[];

    NSArray *allFilterNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSMutableArray *categories = [NSMutableArray array];
    NSMutableDictionary *filterMap = [NSMutableDictionary dictionary];
    NSMutableArray *allFilters = [NSMutableArray arrayWithCapacity:allFilterNames.count];

//    NSMutableString *outString = [NSMutableString string];

    for (NSString *name in allFilterNames) {
        if ([exclusionList containsObject:name]) {
            continue;
        }
        CIFilter *filter = [CIFilter filterWithName:name];
        [allFilters addObject:filter];
//        [outString appendFormat:@"%@\n\n", [self enumerateFilter:filter]];

        NSArray *filterCategories = filter.attributes[kCIAttributeFilterCategories];
        for (NSString *categoryName in filterCategories) {
            if (![categories containsObject:categoryName]) {
                [categories addObject:categoryName];
            }

            if (!filterMap[categoryName]) {
                filterMap[categoryName] = [NSMutableArray array];
            }

            [((NSMutableArray *)filterMap[categoryName]) addObject:filter];
        }
    }

    [categories removeObject:kCICategoryBuiltIn];
    [filterMap removeObjectForKey:kCICategoryBuiltIn];

    self.allFilters = [NSArray arrayWithArray:allFilters];
    self.filterMap = [NSDictionary dictionaryWithDictionary:filterMap];
    self.categories = [NSArray arrayWithArray:categories];

//    NSLog(@"Filter enumerations:\n\n%@", outString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count;
    if (self.tableMode == TableDisplayModeAlphabetical) {
        count = 1;
    } else {
        count = self.categories.count;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (self.tableMode == TableDisplayModeAlphabetical) {
        count = self.allFilters.count;
    } else {
        NSString *category = self.categories[(NSUInteger)section];
        count = ((NSMutableArray *)self.filterMap[category]).count;
    }

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"FilterCell";
    CIFilter *filter;

    if (self.tableMode == TableDisplayModeAlphabetical) {
        filter = self.allFilters[indexPath.row];
    } else {
        NSString *category = self.categories[indexPath.section];
        filter = ((NSArray *)self.filterMap[category])[indexPath.row];
    }

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    cell.textLabel.text = filter.attributes[kCIAttributeFilterDisplayName];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.tableMode == TableDisplayModeGroupedByType){
        return self.categories[section];
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kBrowserToDetailSegueIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        CIFilter * filter;
        if (self.tableMode == TableDisplayModeAlphabetical) {
            filter = self.allFilters[indexPath.row];
        } else {
            NSString *category = self.categories[indexPath.section];
            filter = ((NSArray *)self.filterMap[category])[indexPath.row];
        }

        FilterDetailViewController *detailVC = (FilterDetailViewController *)segue.destinationViewController;
        detailVC.filter = filter;
    }

}

#pragma mark - IBActions
- (IBAction)tableModeButtonTapped:(id)sender
{
    switch (self.tableMode) {
        case TableDisplayModeAlphabetical:
            self.tableMode = TableDisplayModeGroupedByType;
            self.tableModeButton.title = kCategoryButtonLabel;
            break;
        case TableDisplayModeGroupedByType:
            self.tableMode = TableDisplayModeAlphabetical;
            self.tableModeButton.title = kAlphabeticalButtonLabel;
            break;
    }
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

// Unwind segue
-(IBAction)returned:(UIStoryboardSegue *)segue {
    // Reserved for future post-info actions, I guess.
}

#pragma mark - Helper Methods

- (NSString *)enumerateFilter:(CIFilter *)filter
{
    NSDictionary *attributes = filter.attributes;
    NSString *enumString = [NSString stringWithFormat:@"%@ {\n%@}\n", attributes[kCIAttributeFilterName], [self recursivelyDescribeDictionary:attributes
                                                                                                                                 currentDepth:1]];
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
    }
    return [NSString stringWithString:dictString];
}

@end
