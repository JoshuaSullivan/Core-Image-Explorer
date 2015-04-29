//
// Created by Joshua Sullivan on 2/26/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

@import QuartzCore;
#import "JTSTweener.h"

const struct JTSTweenerOptions JTSTweenerOptions = {
        .repeatCount = @"repeatCount",
        .delay = @"delay",
};

const CFTimeInterval kDroppedFrameThreshold = 0.5;

static NSMutableArray *_tweeners;
static CADisplayLink *_displayLink;
static CFTimeInterval _prevTimestamp = -1.0;

@interface JTSTweener ()

@property (assign, nonatomic) BOOL isPaused;
@property (assign, nonatomic) BOOL isComplete;
@property (assign, nonatomic) CGFloat valueDifference;
@property (assign, nonatomic) CFTimeInterval elapsedTime;
@property (copy, nonatomic) JTSTweenProgressBlock progressBlock;
@property (copy, nonatomic) JTSTweenCompletionBlock  completionBlock;
@property (strong, nonatomic) NSTimer *delayTimer;

@property (assign, nonatomic) NSInteger repeatCount;

@end

@implementation JTSTweener

+ (JTSTweener *)tweenerWithDuration:(NSTimeInterval)duration
                      startingValue:(CGFloat)startingValue
                        endingValue:(CGFloat)endingValue
                        easingCurve:(EasingCurve)easingCurve
                            options:(NSDictionary *)optionsOrNil
                      progressBlock:(JTSTweenProgressBlock)progressBlock
                    completionBlock:(JTSTweenCompletionBlock)completionBlock
{
    JTSTweener *tweener = [[JTSTweener alloc] initWithDuration:duration
                                                 startingValue:startingValue
                                                   endingValue:endingValue
                                                   easingCurve:easingCurve
                                                       options:optionsOrNil
                                                 progressBlock:progressBlock
                                               completionBlock:completionBlock];
    [self registerTweener:tweener];
    return tweener;
}

/**
*  Discourage the manual instantiation of the class.
*
*  @return Always returns nil.
*/
- (instancetype)init
{
    NSAssert(NO, @"ERROR: The JTSTweener class should only be instantiated via the static 'tweenerWtihDuration:' method.");
    return nil;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                   startingValue:(CGFloat)startingValue
                     endingValue:(CGFloat)endingValue
                     easingCurve:(EasingCurve)easingCurve
                         options:(NSDictionary *)optionsOrNil
                   progressBlock:(JTSTweenProgressBlock)progressBlock
                 completionBlock:(JTSTweenCompletionBlock)completionBlock
{
    self = [super init];
    if (!self) {
        NSLog(@"%@ failed to init.", NSStringFromClass([self class]));
        return nil;
    }
    _duration = duration;
    _startingValue = startingValue;
    _endingValue = endingValue;
    _valueDifference = endingValue - startingValue;
    _easingCurve = [easingCurve copy];
    _repeatCount = 0;
    if (optionsOrNil) {
        [self parseOptionsDictionary:optionsOrNil];
    }
    self.progressBlock = progressBlock;
    self.completionBlock = completionBlock;
    _elapsedTime = 0.0;
    return self;
}

- (void)parseOptionsDictionary:(NSDictionary *)options
{
    for (NSString *key in options) {
        if ([key isEqualToString:JTSTweenerOptions.repeatCount]) {
            id value = options[key];
            if (![value isKindOfClass:[NSNumber class]]) {
                NSAssert(NO, @"ERROR: repeatCount value must be a NSNumber.");
                continue;
            }
            self.repeatCount = [(NSNumber *)options[key] integerValue];
        } else if ([key isEqualToString:JTSTweenerOptions.delay]) {
            id value = options[key];
            if (![value isKindOfClass:[NSNumber class]]) {
                NSAssert(NO, @"ERROR: delay value must be a NSNumber.");
                continue;
            }
            NSTimeInterval delay = fmax([(NSNumber *)value floatValue], 0.0);
            if (delay < 0.0) {
                continue;
            }
            self.isPaused = YES;
            self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                               target:self
                                                             selector:@selector(delayTimerDidFire:)
                                                             userInfo:nil
                                                              repeats:NO];
        }
    }
}

- (void)setStartingValue:(CGFloat)startingValue
{
    _startingValue = startingValue;
    self.valueDifference = self.endingValue - startingValue;
}

- (void)setEndingValue:(CGFloat)endingValue
{
    _endingValue = endingValue;
    self.valueDifference = endingValue - self.startingValue;
}

- (void)pause
{
    self.isPaused = YES;
}

- (void)resume
{
    self.isPaused = NO;
}

