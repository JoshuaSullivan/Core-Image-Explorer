//
//  ImageInputCollectionViewCell.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/17/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageInputCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end
