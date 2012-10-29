//
//  SecondViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/13/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "FilterBrowserViewController.h"
#import "FilterDetailViewController.h"

typedef enum {
    TableDisplayModeAllFilters,
    TableDisplayModeGroupedByType
} TableDisplayMode;

@interface FilterBrowserViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableDictionary *filterMap;
@property (strong, nonatomic) NSMutableArray *allFilters;

@property (strong, nonatomic) EAGLContext *eaglContext;
@property (strong, nonatomic) CIContext *ciContext;

@property (assign, nonatomic) TableDisplayMode tableMode;

@property (strong, nonatomic) NSArray *exclusionList;

//@property (weak, nonatomic) IBOutle

@end

@implementation FilterBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.exclusionList = @[@"CIColorCube", @"CIMaskToAlpha", @"CICrop"];
    
    self.tableMode = self.modeControl.selectedSegmentIndex;
    
    NSArray *allFilters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSMutableArray *categories = [NSMutableArray array];
    self.filterMap = [NSMutableDictionary dictionary];
    self.allFilters = [NSMutableArray arrayWithCapacity:allFilters.count];
        
    for (NSString *name in allFilters) {
        if ([self isFilterExcluded:name]) continue;
        CIFilter *filter = [CIFilter filterWithName:name];
        [self.allFilters addObject:filter];
        
//        NSLog(@"%@\n%@", filter.name, filter.attributes);
        
        NSArray *filterCategories = filter.attributes[kCIAttributeFilterCategories];
        for (NSString *categoryName in filterCategories) {
            if (![categories containsObject:categoryName]) {
                [categories addObject:categoryName];
            }
                        
            if (!self.filterMap[categoryName]) {
                self.filterMap[categoryName] = [NSMutableArray array];
            }
            
            [((NSMutableArray *)self.filterMap[categoryName]) addObject:filter];
        }
    }
    
    [categories removeObject:kCICategoryBuiltIn];
    [self.filterMap removeObjectForKey:kCICategoryBuiltIn];
    
    self.categories = [NSArray arrayWithArray:categories];
    [self.tableView reloadData];
    
    self.eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.eaglContext) NSLog(@"No EAGL Context created");
    
    self.ciContext = [CIContext contextWithEAGLContext:self.eaglContext];

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
    if (self.tableMode == TableDisplayModeAllFilters) {
        count = 1;
    } else {
        count = self.categories.count;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (self.tableMode == TableDisplayModeAllFilters) {
        count = self.allFilters.count;
    } else {
        NSString *category = self.categories[section];
        count = ((NSMutableArray *)self.filterMap[category]).count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"FilterCell";
    CIFilter *filter;
    
    if (self.tableMode == TableDisplayModeAllFilters) {
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    CIFilter * filter;
    if (self.tableMode == TableDisplayModeAllFilters) {
        filter = self.allFilters[indexPath.row];
    } else {
        NSString *category = self.categories[indexPath.section];
        filter = ((NSArray *)self.filterMap[category])[indexPath.row];
    }
    
    FilterDetailViewController *detailVC = (FilterDetailViewController *)segue.destinationViewController;
    detailVC.filter = filter;
    detailVC.ciContext = self.ciContext;
}

#pragma mark - Check exclusion list for filter name
- (BOOL)isFilterExcluded:(NSString *)filterName
{
    for (NSString *excludedFilter in self.exclusionList) {
        if ([filterName isEqualToString:excludedFilter]) return YES;
    }
    return NO;
}

#pragma mark - IBActions
- (IBAction)tableModeControlValueChanged:(id)sender
{
    self.tableMode = ((UISegmentedControl *)sender).selectedSegmentIndex;
    [self.tableView reloadData];
}

@end
