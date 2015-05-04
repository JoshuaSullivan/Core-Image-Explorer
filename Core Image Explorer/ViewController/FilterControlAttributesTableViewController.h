//
//  FilterControlAttributesTableViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/13/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterControlAttributesTableViewController : UITableViewController

@property (strong, nonatomic) CIFilter *filter;

- (CGFloat)contentHeight;

@end
