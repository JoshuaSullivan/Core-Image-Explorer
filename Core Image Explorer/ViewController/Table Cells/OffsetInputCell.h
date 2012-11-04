//
//  OffsetInputCell.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 11/3/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "BaseInputControlCell.h"

@interface OffsetInputCell : BaseInputControlCell

- (void)setSliderRangeMinX:(CGFloat)minX maxX:(CGFloat)maxX minY:(CGFloat)minY maxY:(CGFloat)maxY;

- (IBAction)sliderValueChanged:(id)sender;

@end
