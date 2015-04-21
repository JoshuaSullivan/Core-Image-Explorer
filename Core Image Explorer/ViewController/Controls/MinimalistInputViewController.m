//
//  MinimalistInputViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/21/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "MinimalistInputViewController.h"

@interface MinimalistInputViewController ()

@property (assign, nonatomic) NSInteger inputCount;
@property (strong, nonatomic) UIView *indicator;
@property (strong, nonatomic) NSArray *sectionDividers;
@property (strong, nonatomic) NSArray *sectionLabels;

@end

@implementation MinimalistInputViewController

+ (MinimalistInputViewController *)minimalistControlForInputCount:(NSInteger)inputCount
{
    return [[self alloc] initWithInputCount:inputCount];
}

- (instancetype)initWithInputCount:(NSInteger)inputCount
{
    NSAssert(inputCount > 0, @"ERROR: You must specify at least 1 input.");
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSLog(@"ERROR: Unable to create MinimalistInputViewController.");
        return nil;
    }
    _inputCount = MAX(1, inputCount);
    return self;
}

- (void)loadView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    BOOL isHorizontal = screenBounds.size.width > screenBounds.size.height;
    UIView *view = [[UIView alloc] initWithFrame:screenBounds];
    for (NSInteger i = 0; i < self.inputCount; i++) {
        
    }
    self.view = view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
