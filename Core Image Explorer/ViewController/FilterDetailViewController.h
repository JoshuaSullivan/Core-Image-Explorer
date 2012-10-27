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

@interface FilterDetailViewController : UIViewController <UITableViewDataSource,
                                                          UITableViewDelegate,
                                                          InputCellDelegate,
                                                          GestureInputDelegate,
                                                          PhotoPickerDelegate>

@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) CIContext *ciContext;

@end
