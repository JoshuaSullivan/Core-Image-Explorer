//
//  MinimalistInputViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/21/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "MinimalistInputViewController.h"
#import "MinimalistControlView.h"

@interface MinimalistInputViewController ()

@property (assign, nonatomic) NSInteger inputCount;
@property (strong, nonatomic) NSArray *valueRanges;
@property (strong, nonatomic) NSArray *sectionDividers;

@end

@implementation MinimalistInputViewController

+ (MinimalistInputViewController *)minimalistControlForInputCount:(NSInteger)inputCount valueRanges:(NSArray *)ranges
{
    return [[self alloc] initWithInputCount:inputCount valueRanges:ranges];
}

- (instancetype)initWithInputCount:(NSInteger)inputCount valueRanges:(NSArray *)ranges
{
    NSAssert(inputCount > 0, @"ERROR: You must specify at least 1 input.");
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSLog(@"ERROR: Unable to create MinimalistInputViewController.");
        return nil;
    }
    _inputCount = MAX(1, inputCount);
    _valueRanges = ranges;
    return self;
}

- (void)loadView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    NSMutableArray *inputs = [NSMutableArray arrayWithCapacity:(NSUInteger)self.inputCount];
    BOOL isHorizontal = screenBounds.size.width > screenBounds.size.height;
    if (isHorizontal) {
        CGFloat w = screenBounds.size.width / self.inputCount;
        CGFloat h = screenBounds.size.height;
        for (NSInteger i = 0; i < self.inputCount; i++) {
            CGRect inputFrame = CGRectMake(w * i, 0.0f, w, h);
            MinimalistControlView *inputControl = [[MinimalistControlView alloc] initWithFrame:inputFrame];
            [inputs addObject:inputControl];
        }
    } else {
        CGFloat w = screenBounds.size.width;
        CGFloat h = screenBounds.size.height / self.inputCount;
        for (NSInteger i = 0; i < self.inputCount; i++) {
            CGRect inputFrame = CGRectMake(0.0f, i * h, w, h);
            MinimalistControlView *inputControl = [[MinimalistControlView alloc] initWithFrame:inputFrame];
            [inputs addObject:inputControl];
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:screenBounds];
    self.view = view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.tintColor = [UIColor blueColor];
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
