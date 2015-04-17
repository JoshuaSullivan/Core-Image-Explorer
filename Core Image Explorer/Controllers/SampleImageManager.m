//
// SampleImageManager.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/14/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "SampleImageManager.h"

static const CGFloat kThumbnailMaxDimension = 120.0f;

@interface SampleImageManager ()

@property (assign) BOOL samplesAreReady;
@property (assign, nonatomic) CGSize screenSize;
@property (assign, nonatomic) CGSize screenResolution;
@property (assign, nonatomic) CGFloat screenScale;

@property (strong, nonatomic) NSURL *sampleImageDirectory;

@property (strong, nonatomic) CIContext *context;

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

    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _context = [CIContext contextWithEAGLContext:eaglContext];

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
        ImageSource samples[4] = {ImageSourceSample1, ImageSourceSample2, ImageSourceSample3, ImageSourceSample4};
        ImageOrientation orientations[2] = {ImageOrientationLandscape, ImageOrientationPortrait};
        ImageIntent intents[2] = {ImageIntentComposition, ImageIntentThumbnail};
        for (size_t i = 0; i < 4; i++) {
            ImageSource source = samples[i];
            for (size_t j = 0; j < 2; j++) {
                ImageIntent intent = intents[j];
                for (size_t k = 0; k < 2; k++) {
                    ImageOrientation orientation = orientations[k];
                    if (![self imageSourceExists:source forIntent:intent inOrientation:orientation]) {
                        // The image does not exist.
                        [self createSampleImageSource:source forIntent:intent inOrientation:orientation];
                    }
                }
            }
        }
    });
}

- (void)getImageSource:(ImageSource)imageSource
             forIntent:(ImageIntent)intent
         inOrientation:(ImageOrientation)orientation
            completion:(SampleCompletionBlock)completion
{
    if (![self imageSourceExists:imageSource forIntent:intent inOrientation:orientation]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self createSampleImageSource:imageSource forIntent:intent inOrientation:orientation];
            NSString *imagePath = [self pathForImageSource:imageSource forIntent:intent inOrientation:orientation];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image, nil);
            });
        });

    } else {
        NSString *imagePath = [self pathForImageSource:imageSource forIntent:intent inOrientation:orientation];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        completion(image, nil);
    }

}

- (BOOL)createSampleImageSource:(ImageSource)imageSource forIntent:(ImageIntent)intent inOrientation:(ImageOrientation)orientation
{
    BOOL isSample = imageSource == ImageSourceSample1 || imageSource == ImageSourceSample2 || imageSource == ImageSourceSample3 || imageSource == ImageSourceSample4;
    if (!isSample) {
        NSAssert(NO, @"ERROR: createSampleImageSource can only be used for Sample ImageSources.");
        return NO;
    }
    NSURL *rawImageURL = [self URLForRawSampleSource:imageSource];
    CIImage *rawImage = [CIImage imageWithContentsOfURL:rawImageURL];
    CGRect imageRect = [rawImage extent];
    CGRect screenRect = [UIScreen mainScreen].nativeBounds;
    if (orientation == ImageOrientationLandscape) {
        screenRect = CGRectMake(0.0f, 0.0f, screenRect.size.height, screenRect.size.width);
    }
    CGFloat dw = imageRect.size.width / screenRect.size.width;
    CGFloat dh = imageRect.size.height / screenRect.size.height;
    CGFloat scale = dw < dh ? dw : dh;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    CGRect cropRect = CGRectApplyAffineTransform(screenRect, scaleTransform);
    CGFloat dx = roundf((imageRect.size.width - cropRect.size.width) / 2.0f);
    CGFloat dy = roundf((imageRect.size.height - cropRect.size.height) / 2.0f);
    cropRect = CGRectOffset(cropRect, dx, dy);
    CIImage *croppedImage = [rawImage imageByCroppingToRect:cropRect];
    if (intent == ImageIntentComposition) {
        scale = 1.0f / scale;
    } else {
        CGFloat screenScale = [UIScreen mainScreen].scale;
        CGFloat thumbEdge = kThumbnailMaxDimension * screenScale;
        dw = thumbEdge / cropRect.size.width;
        dh = thumbEdge / cropRect.size.height;
        scale = dw < dh ? dw : dh;
    }
    scaleTransform = CGAffineTransformMakeScale(scale, scale);
    croppedImage = [croppedImage imageByApplyingTransform:scaleTransform];
    imageRect = [croppedImage extent];
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(-imageRect.origin.x, -imageRect.origin.y);
    croppedImage = [croppedImage imageByApplyingTransform:moveTransform];
    CGImageRef renderedImage = [self.context createCGImage:croppedImage fromRect:[croppedImage extent]];
    UIImage *finalImage = [UIImage imageWithCGImage:renderedImage scale:self.screenScale orientation:UIImageOrientationUp];
    CGImageRelease(renderedImage);
    NSString *filePath = [self pathForImageSource:imageSource forIntent:intent inOrientation:orientation];
    NSData *imageData = UIImagePNGRepresentation(finalImage);
    DLog(@"Writing image (%@) to file: %@", finalImage, filePath);
    [imageData writeToFile:filePath atomically:YES];
    return YES;
}

- (BOOL)imageSourceExists:(ImageSource)imageSource forIntent:(ImageIntent)intent inOrientation:(ImageOrientation)orientation
{
    NSString *imagePath = [self pathForImageSource:imageSource forIntent:intent inOrientation:orientation];
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (NSURL *)URLForRawSampleSource:(ImageSource)imageSource
{
    NSString *fileExtension = @"png";
    NSString *fileName;
    switch (imageSource) {
        case ImageSourceSample1:
        case ImageSourceSample2:
            fileExtension = @"jpg";
        case ImageSourceSample3:
        case ImageSourceSample4:
            fileName = [NSString stringWithFormat:@"Sample%iRaw", imageSource];
            return [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExtension];
        default:
            NSAssert(NO, @"ERROR: Only the Sample ImageSource types have raw images.");
    }
    return nil;
}

- (NSString *)pathForImageSource:(ImageSource)imageSource forIntent:(ImageIntent)intent inOrientation:(ImageOrientation)orientation
{
    NSString *imageName = [self nameForImageSource:imageSource forIntent:intent inOrientation:orientation];
    return [self.sampleImageDirectory URLByAppendingPathComponent:imageName].path;
}

- (NSString *)nameForImageSource:(ImageSource)imageSource forIntent:(ImageIntent)intent inOrientation:(ImageOrientation)orientation
{
    NSString *suffix = (orientation == ImageOrientationLandscape) ? @"Landscape" : @"Portrait";
    NSString *fileName;
    NSString *fileExtension = @"png";
    switch (imageSource) {
        case ImageSourceSample1:
        case ImageSourceSample2:
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
    NSString *intentString = (intent == ImageIntentThumbnail) ? @"-Thumbnail" : @"";
    NSString *composedName = [NSString stringWithFormat:@"%@-%@%@.%@", fileName, suffix, intentString, fileExtension];
    return composedName;
}

@end
