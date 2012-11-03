//
//  RectDisplayCell.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 11/3/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "RectDisplayCell.h"

@interface RectDisplayCell ()

@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *wLabel;
@property (strong, nonatomic) IBOutlet UILabel *hLabel;

@end

@implementation RectDisplayCell

- (void)configWithDictionary:(NSDictionary *)attributeDictionary
               startingValue:(NSObject *)value
                andInputName:(NSString *)inputName
{
    [super configWithDictionary:attributeDictionary
                  startingValue:value
                   andInputName:inputName];
    
    [self updateValueLabels];
}

- (void)updateValueLabels
{
    CIVector *rect = (CIVector *)self.value;
    self.xLabel.text = [NSString stringWithFormat:@"%0.1f", rect.X];
    self.yLabel.text = [NSString stringWithFormat:@"%0.1f", rect.Y];
    self.wLabel.text = [NSString stringWithFormat:@"%0.1f", rect.Z];
    self.hLabel.text = [NSString stringWithFormat:@"%0.1f", rect.W];
}

@end
