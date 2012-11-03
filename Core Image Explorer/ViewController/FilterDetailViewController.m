//
//  FilterTestViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/13/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "FilterDetailViewController.h"
#import "NumericSliderCell.h"
#import "AffineTransformCell.h"
#import "PositionPickerCell.h"

#define kGenericCellIdentifier @"GenericCellIdentifier"
#define kNumericSliderCellIdentifier @"NumericSliderCellIdentifier"
#define kPhotoPickerCellIdentifier @"PhotoPickerCellIdentifier"
#define kPositionPickerCellIdentifier @"PositionPickerCellIdentifier"
#define kColorPickerCellIdentifier @"ColorPickerCellIdentifier"
#define kAffineTransformCellIdentifier @"AffineTransformCellIdentifier"
#define kColorMatrixCellIdentifier @"ColorMatrixCellIdentifier"
#define kRectDisplayCellIdentifier @"RectDisplayCellIdentifier"

@interface FilterDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *outputImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shadowBox;

@property (strong, nonatomic) NSMutableArray *inputDescriptors;
@property (strong, nonatomic) NSMutableDictionary *inputCells;
@property (strong, nonatomic) NSMutableDictionary *inputValues;
@property (assign, nonatomic) NSUInteger imageCount;
@property (assign, nonatomic) NSUInteger imageCellCount;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) GestureInputCell *activeGestureCell;
@property (assign, nonatomic) BOOL isPickingPhoto;

@end

@implementation FilterDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageCount = 0;
    self.imageCellCount = 0;
    self.isPickingPhoto = NO;
    self.inputCells = [NSMutableDictionary dictionary];
        
    self.shadowBox.layer.shadowOffset = CGSizeMake(0, 1);
    self.shadowBox.layer.shadowOpacity = 0.4;
    self.shadowBox.layer.shadowRadius = 4.0;
    self.shadowBox.layer.shadowColor = [UIColor blackColor].CGColor;
	
    self.title = self.filter.attributes[kCIAttributeFilterDisplayName];
    self.inputDescriptors = [NSMutableArray arrayWithCapacity:self.filter.inputKeys.count];
    self.inputValues = [NSMutableDictionary dictionaryWithCapacity:self.filter.inputKeys.count];
    
//    NSLog(@"%@", self.title);
    for (NSString *inputKey in self.filter.inputKeys) {
        NSDictionary *inputAttributes = self.filter.attributes[inputKey];
        self.inputValues[inputKey] = [self getDefaultValueForInput:inputAttributes withName:inputKey];
//        NSLog(@"%@: %@", inputKey, self.inputValues[inputKey]);
        [self.inputDescriptors addObject:inputAttributes];
    }    
    
    if ([self.filter.name isEqualToString:@"CILightTunnel"]) {
        [self.inputValues setValue:@200.0 forKey:@"inputRadius"];
        [self.filter setValue:@0.0 forKey:@"inputRotation"];
        [self.filter setValue:@200.0 forKey:@"inputRadius"];
    }
    
    [self.tableView reloadData];
    [self updateResultImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.outputImageView.image = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (!self.isPickingPhoto) {
        self.outputImageView.image = nil;
        
        self.inputDescriptors = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - Update Filter Result

- (void) updateResultImage
{
    for (NSString *inputKey in self.filter.inputKeys) {
//        NSLog(@"Setting %@ = %@", inputKey, self.inputValues[inputKey]);
        [self.filter setValue:self.inputValues[inputKey] forKey:inputKey];
    }
    
    CIImage *outputImage = self.filter.outputImage;
    CGRect extent = outputImage.extent;
    if (CGRectIsInfinite(extent)) {
        extent = CGRectMake(0.0, 0.0, 640.0, 480.0);
    }
    
    CGImageRef cgImg = [self.ciContext createCGImage:outputImage
                                            fromRect:extent];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImg];
//    NSLog(@"%@", NSStringFromCGSize(resultImage.size));
    self.outputImageView.image = resultImage;
    CGImageRelease(cgImg);
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inputDescriptors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *inputName = self.filter.inputKeys[indexPath.row];
    UITableViewCell *cell = self.inputCells[inputName];
    
    if (cell) {
        return cell;
    }
    
    BOOL cacheCell = NO;
    
    NSDictionary *attributes = self.inputDescriptors[indexPath.row];
    NSString *inputClass = attributes[kCIAttributeClass];
    NSString *inputType = attributes[kCIAttributeType];
    
    if ([inputClass isEqualToString:@"NSNumber"]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kNumericSliderCellIdentifier];
    } else if ([inputClass isEqualToString:@"CIImage"]) {
        self.imageCellCount++;
        cell = [self.tableView dequeueReusableCellWithIdentifier:kPhotoPickerCellIdentifier];
        ((PhotoPickerCell *)cell).defaultImageIndex = self.imageCellCount;
        ((PhotoPickerCell *)cell).photoDelegate = self;
    } else if ([inputClass isEqualToString:@"CIVector"]) {
        // We've got to handle several different types of vectors with different intents.
        if (inputType == kCIAttributeTypePosition) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kPositionPickerCellIdentifier];
            ((PositionPickerCell *)cell).gestureDelegate = self;
            cacheCell = YES;
        } else if ([self.filter.name isEqualToString:@"CIColorMatrix"]) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kColorMatrixCellIdentifier];
        } else if (inputType == kCIAttributeTypeRectangle) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kRectDisplayCellIdentifier];
        } else {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kGenericCellIdentifier];
        }
    } else if ([inputClass isEqualToString:@"CIColor"]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kColorPickerCellIdentifier];
    } else if ([inputClass isEqualToString:@"NSValue"]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kAffineTransformCellIdentifier];
        ((AffineTransformCell *)cell).gestureDelegate = self;
        cacheCell = YES;
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kGenericCellIdentifier];
    }
    
    
    ((BaseInputControlCell *)cell).delegate = self;
    [(BaseInputControlCell *)cell configWithDictionary:attributes
                                         startingValue:self.inputValues[inputName]
                                          andInputName:inputName];
    
    // The value ranges for the inputs in the attributes dictionary for CILightTunnel are incorrect.
    if ([self.filter.name isEqualToString:@"CILightTunnel"]) {
        if ([inputName isEqualToString:@"inputRotation"]) {
            [(NumericSliderCell *)cell setInputRangeMinValue:@(-4.0 * M_PI)
                                                    maxValue:@(4.0 * M_PI)
                                             andDefaultValue:@0];
        } else if ([inputName isEqualToString:@"inputRadius"]) {
            [(NumericSliderCell *)cell setInputRangeMinValue:@8.0
                                                    maxValue:@400.0
                                             andDefaultValue:@200.0];
        }
    }
    
    if (cacheCell) {
        self.inputCells[inputName] = cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *attributes = self.inputDescriptors[indexPath.row];
    NSString *inputClass = attributes[kCIAttributeClass];
    if ([inputClass isEqualToString:@"CIImage"] ||
        [inputClass isEqualToString:@"CIColor"] ||
        [self.filter.name isEqualToString:@"CIColorMatrix"])
    {
        return 100.0;
    }
    
    return tableView.rowHeight;
}

