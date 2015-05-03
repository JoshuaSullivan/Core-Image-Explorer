//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import UIKit;

@interface VanishingValueLabel : UIView

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *value;

- (void)appear;
- (void)vanish;

@end