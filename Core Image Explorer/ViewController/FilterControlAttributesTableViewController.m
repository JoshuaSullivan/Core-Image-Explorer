//
//  FilterControlAttributesTableViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/13/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "FilterControlAttributesTableViewController.h"
#import "BaseConfigurationViewController.h"

// Cell Identifiers
static NSString * const kDefaultCellIdentifier = @"kDefaultCellIdentifier";

// Segue Identifiers
static NSString * const kScalarInputSegueIdentifier = @"kScalarInputSegueIdentifier";

@interface FilterControlAttributesTableViewController ()

@property (strong, nonatomic) NSString *inputKeyToConfigure;

@end

@implementation FilterControlAttributesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.filter.attributes[kCIAttributeDisplayName];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filter ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filter.inputKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *key = self.filter.inputKeys[(NSUInteger)indexPath.row];
    NSDictionary *attributeDict = self.filter.attributes[key];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = key;
    BOOL isScalar = [attributeDict[kCIAttributeType] isEqualToString:kCIAttributeTypeScalar];
    cell.detailTextLabel.text = isScalar ? @"Scalar" : @"Not Scalar";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *inputKey = self.filter.inputKeys[(NSUInteger)indexPath.row];
    self.inputKeyToConfigure = inputKey;
    NSDictionary *attributeDict = self.filter.attributes[inputKey];
    if ([attributeDict[kCIAttributeType] isEqualToString:kCIAttributeTypeScalar]) {
        [self performSegueWithIdentifier:kScalarInputSegueIdentifier sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BaseConfigurationViewController *configVC = segue.destinationViewController;
    configVC.filter = self.filter;
    configVC.inputKeyToConfigure = self.inputKeyToConfigure;
    if ([segue.identifier isEqualToString:kScalarInputSegueIdentifier]) {
        // Reserved for control-specific configuraton.
    }
}

#pragma mark - Helpers


@end
