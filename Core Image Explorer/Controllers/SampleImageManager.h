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
    ImageSourceUserSelected,
    ImageSourceLibrary
};

typedef NS_ENUM(NSInteger, ImageIntent) {
    ImageIntentComposition,
    ImageIntentThumbnail
};

typedef NS_ENUM(NSInteger, ImageOrientation) {
    ImageOrientationLandscape,
    ImageOrientationPortrait
};

typedef void (^SampleCompletionBlock)(UIImage *image, NSError *error);

@interface SampleImageManager : NSObject

@property (readonly) BOOL samplesAreReady;

+ (SampleImageManager *)sharedManager;

- (void)createSamplesIfNeeded;

- (void)getImageSource:(ImageSource)imageSource
             forIntent:(ImageIntent)intent
         inOrientation:(ImageOrientation)orientation
            completion:(SampleCompletionBlock)completion;
@end
