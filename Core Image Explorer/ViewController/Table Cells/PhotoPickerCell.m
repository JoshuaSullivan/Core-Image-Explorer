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

static NSString *kSheetTitle = @"Choose an Image";
static NSString *kCancelLabel = @"Cancel";
static NSString *kLibraryLabel = @"Pick from Library";
static NSString *kCameraLabel = @"Take a Photo";
static NSString *kVideoLabel = @"Use Live Video";
static NSString *kResetToDefault = @"Reset to Default";

@interface PhotoPickerCell ()

@property (strong, nonatomic) UIActionSheet *photoPickerSheet;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (assign, nonatomic) BOOL hasLibrary;
@property (assign, nonatomic) BOOL hasCamera;
@property (assign, nonatomic) BOOL hasVideo;

@end

@implementation PhotoPickerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageWasTapped:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    self.hasLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.hasVideo = NO;
    if (self.hasCamera) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaTypes indexOfObject:(id)kUTTypeMovie]) {
            self.hasVideo = YES;
        }
    }
    
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

#pragma mark - Force this picker to stop using video
- (void)stopUsingVideo
{
    DLog(@"Got it, boss!");
}

#pragma mark - Picker methods
- (void)resetToDefault
{
    [self.photoDelegate photoPicker:self isUsingVideo:NO];
    
    NSString *imageName = [NSString stringWithFormat:@"DefaultImage%d.png", self.defaultImageIndex];
    UIImage *defaultImage = [UIImage imageNamed:imageName];
    self.value = [CIImage imageWithCGImage:defaultImage.CGImage];
    self.imageView.image = defaultImage;
    
    [self.delegate inputControlCellValueDidChange:self];
}

- (void)takePhoto
{
    [self.photoDelegate photoPicker:self isUsingVideo:NO];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.allowsEditing = NO;
    
    [self.photoDelegate photoPicker:self presentPickerController:self.imagePicker];
}

- (void)takeVideo
{
    [self.photoDelegate photoPicker:self isUsingVideo:YES];
    DLog(@"Starting video capture...");
}

- (void)pickFromLibrary
{
    [self.photoDelegate photoPicker:self isUsingVideo:NO];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.allowsEditing = NO;
    
    [self.photoDelegate photoPicker:self presentPickerController:self.imagePicker];
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
        if (self.hasLibrary) {
            [self.photoPickerSheet addButtonWithTitle:kLibraryLabel];
        }
        
        if (self.hasCamera) {
            [self.photoPickerSheet addButtonWithTitle:kCameraLabel];
        }
        
        BOOL videoAllowed = [self.photoDelegate photoPickerAllowedToUseVideo:self];
        if (self.hasVideo && videoAllowed) {
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
    } else {
        DLog(@"Unrecognized button label: %@", buttonLabel);
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
