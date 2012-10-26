//
//  GestureInputCell.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/24/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "BaseInputControlCell.h"

@class GestureInputCell;

@protocol GestureInputDelegate <NSObject>

@required
- (void)gestureInput:(GestureInputCell *)gestureInput addGesturesToImageView:(NSArray *)gestures withBorderColor:(UIColor *)borderColor;
- (void)gestureInputDidDeactivate:(GestureInputCell *)gestureInput;

@end

@interface GestureInputCell : BaseInputControlCell

@property (weak, nonatomic) IBOutlet UILabel *inputValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputPromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *activateButton;

@property (assign, nonatomic) BOOL isActive;

@property (strong, nonatomic) NSMutableArray *gestures;
@property (strong, nonatomic) UIColor *borderColor;

@property (weak, nonatomic) id <GestureInputDelegate> gestureDelegate;

- (void)updateValueLabel;
- (void)deactivate;

- (IBAction)activateButtonTapped:(id)sender;

@end
