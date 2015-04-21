//
//  MinimalistInputViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/21/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinimalistInputViewController : UIViewController

+ (MinimalistInputViewController *)minimalistControlForInputCount:(NSInteger)inputCount;

- (instancetype)initWithInputCount:(NSInteger)inputCount;

@end
