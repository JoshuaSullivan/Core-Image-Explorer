//
// Created by Joshua Sullivan on 4/21/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "VanishingValueLabel.h"

static const NSTimeInterval kDefaultAppearanceDuration = 1.0;

@interface VanishingValueLabel ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@property (strong, nonatomic)

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
}

- (void)appear
{

}

- (void)vanish
{

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