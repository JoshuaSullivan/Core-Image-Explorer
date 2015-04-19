//
// SampleImageManager.h
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/14/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ImageSource) {
    ImageSourceSample1 = 1,
    ImageSourceSample2,
    ImageSourceSample3,
    ImageSourceSample4,
    ImageSourceUser1,
    ImageSourceUser2,
    ImageSourceUser3,
    ImageSourceLiveVideo
};

typedef NS_ENUM(NSInteger, ImageIntent) {
    ImageIntentComposition,
    ImageIntentThumbnail
};

typedef NS_ENUM(NSInteger, ImageOrientation) {
    ImageOrientationLandscape,
    ImageOrientationPortrait
};

typedef void (^SampleCompletionBlock)(UIImage *image);

@interface SampleImageManager : NSObject

@property (readonly) BOOL samplesAreReady;

+ (SampleImageManager *)sharedManager;

- (void)createSamplesIfNeeded;

- (BOOL)imageSourceExists:(ImageSource)imageSource forIntent:(ImageIntent)intent inOrientation:(ImageOrientation)orientation;
- (void)getThumbnailForSourceInCurrentOrientation:(ImageSource)imageSource completion:(SampleCompletionBlock)completion;
- (void)getCompositionImageForSourceInCurrentOrientation:(ImageSource)imageSource completion:(SampleCompletionBlock)completion;


@end