- (void)cancel
{
    if (self.delayTimer) {
        [self.delayTimer invalidate];
        self.delayTimer = nil;
    }
    if (self.completionBlock) {
        self.completionBlock(self, NO);
    }
    [self destroy];
}

- (void)destroy
{
    // Remove references to the easing curve and progress and completion blocks.
    _easingCurve = NULL;
    _progressBlock = NULL;
    _completionBlock = NULL;
}

- (void)delayTimerDidFire:(NSTimer *)delayTimer
{
    self.isPaused = NO;
    self.delayTimer = nil;
    [self update:0.0];
}

/**
*  This method is invoked on every tick of the display link while the tweeener is not paused.
*
*  @param interval The time span (in seconds) since the previous update.
*/
- (void)update:(CFTimeInterval)interval
{
    // Keep track of the elapsed time.
    self.elapsedTime += interval;

    // If the elapsed time is greater than or equal to the duration, then the tween is complete.
    if (self.elapsedTime >= self.duration) {

        // Check to see if we need to repeat.
        if (self.repeatCount != 0) {
            self.elapsedTime = fmod(self.elapsedTime, self.duration);
            self.repeatCount--;
        } else {

            // Mark the tweener complete.
            self.isComplete = YES;

            // Final invocation of the progress block with the ending value.
            if (self.progressBlock) {
                self.progressBlock(self, self.endingValue, self.duration);
            }

            // If there is a completion block, invoke it with success YES.
            if (self.completionBlock) {
                self.completionBlock(self, YES);
            }

            // No need to make any of the calculations for this tweener.
            return;
        }
    }

    // Create the input ratio scalar value (percent of duration completed).
    CGFloat ratio = (CGFloat)(self.elapsedTime / self.duration);

    // Run the ratio through the easing function to create the eased ratio.
    CGFloat easedRatio = self.easingCurve(ratio);

    // Use the eased ratio to compute the current tween value.
    CGFloat value = easedRatio * self.valueDifference + self.startingValue;

    // If there is a progress block (why wouldn't there be!?) invoke it with the updated value.
    if (self.progressBlock) {
        self.progressBlock(self, value, self.elapsedTime);
    }
}

/**
*  Adds a tweener to the update list and ensures the Display Link is active.
*
*  @param tweener The JTSTweener instance to be added to the udpate list.
*/
+ (void)registerTweener:(JTSTweener *)tweener
{
    // Create the update list if it doesn't already exist.
    if (!_tweeners) {
        _tweeners = [NSMutableArray array];
    }

    // Add the tweener to the list.
    [_tweeners addObject:tweener];

    // Invoke the tweener's update method with time zero so that its progress block is triggered with the exact starting value.
    if (!tweener.isPaused) {
        [tweener update:0.0];
    }

    // If we haven't created the display link yet, do so now.
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLinkTick:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }

    // Make sure the display link isn't paused.
    _displayLink.paused = NO;

    // If the previous timestamp was the placeholder negative value, store the current media time so that we don't have
    // a 1-frame lag before the animation starts.
    if (_prevTimestamp < 0) {
        _prevTimestamp = CACurrentMediaTime();
    }
}

/**
*  When tweeners are active, this method tracks elapsed time-per-frame and invokes
*  the individual tweeners' update: method.
*
*  @param displayLink The CADisplayLink sending the update.
*/
+ (void)handleDisplayLinkTick:(CADisplayLink *)displayLink
{
    // Calculate the elapsed time since the last invocation of this method.
    CFTimeInterval dt = displayLink.timestamp - _prevTimestamp;

    // If it's been longer than the threshold time, drop the frame or the animation could go crazy.
    if (dt > kDroppedFrameThreshold) {
        _prevTimestamp = displayLink.timestamp;
        return;
    }

    // Keep track of tweeners that have completed for removal from the list at the end of the loop.
    NSMutableArray *completedTweeners = [NSMutableArray array];
    for (JTSTweener *tweener in _tweeners) {
        if (tweener.isComplete) {
            // The tweener is complete. Delete and remove it from the update list.
            [completedTweeners addObject:tweener];
            [tweener destroy];
        } else if (!tweener.isPaused) {
            // If the tweener isn't paused, invoke its update: method.
            [tweener update:dt];
        }
    }

    // If we have any tweeners to remove, do so.
    if (completedTweeners.count > 0) {
        [_tweeners removeObjectsInArray:completedTweeners];
    }

    // Store the current timestamp for the next loop.
    _prevTimestamp = displayLink.timestamp;

    // If there are no more tweeners, pause the DisplayLink to save CPU power.
    if (_tweeners.count == 0) {
        _prevTimestamp = -1.0;
        _displayLink.paused = YES;
    }
}

@end
