//
//  PhotoPickerCell.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "BaseInputControlCell.h"

@class PhotoPickerCell;

@protocol PhotoPickerDelegate <NSObject>

@required
- (void)photoPicker:(PhotoPickerCell *)photoPicker presentPickerController:(UIImagePickerController *)pickerController;
- (void)photoPickerDismiss:(PhotoPickerCell *)photoPicker;

@end

@interface PhotoPickerCell : BaseInputControlCell <UIActionSheetDelegate,
                                                   UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) NSInteger defaultImageIndex;

@property (weak, nonatomic) id <PhotoPickerDelegate> photoDelegate;

@end
