@import UIKit;

typedef struct FloatRange {
    CGFloat min;
    CGFloat max;
} FloatRange;

UIKIT_STATIC_INLINE FloatRange FloatRangeMake(CGFloat min, CGFloat max) {
    FloatRange floatRange = {min, max};
    return floatRange;
}
