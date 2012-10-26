//
//  AffineTransformCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/24/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "AffineTransformCell.h"

@interface AffineTransformCell ()

@property (assign, nonatomic) CGFloat rotation;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGPoint translation;

@end

@implementation AffineTransformCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGAffineTransform startingTransform = ((NSValue *)self.value).CGAffineTransformValue;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(imageWasPinched:)];
    pinchRecognizer.scale = startingTransform.a;
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(imageWasRotated:)];
    rotationRecognizer.rotation = startingTransform.b;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(imageWasDragged:)];
    [self.gestures addObject:pinchRecognizer];
    [self.gestures addObject:rotationRecognizer];
    [self.gestures addObject:panRecognizer];
    
    self.rotation = 0.0;
    self.scale = 1.0;
    self.translation = CGPointZero;
    
    self.borderColor = [UIColor greenColor];
}

- (void)updateValueLabel
{
    CGAffineTransform transform = ((NSValue *)self.value).CGAffineTransformValue;
    self.inputValueLabel.text = [NSString stringWithFormat:@"%@", NSStringFromCGAffineTransform(transform)];
}

#pragma mark - Gesture callbacks

- (void)imageWasPinched:(UIPinchGestureRecognizer *)sender
{
    self.scale = sender.scale;
    [self updateTransformValue];
}

- (void)imageWasRotated:(UIRotationGestureRecognizer *)sender
{
    self.rotation = sender.rotation;
    [self updateTransformValue];
}

- (void)imageWasDragged:(UIPanGestureRecognizer *)sender
{
    self.translation = [sender translationInView:sender.view];
    [self updateTransformValue];
}

#pragma mark - Update the value
- (void)updateTransformValue
{
    CGAffineTransform sTransform = CGAffineTransformMakeScale(self.scale, self.scale);
    CGAffineTransform rTransform = CGAffineTransformMakeRotation(-self.rotation);
    CGAffineTransform tTransform = CGAffineTransformMakeTranslation(self.translation.x, -self.translation.y);
    CGAffineTransform transform = CGAffineTransformConcat(sTransform, CGAffineTransformConcat(rTransform, tTransform));
    
    self.value = [NSValue valueWithCGAffineTransform:transform];
    [self updateValueLabel];
    [self.delegate inputControlCellValueDidChange:self];
}

@end
