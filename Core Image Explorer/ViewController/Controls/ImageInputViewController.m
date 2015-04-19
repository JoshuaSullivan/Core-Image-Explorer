//
// ImageInputViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/14/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "ImageInputViewController.h"
#import "ImageInputCollectionViewCell.h"
#import "SampleImageManager.h"

static NSString * const kImageInputDataFile = @"ImageInputControlConfiguration";
static NSString * const kImageInputCellIdentifier = @"kImageInputCellIdentifier";

@interface ImageInputViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSArray *data;

@end

@implementation ImageInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *dataURL = [[NSBundle mainBundle] URLForResource:kImageInputDataFile withExtension:@"plist"];
    _data = [NSArray arrayWithContentsOfURL:dataURL];

}

- (BOOL)isControlSuitableForInput:(NSDictionary *)inputDictionary
{
    NSString *attributeType = inputDictionary[kCIAttributeType];
    return [attributeType isEqualToString:kCIAttributeTypeImage];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageInputCellIdentifier
                                                                                   forIndexPath:indexPath];
    NSDictionary *itemData = self.data[(NSUInteger)indexPath.item];
    cell.captionLabel = itemData[@"label"];
    ImageSource imageSource = (ImageSource)[itemData[@"source"] integerValue];
    [[SampleImageManager sharedManager] getThumbnailForSourceInCurrentOrientation:imageSource completion:^(UIImage *image) {
        if (image) {
            cell.imageView.image = image;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"CameraRollIcon"];
        }
    }];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
