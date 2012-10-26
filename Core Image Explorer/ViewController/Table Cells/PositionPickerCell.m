//
//  PositionPickerCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/21/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "PositionPickerCell.h"

@interface PositionPickerCell ()

@end

@implementation PositionPickerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.gestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasTapped:)]];
}

- (void)updateValueLabel
{
    CIVector *position = (CIVector *)self.value;
    self.inputValueLabel.text = [NSString stringWithFormat:@"x:%.0f y:%.0f", position.X, position.Y];
}

#pragma mark - Tap gesture callback
- (void)imageWasTapped:(UITapGestureRecognizer *)sender
{
    CGPoint tapLoc = [sender locationInView:sender.view];
    CGFloat hRatio = tapLoc.x / sender.view.bounds.size.width;
    CGFloat vRatio = tapLoc.y / sender.view.bounds.size.height;
    CGSize imageSize = ((UIImageView *)sender.view).image.size;
    CIVector *position = [CIVector vectorWithCGPoint:CGPointMake(hRatio * imageSize.width, (1-vRatio) * imageSize.height)];
    self.value = position;
    [self updateValueLabel];
    [self.delegate inputControlCellValueDidChange:self];
}

@end
