//
//  PhotoPickerCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoPickerCell.h"
#import "UIImage+Transform.h"

#define kDefaultImageWidth 120.0
#define kDefaultImageHeight 90.0
#define kMargin 20.0

typedef enum {
    PickerModeNone = 0,
    PickerModePhoto,
    PickerModeLibrary,
    PickerModePhotoAndLibrary
} PickerMode;

static NSString *kSheetTitle = @"Choose an Image";
static NSString *kCancelLabel = @"Cancel";
static NSString *kCameraLabel = @"Take a Photo";
static NSString *kLibraryLabel = @"Pick from Library";
static NSString *kResetToDefault = @"Reset to Default";

@interface PhotoPickerCell ()

@property (assign, nonatomic) PickerMode pickerMode;
@property (strong, nonatomic) UIActionSheet *photoPickerSheet;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation PhotoPickerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageWasTapped:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL hasLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    self.pickerMode = hasCamera | hasLibrary << 1;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
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

#pragma mark - Picker methods
- (void)resetToDefault
{
    NSString *imageName = [NSString stringWithFormat:@"DefaultImage%d.png", self.defaultImageIndex];
    UIImage *defaultImage = [UIImage imageNamed:imageName];
    self.value = [CIImage imageWithCGImage:defaultImage.CGImage];
    self.imageView.image = defaultImage;
    
    
    [self.delegate inputControlCellValueDidChange:self];
}

- (void)takePhoto
{
    NSLog(@"Take a photo.");
}

- (void)pickFromLibrary
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.allowsEditing = NO;
    
    [self.photoDelegate photoPicker:self presentPickerController:self.imagePicker];
}

#pragma mark - Display picker action sheet
- (void)imageWasTapped:(UITapGestureRecognizer *)sender
{
    if (!self.photoPickerSheet) {        
        if (self.pickerMode == PickerModePhotoAndLibrary) {
        
            self.photoPickerSheet = [[UIActionSheet alloc] initWithTitle:kSheetTitle
                                                                delegate:self
                                                       cancelButtonTitle:kCancelLabel
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:kCameraLabel, kLibraryLabel, kResetToDefault, nil];
        } else if (self.pickerMode == PickerModePhoto) {
            self.photoPickerSheet = [[UIActionSheet alloc] initWithTitle:kSheetTitle
                                                                delegate:self
                                                       cancelButtonTitle:kCancelLabel
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:kCameraLabel, kResetToDefault, nil];
        } else if (self.pickerMode == PickerModeLibrary) {
            self.photoPickerSheet = [[UIActionSheet alloc] initWithTitle:kSheetTitle
                                                                delegate:self
                                                       cancelButtonTitle:kCancelLabel
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:kLibraryLabel, kResetToDefault, nil];

        } else {
            return;
        }
    }
    
    [self.photoPickerSheet showInView:self.window];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.pickerMode == PickerModePhotoAndLibrary) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self pickFromLibrary];
                break;
            default:
                [self resetToDefault];
                break;
        }
    } else if (self.pickerMode == PickerModePhoto) {
        if (buttonIndex == 0) {
            [self takePhoto];
        } else {
            [self resetToDefault];
        }
    } else if (self.pickerMode == PickerModeLibrary) {
        if (buttonIndex == 0) {
            [self pickFromLibrary];
        } else {
            [self resetToDefault];
        }
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

@end
