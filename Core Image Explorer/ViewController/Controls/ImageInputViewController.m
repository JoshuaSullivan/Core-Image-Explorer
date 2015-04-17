//
// ImageInputViewController.m
// Core Image Explorer
//
// Created by Joshua Sullivan on 4/14/15.
// Copyright (c) 2015 Joshua Sullivan. All rights reserved.


#import "ImageInputViewController.h"

@interface ImageInputViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ImageInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


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
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
