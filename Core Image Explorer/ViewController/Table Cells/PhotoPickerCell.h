//
//  PhotoPickerCell.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseInputControlCell.h"

@class PhotoPickerCell;

@protocol PhotoPickerDelegate <NSObject>

@required
- (BOOL)photoPickerAllowedToUseVideo:(PhotoPickerCell *)photoPicker;
- (void)photoPicker:(PhotoPickerCell *)photoPicker isUsingVideo:(BOOL)usingVideo;
- (void)photoPicker:(PhotoPickerCell *)photoPicker presentPickerController:(UIImagePickerController *)pickerController;
- (void)photoPickerDismiss:(PhotoPickerCell *)photoPicker;

@end

@interface PhotoPickerCell : BaseInputControlCell <UIActionSheetDelegate,
                                                   UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate,
                                                   AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) NSInteger defaultImageIndex;
@property (readonly) BOOL isUsingVideo;
@property (weak, nonatomic) id <PhotoPickerDelegate> photoDelegate;

- (void)stopUsingVideo;

@end