#pragma mark - UITableViewDelegate methods

// Don't need this one here.

#pragma mark - InputCellDelegate
- (void)inputControlCellValueDidChange:(BaseInputControlCell *)inputControlCell
{
    NSString *inputName = inputControlCell.inputName;
    NSObject *inputValue = inputControlCell.value;
    
    self.inputValues[inputName] = inputValue;
    
    [self updateResultImage];
}

#pragma mark - GestureInputDelegate methods

- (void)gestureInput:(GestureInputCell *)gestureInput addGesturesToImageView:(NSArray *)gestures withBorderColor:(UIColor *)borderColor
{
    if (self.activeGestureCell) {
        [self.activeGestureCell deactivate];
    }
    
    for (UIGestureRecognizer *gesture in gestures) {
        [self.outputImageView addGestureRecognizer:gesture];
    }
    
    self.activeGestureCell = gestureInput;
    self.outputImageView.layer.borderColor = borderColor.CGColor;
    self.outputImageView.layer.borderWidth = 4.0;
}

- (void)gestureInputDidDeactivate:(GestureInputCell *)gestureInput
{
    self.activeGestureCell = nil;
    self.outputImageView.layer.borderWidth = 0.0;
}

#pragma mark - PhotoPickerDelegate
- (void)photoPicker:(PhotoPickerCell *)photoPicker presentPickerController:(UIImagePickerController *)pickerController
{
    self.isPickingPhoto = YES;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)photoPickerDismiss:(PhotoPickerCell *)photoPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.isPickingPhoto = NO;
}

#pragma mark - Helper methods

- (NSObject *)getDefaultValueForInput:(NSDictionary *)attributes withName:(NSString *)inputName
{
    
    NSObject *value;
    NSString *inputClass = attributes[kCIAttributeClass];
    NSString *inputType = attributes[kCIAttributeType];
    if ([inputClass isEqualToString:@"CIImage"]) {
        self.imageCount++;
        UIImage *inputImage = [UIImage imageNamed:[NSString stringWithFormat:@"DefaultImage%d.png", self.imageCount]];
        value = [CIImage imageWithCGImage:inputImage.CGImage];
    } else if ([inputClass isEqualToString:@"CIVector"]) {
        if (inputType == kCIAttributeTypePosition) {
            value = [CIVector vectorWithCGPoint:CGPointMake(320.0, 240.0)];
        } else if (inputType == kCIAttributeTypeRectangle) {
            value = [CIVector vectorWithCGRect:CGRectMake(0.0, 0.0, 640.0, 480.0)];
        } else {
            NSObject *filterValue = [self.filter valueForKey:inputName];
            value = filterValue ? filterValue : attributes[kCIAttributeDefault];
        }
    } else if ([inputClass isEqualToString:@"NSValue"]){
        value = attributes[kCIAttributeDefault];
    } else {
        NSObject *filterValue = [self.filter valueForKey:inputName];
        value = filterValue ? filterValue : attributes[kCIAttributeDefault];
    }
    return value;
}

#pragma mark - IBActions
- (IBAction)resetFilter:(id)sender
{
    [self.filter setDefaults];
    self.imageCount = 0;
    self.imageCellCount = 0;
    [self.inputCells removeAllObjects];
    for (NSString *inputKey in self.filter.inputKeys) {
        NSDictionary *inputAttributes = self.filter.attributes[inputKey];
        self.inputValues[inputKey] = [self getDefaultValueForInput:inputAttributes withName:inputKey];
    }
    
    [self.tableView reloadData];
    [self updateResultImage];
}

@end
