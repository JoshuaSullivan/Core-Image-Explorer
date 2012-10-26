//
//  BaseInputControlCell.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 10/16/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseInputControlCell;

@protocol InputCellDelegate <NSObject>

@required
- (void)inputControlCellValueDidChange:(BaseInputControlCell *)inputControlCell;

@end

@interface BaseInputControlCell : UITableViewCell

@property (weak, nonatomic) id <InputCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *inputNameLabel;
@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSString *inputName;
@property (strong, nonatomic) NSObject *value;

- (void)configWithDictionary:(NSDictionary *)attributeDictionary startingValue:(NSObject *)value andInputName:(NSString *)inputName;
- (void)resetToDefault;

@end
