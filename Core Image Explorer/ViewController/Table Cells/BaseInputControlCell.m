//
//  BaseInputControlCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "BaseInputControlCell.h"

@implementation BaseInputControlCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    self.attributes = attributeDictionary;
    self.inputName = inputName;
    self.inputNameLabel.text = [NSString stringWithFormat:@"%@", inputName];
    if (value) {
        self.value = value;
    } else {
        self.value = self.attributes[kCIAttributeDefault];
    }
    
}

- (void)resetToDefault
{
    self.value = self.attributes[kCIAttributeDefault];
}

@end
