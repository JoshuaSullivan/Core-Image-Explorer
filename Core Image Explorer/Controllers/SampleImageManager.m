//
// SampleImageManager.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/14/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "SampleImageManager.h"

@interface SampleImageManager ()

@property (assign) BOOL samplesAreReady;
@property (assign, nonatomic) CGSize screenSize;
@property (assign, nonatomic) CGSize screenResolution;
@property (assign, nonatomic) CGFloat screenScale;

@property (strong, nonatomic) NSURL *sampleImageDirectory;

@end

@implementation SampleImageManager

static SampleImageManager *_instance;

+ (SampleImageManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SampleImageManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _screenScale = [UIScreen mainScreen].scale;
    _screenSize = [UIScreen mainScreen].bounds.size;
    _screenResolution = CGSizeApplyAffineTransform(_screenSize, CGAffineTransformMakeScale(_screenScale, _screenScale));

    NSArray *caches = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    if (!caches || caches.count == 0) {
        NSAssert(NO, @"ERROR: Cannot find caches directory.");
        return nil;
    }
    _sampleImageDirectory = caches[0];

    return self;
}

- (void)createSamplesIfNeeded
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    });
}

- (void)getImageSource:(ImageSource)imageSource forIntent:(ImageIntent)intent completion:(SampleCompletionBlock)completion
{

}

- (BOOL)imageSourceExists:(ImageSource)imageSource
{

}

- (NSString *)rawImageNameForSource:(ImageSource)imageSource
{

}

- (NSString *)nameForImageSource:(ImageSource)imageSource forOrientation:(ImageOrientation)orientation
{
    NSString *suffix = (orientation == ImageOrientationLandscape) ? @"Landscape" : @"Portrait";
    NSString *fileName;
    NSString *fileExtension = @"png";
    switch (imageSource) {
        case ImageSourceSample1:
        case ImageSourceSample2:
            fileExtension = @"jpg";
        case ImageSourceSample3:
        case ImageSourceSample4:
            fileName = [NSString stringWithFormat:@"Sample%li", (long)imageSource];
            break;
        case ImageSourceUserSelected:
            fileName = @"UserImage";
            break;
        default:
            return nil;
    }
    NSString *composedName = [NSString stringWithFormat:@"%@-%@.%@", fileName, suffix, fileExtension];
    return composedName;
}


@end
