//
// Created by Joshua Sullivan on 2/28/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "JTSEaseBounce.h"

@implementation JTSEaseBounce

+ (EasingCurve)easeIn
{
    static EasingCurve _easeIn;
    if (!_easeIn) {
        EasingCurve easeOut = [self easeOut];
        _easeIn = ^CGFloat(CGFloat ratio) {
            return 1 - easeOut(1 - ratio);
        };
    }
    return _easeIn;
}

+ (EasingCurve)easeOut
{
    static EasingCurve _easeOut;
    if (!_easeOut) {
        _easeOut = ^CGFloat(CGFloat ratio) {
            if (ratio < 4.0f / 11.0f) {
                return (121.0f * ratio * ratio) / 16.0f;
            }
            else if (ratio < 8.0f / 11.0) {
                return (363.0f / 40.0f * ratio * ratio) - (99.0f / 10.0f * ratio) + 17.0f / 5.0f;
            }
            else if (ratio < 9.0f / 10.0f) {
                return (4356.0f / 361.0f * ratio * ratio) - (35442.0f / 1805.0f * ratio) + 16061.0f / 1805.0f;
            }
            else {
                return (54.0f / 5.0f * ratio * ratio) - (513.0f / 25.0f * ratio) + 268.0f / 25.0f;
            }
        };
    }
    return _easeOut;
}

+ (EasingCurve)easeInOut
{
    static EasingCurve _easeInOut;
    if (!_easeInOut) {
        EasingCurve easeIn = [self easeIn];
        EasingCurve easeOut = [self easeOut];
        _easeInOut = ^CGFloat(CGFloat ratio) {
            if (ratio < 0.5) {
                return 0.5f * easeIn(ratio * 2.0f);
            }
            else {
                return 0.5f * easeOut(ratio * 2.0f - 1.0f) + 0.5f;
            }
        };
    }
    return _easeInOut;
}


@end