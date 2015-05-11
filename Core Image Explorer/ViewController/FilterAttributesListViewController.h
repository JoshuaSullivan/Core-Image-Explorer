//
//  FilterAttributesListViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/13/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterAttributeListDelegate;

@interface FilterAttributesListViewController : UITableViewController

@property (strong, nonatomic) CIFilter *filter;
@property (weak, nonatomic) id <FilterAttributeListDelegate> attributeListDelegate;

- (CGFloat)contentHeight;

@end

@protocol FilterAttributeListDelegate <NSObject>

- (void)filterAttributesList:(FilterAttributesListViewController *)attributeListVC didSelectInput:(NSString *)input;

@end
