//
//  PhotoPickerCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoPickerCell.h"
#import "VideoCaptureController.h"
#import "UIImage+Transform.h"

#define kDefaultImageWidth 120.0
#define kDefaultImageHeight 90.0
#define kMargin 20.0
#define kVideoTargetWidth 640.0

static NSString *kSheetTitle = @"Choose an Image";
static NSString *kCancelLabel = @"Cancel";
static NSString *kLibraryLabel = @"Pick from Library";
static NSString *kCameraLabel = @"Take a Photo";
static NSString *kVideoLabel = @"Use Live Video";
static NSString *kResetToDefault = @"Reset to Default";

@interface PhotoPickerCell ()

@property (strong, nonatomic) UIActionSheet *photoPickerSheet;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (assign, nonatomic) BOOL hasCapabilityLibrary;
@property (assign, nonatomic) BOOL hasCapabilityCamera;
@property (assign, nonatomic) BOOL hasCapabilityVideo;

@end

@implementation PhotoPickerCell

@synthesize isUsingVideo = _isUsingVideo;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageWasTapped:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    self.hasCapabilityLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    self.hasCapabilityCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.hasCapabilityVideo = NO;
    if (self.hasCapabilityCamera) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaTypes indexOfObject:(id)kUTTypeMovie]) {
            self.hasCapabilityVideo = YES;
        }
    }
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
}

- (void)dealloc
{
    if (_isUsingVideo) {
        [self stopVideoCapture];
    }
}

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary startingValue:value andInputName:inputName];
    
    UIImage *image = [UIImage imageWithCIImage:(CIImage *)self.value];
    self.imageView.image = image;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX = self.bounds.size.width - kDefaultImageWidth - kMargin;
    CGFloat imageY = floorf((self.bounds.size.height - kDefaultImageHeight)/2);
    
    self.imageView.frame = CGRectMake(imageX, imageY, kDefaultImageWidth, kDefaultImageHeight);
}

#pragma mark - Force this picker to stop using video
- (void)stopUsingVideo
{
    [self resetToDefault];
}

#pragma mark - Picker methods
- (void)resetToDefault
{
    [self stopVideoCapture];
    
    NSString *imageName = [NSString stringWithFormat:@"DefaultImage%d.png", self.defaultImageIndex];
    UIImage *defaultImage = [UIImage imageNamed:imageName];
    self.value = [CIImage imageWithCGImage:defaultImage.CGImage];
    self.imageView.image = defaultImage;
    
    [self.delegate inputControlCellValueDidChange:self];
}

- (void)takePhoto
{
    [self stopVideoCapture];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.allowsEditing = NO;
    
    [self.photoDelegate photoPicker:self presentPickerController:self.imagePicker];
}

- (void)takeVideo
{
    [self startVideoCapture];    
}

- (void)pickFromLibrary
{
    [self stopVideoCapture];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.allowsEditing = NO;
    
    [self.photoDelegate photoPicker:self presentPickerController:self.imagePicker];
}

#pragma mark - Start and Stop video
- (void)startVideoCapture
{
    _isUsingVideo = YES;
    [self.photoDelegate photoPicker:self isUsingVideo:YES];
}

- (void)stopVideoCapture
{
    if (_isUsingVideo) {
        _isUsingVideo = NO;
        [self.photoDelegate photoPicker:self isUsingVideo:NO];
    }
}

#pragma mark - Display picker action sheet
- (void)imageWasTapped:(UITapGestureRecognizer *)sender
{
    if (!self.photoPickerSheet) {
        self.photoPickerSheet = [[UIActionSheet alloc] initWithTitle:kSheetTitle
                                                            delegate:self
                                                   cancelButtonTitle:kCancelLabel
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
        if (self.hasCapabilityLibrary) {
            [self.photoPickerSheet addButtonWithTitle:kLibraryLabel];
        }
        
        if (self.hasCapabilityCamera) {
            [self.photoPickerSheet addButtonWithTitle:kCameraLabel];
        }
        
        BOOL videoAllowed = [self.photoDelegate photoPickerAllowedToUseVideo:self];
        if (self.hasCapabilityVideo && videoAllowed) {
            [self.photoPickerSheet addButtonWithTitle:kVideoLabel];
        }
        
        [self.photoPickerSheet addButtonWithTitle:kResetToDefault];
    }
    
    [self.photoPickerSheet showInView:self.window];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *buttonLabel = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonLabel isEqualToString:kResetToDefault]) {
        [self resetToDefault];
    } else if ([buttonLabel isEqualToString:kLibraryLabel]) {
        [self pickFromLibrary];
    } else if ([buttonLabel isEqualToString:kCameraLabel]) {
        [self takePhoto];
    } else if ([buttonLabel isEqualToString:kVideoLabel]) {
        [self takeVideo];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    UIImage *scaledImage = [newImage imageByScalingProportionallyToMinimumSize:CGSizeMake(640.0, 480.0)];
    self.value = [CIImage imageWithCGImage:scaledImage.CGImage];
    self.imageView.image = scaledImage;
    
    [self.photoDelegate photoPickerDismiss:self];
    [self.delegate inputControlCellValueDidChange:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.photoDelegate photoPickerDismiss:self];
}

#pragma mark - UINavigationControllerDelegate methods
// Nothing here?

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate methods
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef) CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *bufferImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CGFloat scale = kVideoTargetWidth / CVPixelBufferGetHeight(pixelBuffer);
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
    transform = CGAffineTransformScale(transform, scale, scale);
    transform = CGAffineTransformTranslate(transform, -480.0, 0.0);
    bufferImage = [bufferImage imageByApplyingTransform:transform];
    bufferImage = [bufferImage imageByCroppingToRect:CGRectMake(0.0, 0.0, 640.0, 480.0)];
    self.value = bufferImage;
    CGFloat thumbScale = kDefaultImageWidth / kVideoTargetWidth;
    CGAffineTransform thumbTransform = CGAffineTransformMakeScale(thumbScale, thumbScale);
    CIImage *thumbImage = [bufferImage imageByApplyingTransform:thumbTransform];
    self.imageView.image = [UIImage imageWithCIImage:thumbImage];
    [self.delegate inputControlCellValueDidChange:self];
}

@end
