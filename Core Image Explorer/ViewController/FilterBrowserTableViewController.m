//
//  FilterBrowserTableViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/13/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "FilterBrowserTableViewController.h"
#import "FilterDetailViewController.h"
#import "AppConstants.h"

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

    NSDictionary *filterData = [NSDictionary dictionaryWithContentsOfURL:[AppConstants filterDataURL]];
    self.categories = filterData[FilterDataSections.allCategories];
    self.filterMap = filterData[FilterDataSections.filterMap];
    self.allFilters = filterData[FilterDataSections.allFilters];

    self.tableModeButton.title = kAlphabeticalButtonLabel;
    self.tableMode = TableDisplayModeAlphabetical;
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
    NSDictionary *filterDescriptor;

    if (self.tableMode == TableDisplayModeAlphabetical) {
        filterDescriptor = self.allFilters[indexPath.row];
    } else {
        NSString *category = self.categories[indexPath.section];
        filterDescriptor = ((NSArray *)self.filterMap[category])[indexPath.row];
    }

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    cell.textLabel.text = filterDescriptor[kCIAttributeFilterDisplayName];
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

        NSDictionary * filterDescriptor;
        if (self.tableMode == TableDisplayModeAlphabetical) {
            filterDescriptor = self.allFilters[indexPath.row];
        } else {
            NSString *category = self.categories[indexPath.section];
            filterDescriptor = ((NSArray *)self.filterMap[category])[indexPath.row];
        }

        FilterDetailViewController *detailVC = (FilterDetailViewController *)segue.destinationViewController;
        detailVC.filterDescriptor = filterDescriptor;
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



@end
