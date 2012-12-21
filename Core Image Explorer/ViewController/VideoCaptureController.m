//
//  VideoCaptureController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 12/19/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "VideoCaptureController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>

NSString * const kVideoControllerCaptureStart = @"kVideoControllerCaptureStart";
NSString * const kVideoControllerCaptureStop =  @"kVideoControllerCaptureStop";

@interface VideoCaptureController ()

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoDataOutput *dataOutput;
@property (weak, nonatomic) id <AVCaptureAudioDataOutputSampleBufferDelegate> delegate;

@end

@implementation VideoCaptureController

- (id)init {
    self = [super init];
    if (self) {
        [self configureVideo];
        [self addVideoListeners];
    }
    return self;
}

- (void)dealloc
{
    [self.captureSession stopRunning];
    [self removeVideoListeners];
}

- (void)configureVideo
{
    // Create the capture session
    self.captureSession = [AVCaptureSession new];
    [self.captureSession beginConfiguration];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    // Capture device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Device input
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    [self.captureSession addInput:deviceInput];
    
    // Data Output
    self.dataOutput = [AVCaptureVideoDataOutput new];
    self.dataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    self.dataOutput.alwaysDiscardsLateVideoFrames = YES;
//    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.captureSession addOutput:self.dataOutput];
    [self.captureSession commitConfiguration];
}

#pragma mark - Add/Remove video event listeners

- (void)addVideoListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleVideoStart:)
                                                 name:kVideoControllerCaptureStart
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleVideoStop:)
                                                 name:kVideoControllerCaptureStop
                                               object:nil];
}

- (void)removeVideoListeners
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kVideoControllerCaptureStart
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kVideoControllerCaptureStop
                                                  object:nil];
}

#pragma mark - Video Event Handlers
- (void)handleVideoStart:(NSNotification *)note
{
    if (!note.object) {
        DLog(@"OY! You gotta pass an object for this to work.");
        return;
    }
    
    if (note.object != self.dataOutput.sampleBufferDelegate) {
        [self.dataOutput setSampleBufferDelegate:note.object
                                           queue:dispatch_get_main_queue()];
    }
    
    if (!self.captureSession.running) {
        [self.captureSession startRunning];
    }
}

- (void)handleVideoStop:(NSNotification *)note
{
    if (self.captureSession.running) {
        [self.captureSession stopRunning];
        [self.dataOutput setSampleBufferDelegate:nil
                                           queue:NULL];
    }
}

@end
