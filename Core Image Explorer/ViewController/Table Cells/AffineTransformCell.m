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

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

@property (strong, nonatomic) IBOutlet UILabel *scaleValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *rotationValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *translationValueLabel;

@end

@implementation AffineTransformCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(imageWasPinched:)];
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(imageWasRotated:)];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(imageWasDragged:)];
    self.pinchRecognizer.delegate = self;
    self.rotationRecognizer.delegate = self;
    
    [self.gestures addObject:self.pinchRecognizer];
    [self.gestures addObject:self.rotationRecognizer];
    [self.gestures addObject:self.panRecognizer];
    
    self.rotation = 0.0;
    self.scale = 1.0;
    self.translation = CGPointZero;
    
    self.borderColor = [UIColor greenColor];
}

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary
                  startingValue:value
                   andInputName:inputName];
    
    CGAffineTransform startingTransform = ((NSValue *)self.value).CGAffineTransformValue;
    self.scale = startingTransform.a;
    self.rotation = startingTransform.b;
    self.translation = CGPointMake(startingTransform.tx, startingTransform.ty);
    [self updateValueLabel];
}

- (void)updateValueLabel
{
    self.scaleValueLabel.text = [NSString stringWithFormat:@"%0.2f", self.scale];
    self.rotationValueLabel.text = [NSString stringWithFormat:@"%0.2f", self.rotation];
    self.translationValueLabel.text = [NSString stringWithFormat:@"%0.1f, %0.1f", self.translation.x, self.translation.y];
}

#pragma mark - Gesture callbacks

- (void)imageWasPinched:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        sender.scale = self.scale;
    } else {
        self.scale = fmaxf(0.1, fminf(sender.scale, 2.0));
        [self updateTransformValue];
    }
}

- (void)imageWasRotated:(UIRotationGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        sender.rotation = self.rotation;
    } else {
        self.rotation = sender.rotation;
        [self updateTransformValue];
    }
}

- (void)imageWasDragged:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [sender setTranslation:self.translation inView:sender.view];
    } else {
        self.translation = [sender translationInView:sender.view];
        [self updateTransformValue];
    }
}

#pragma mark - IBAction
- (void)activateButtonTapped:(id)sender
{
    [super activateButtonTapped:sender];
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

#pragma mark - UIGestureRecognitionDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.pinchRecognizer && otherGestureRecognizer == self.rotationRecognizer) {
        return YES;
    } else if (gestureRecognizer == self.rotationRecognizer && otherGestureRecognizer == self.pinchRecognizer) {
        return YES;
    } else {
        return NO;
    }
}

@end
