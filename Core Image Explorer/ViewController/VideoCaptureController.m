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

@end

@implementation VideoCaptureController

static VideoCaptureController *_instance;

+ (VideoCaptureController *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VideoCaptureController alloc] init];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self configureVideo];
    }
    return self;
}

- (void)dealloc
{
    [self.captureSession stopRunning];
}

- (void)configureVideo
{
    // Create the capture session
    self.captureSession = [AVCaptureSession new];
    [self.captureSession beginConfiguration];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    // Capture device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Device input
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    
    // Data Output
    self.dataOutput = [AVCaptureVideoDataOutput new];
    self.dataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    self.dataOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([self.captureSession canAddOutput:self.dataOutput]) {
        [self.captureSession addOutput:self.dataOutput];
    }
    
    [self.captureSession commitConfiguration];
}

#pragma mark - Start/Stop Video Capture

- (void)startVideoCaptureWithDelegate:(id <AVCaptureVideoDataOutputSampleBufferDelegate>)delegate
{
    NSParameterAssert(delegate);
    [self.dataOutput setSampleBufferDelegate:delegate
                                       queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    if (!self.captureSession.running) {
        [self.captureSession startRunning];
    }
}

- (void)stopVideoCapture
{
    if (self.captureSession.running) {
        [self.captureSession stopRunning];
    }
}

@end
