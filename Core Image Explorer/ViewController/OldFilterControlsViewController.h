//
//  FilterTestViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/13/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInputControlCell.h"
#import "GestureInputCell.h"
#import "PhotoPickerCell.h"

@interface OldFilterControlsViewController : UIViewController <UITableViewDataSource,
                                                          UITableViewDelegate,
                                                          InputCellDelegate,
                                                          GestureInputDelegate,
                                                          PhotoPickerDelegate>
/*!
 @abstract The filter to be manipulated.
 */
@property (strong, nonatomic) CIFilter *filter;

/*!
 @abstract The shared context (maintained by FilterBrowserTableViewController)
 */
@property (strong, nonatomic) CIContext *ciContext;

@end
