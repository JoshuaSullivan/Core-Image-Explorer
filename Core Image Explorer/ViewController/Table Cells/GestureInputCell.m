//
//  GestureInputCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/24/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "GestureInputCell.h"

@implementation GestureInputCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gestures = [NSMutableArray array];
    self.borderColor = [UIColor blueColor];
}

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary
                  startingValue:value
                   andInputName:inputName];
    
    self.inputPromptLabel.hidden = YES;
    self.isActive = NO;
    [self updateValueLabel];
}

- (void)updateValueLabel
{
    self.inputValueLabel.text = [NSString stringWithFormat:@"%@", self.value];
}

- (void)deactivate
{
    for (UIGestureRecognizer *gesture in self.gestures) {
        [gesture.view removeGestureRecognizer:gesture];
    }
}

#pragma mark - IBActions
- (IBAction)activateButtonTapped:(id)sender
{
    self.isActive = !self.isActive;
}

#pragma mark - Data accessors
- (void)setIsActive:(BOOL)isActive
{
    _isActive = isActive;
    self.activateButton.selected = _isActive;
    
    if (_isActive) {
        [self.gestureDelegate gestureInput:self addGesturesToImageView:self.gestures withBorderColor:self.borderColor];
    } else {
        [self.gestureDelegate gestureInputDidDeactivate:self];
    }
    
    self.activateButton.selected = _isActive;
    self.inputPromptLabel.hidden = !_isActive;
}


@end
