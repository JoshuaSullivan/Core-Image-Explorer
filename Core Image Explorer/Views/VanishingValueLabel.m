//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "VanishingValueLabel.h"
@import QuartzCore;

static const NSTimeInterval kDefaultAppearanceDuration = 0.8;

@interface VanishingValueLabel ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation VanishingValueLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = labelFont;
    _titleLabel.textColor = self.tintColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30.0f];
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _valueLabel.font = [labelFont fontWithSize:24.0f];
    _valueLabel.textColor = self.tintColor;
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_valueLabel];

    NSDictionary *viewsDict = @{@"titleLabel":self.titleLabel, @"valueLabel":self.valueLabel};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[titleLabel(20)][valueLabel]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDict];
    NSArray *titleHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewsDict];
    NSArray *valueHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[valueLabel]-|"
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
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    self.layer.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
    self.hidden = YES;
}

- (void)appear
{
    self.titleLabel.textColor = self.tintColor;
    self.valueLabel.textColor = self.tintColor;

    self.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)vanish
{
    [UIView animateWithDuration:0.4 delay:0.6 options:0 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.valueLabel.text = value;
}


@end