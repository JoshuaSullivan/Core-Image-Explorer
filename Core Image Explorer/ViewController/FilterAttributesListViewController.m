//
//  FilterAttributesListViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/13/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "FilterAttributesListViewController.h"
#import "BaseConfigurationViewController.h"
#import "MinimalistInputViewController.h"
#import "MinimalistInputDescriptor.h"

// Cell Identifiers
static NSString * const kDefaultCellIdentifier = @"kDefaultCellIdentifier";

@interface FilterAttributesListViewController ()


@end

@implementation FilterAttributesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.filter.attributes[kCIAttributeDisplayName];
}

- (CGFloat)contentHeight
{
    return self.filter.inputKeys.count * 60.0f;
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
    [self.attributeListDelegate filterAttributesList:self didSelectInput:inputKey];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
