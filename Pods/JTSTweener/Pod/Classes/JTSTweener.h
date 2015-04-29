//
// Created by Joshua Sullivan on 2/26/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import Foundation;
#import "JTSTweenerTypes.h"

@class JTSTweener;

/**
* The JTSTweenProgressBlock is triggered every tick that the value changes.
* NOTE: It will also trigger at 0% and 100% unless suppressed in the options.
*
* @param tween The JTSTweener that is firing the progress block.
* @param value The current value of the tween.
* @param elapsedTime The time elapsed thus far on the tween (will fall in the range 0 - duration, inclusive).
*/
typedef void (^JTSTweenProgressBlock)(JTSTweener *tween, CGFloat value, NSTimeInterval elapsedTime);

/**
* Triggered after the 100% progress block invocation.
*
* @param tween The JTSTweener that is firing the progress block.
* @param completedSuccessfully Returns YES if the tweener reached 100% prior to completing.
*/
typedef void (^JTSTweenCompletionBlock)(JTSTweener *tween, BOOL completedSuccessfully);

extern const struct JTSTweenerOptions {
    /**
    *  Value should be an NSNumber wrapping a signed integer.
    *  This value should be interpreted to mean "the number of times the animation will repeat after its
    *  first run-through." A value of 3 would cause the animation to play 4 times (original run + 3 repeats).
    *  A negative value will cause the tweener to repeat indefinitely.
    *  The default value for this option is 0, meaning the tween runs only once.
    */
    __unsafe_unretained NSString *repeatCount;

    /** Value should be a NSNumber wrapping a non-negative NSTimeInterval/double. Negative values will be treated as 0. */
    __unsafe_unretained NSString *delay;
} JTSTweenerOptions;

@interface JTSTweener : NSObject

/** The value that the tween will start at. The first progress invocation will be this value. */
@property (assign, nonatomic) CGFloat startingValue;

/** The value that the tween will end at. The last progress invocation will be this value.*/
@property (assign, nonatomic) CGFloat endingValue;

/** The duration of the tween, measured in seconds. */
@property (assign, nonatomic) NSTimeInterval duration;

/** The EasingCurve function being used in the tween. */
@property (readonly, nonatomic) EasingCurve easingCurve;

/** The options dictionary passed in at creation. This is not actually supported yet. */
@property (readonly, nonatomic) NSDictionary *options;

/** The play/paused state of the tween. */
@property (readonly, nonatomic) BOOL isPaused;

/** The completion state of the tween. */
@property (readonly, nonatomic) BOOL isComplete;

/**
 *  Creates and returns a configured JTSTweener object. You do not need to retain the Tweener unless you want
 *  to be able to pause/cancel it outside of the progress block. The tweener will be automatically destroyed
 *  when it is completes.
 *
 *  @param duration        The duration of the tween in seconds.
 *  @param startingValue   The value the tween starts on.
 *  @param endingValue     The value the tween ends on.
 *  @param easingCurve     The easing curve for the tween.
 *  @param optionsOrNil    The options dictionary for the tween. Currently, no configuration options are supported, so this can be left as nil.
 *  @param progressBlock   The callback block that is invoked every time the tweener changes its value.
 *  @param completionBlock An optional callback block invoked after the final progress update.
 *
 *  @return Returns a configured and active JTSTweener object.
 */
+ (JTSTweener *)tweenerWithDuration:(NSTimeInterval)duration
                      startingValue:(CGFloat)startingValue
                        endingValue:(CGFloat)endingValue
                        easingCurve:(EasingCurve)easingCurve
                            options:(NSDictionary *)optionsOrNil
                      progressBlock:(JTSTweenProgressBlock)progressBlock
                    completionBlock:(JTSTweenCompletionBlock)completionBlock;

/** Pause the current tween. Paused tweens do not invoke their progress block. */
- (void)pause;

/** Unpause the tween. The progress will resume where it left off when paused. */
- (void)resume;

/** Cancel a tween and mark it for destruction. NOTE: This will result in the completion block being invoked with a negative success. */
- (void)cancel;


@end