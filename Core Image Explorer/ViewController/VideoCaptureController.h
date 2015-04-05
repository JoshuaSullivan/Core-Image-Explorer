//
//  VideoCaptureController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 12/19/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

@import Foundation;

@protocol AVCaptureVideoDataOutputSampleBufferDelegate;

@interface VideoCaptureController : NSObject

+ (VideoCaptureController *)sharedManager;

- (void)startVideoCaptureWithDelegate:(id <AVCaptureVideoDataOutputSampleBufferDelegate>)delegate;
- (void)stopVideoCapture;

@end
