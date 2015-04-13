//
// Created by Joshua Sullivan on 4/11/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import UIKit;
#import "FilterConfigurationControl.h"

@interface BaseConfigurationViewController : UIViewController <FilterConfigurationControl>

@property (readonly, nonatomic) CIFilter *filter;

@property (weak, nonatomic) id <FilterConfigurationDelegate> filterConfigurationDelegate;

/**
* Child classes which override this method should invoke super or the filter will not be available.
*/
- (void)configureInputKey:(NSString *)key forFilter:(CIFilter *)filter;

/**
* Determines if the control is suitable for the input it is supposed to configure.
*
* Child classes must override this method and not invoke the super implementation.
*/
- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary;

@end
