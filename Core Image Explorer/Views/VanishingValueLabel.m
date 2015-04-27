//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "VanishingValueLabel.h"
@import QuartzCore;

static const NSTimeInterval kDefaultAppearanceDuration = 1.0;

@interface VanishingValueLabel ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation VanishingValueLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = labelFont;
    _titleLabel.textColor = self.tintColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _valueLabel.font = [labelFont fontWithSize:24.0f];
    _valueLabel.textColor = self.tintColor;
    _valueLabel.textAlignment = NSTextAlignmentCenter;

    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_titleLabel, _valueLabel);
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleLabel(20)-0-valueLabel-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDict];
    NSArray *titleHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabel-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDict];
    NSArray *valueHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-valueLabel-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDict];
    NSArray *allConstraints = [[verticalConstraints arrayByAddingObjectsFromArray:titleHorizontalConstraints] arrayByAddingObjectsFromArray:valueHorizontalConstraints];
    [self addConstraints:allConstraints];
    [self commonInit];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    _appearanceDuration = kDefaultAppearanceDuration;
    self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    self.layer.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
}

- (void)appear
{
    self.titleLabel.textColor = self.tintColor;
    self.valueLabel.textColor = self.tintColor;

    self.hidden = NO;
    self.alpha = 1.0f;
    [self.layer removeAllAnimations];

    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.appearanceDuration
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)vanish
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)timerFired:(NSTimer *)timer
{
    [self vanish];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self appear];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.valueLabel.text = value;
    [self appear];
}


@end