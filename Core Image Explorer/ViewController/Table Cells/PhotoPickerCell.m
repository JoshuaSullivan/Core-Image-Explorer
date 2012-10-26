//
//  PhotoPickerCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "PhotoPickerCell.h"

@interface PhotoPickerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoPickerCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary startingValue:value andInputName:inputName];
    
    self.imageView.image = [UIImage imageWithCIImage:(CIImage *)self.value];
}

@end
