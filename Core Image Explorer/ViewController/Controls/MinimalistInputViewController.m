//
//  MinimalistInputViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 4/21/15.
//  Copyright (c) 2015 Joshua Sullivan. All rights reserved.
//

#import "MinimalistInputViewController.h"
#import "MinimalistControlView.h"
#import "MinimalistInputDescriptor.h"

@interface MinimalistInputViewController () <MinimalistInputDelegate>

@property (assign, nonatomic) NSUInteger inputCount;
@property (strong, nonatomic) NSArray *inputDescriptors;
@property (strong, nonatomic) NSArray *sectionDividers;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) NSArray *inputControls;

@end

@implementation MinimalistInputViewController

+ (MinimalistInputViewController *)minimalistControlForInputCount:(NSUInteger)inputCount inputDescriptors:(NSArray *)descriptors
{
    return [[self alloc] initWithInputCount:inputCount inputDescriptors:descriptors];
}

- (instancetype)initWithInputCount:(NSUInteger)inputCount inputDescriptors:(NSArray *)descriptors
{
    NSAssert(inputCount > 0, @"WARNING: You must specify at least 1 input. Value of 1 will be used for inputCount.");
    if (inputCount > descriptors.count) {
        NSAssert(NO, @"ERROR: You must provide enough descriptors to cover all inputs.");
        return nil;
    }
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        NSLog(@"ERROR: Unable to create MinimalistInputViewController.");
        return nil;
    }
    _inputCount = MAX(1, inputCount);
    _inputDescriptors = descriptors;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return self;
}

- (void)loadView
{
    // Base view is just a generic UIView.
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:screenBounds];
    self.view = view;

    // Create the input subviews.
    NSMutableArray *inputs = [NSMutableArray arrayWithCapacity:self.inputCount];
    for (NSInteger i = 0; i < self.inputCount; i++) {
        MinimalistInputDescriptor *descriptor = self.inputDescriptors[i];
        MinimalistControlView *inputControl = [[MinimalistControlView alloc] initWithDescriptor:descriptor];
        [inputs addObject:inputControl];
        inputControl.index = i;
        inputControl.delegate = self;
        [self.view addSubview:inputControl];
    }
    self.inputControls = [NSArray arrayWithArray:inputs];
    [self updateControlFramesForBounds:screenBounds];
    UIImage *closeIcon = [UIImage imageNamed:@"CloseIcon"];
    UIImage *closeIconSelected = [UIImage imageNamed:@"CloseIconSelected"];
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, closeIcon.size.width, closeIcon.size.height)];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.closeButton setImage:closeIcon forState:UIControlStateNormal];
    [self.closeButton setImage:closeIconSelected forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
    NSLayoutConstraint *closeTopConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.topLayoutGuide
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:10.0f];
    NSLayoutConstraint *closeRightConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f
                                                                             constant:-16.0f];
    [self.view addSubview:self.closeButton];
    [self.view addConstraints:@[closeTopConstraint, closeRightConstraint]];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    for (MinimalistControlView *minView in self. inputControls) {
        minView.indicatorHidden = YES;
    }
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        [self updateControlFramesForBounds:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    } completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        for (MinimalistControlView *minView in self. inputControls) {
            minView.indicatorHidden = NO;
        }
    }];
}

- (void)updateControlFramesForBounds:(CGRect)bounds
{

    BOOL isHorizontal = bounds.size.width > bounds.size.height;
    CGFloat dx = 0.0f;
    CGFloat dy = 0.0f;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    if (isHorizontal) {
        w = bounds.size.width / self.inputCount;
        dx = w;
    } else {
        h = bounds.size.height / self.inputCount;
        dy = h;
    }
    for (NSUInteger i = 0; i < self.inputCount; i++) {
        UIView *input = self.inputControls[i];
        CGRect inputFrame = CGRectIntegral(CGRectMake(dx * i, dy * i, w, h));
        input.frame = inputFrame;
    }
}

#pragma mark - Getters & Setters

- (void)setDescriptor:(MinimalistInputDescriptor *)descriptor forInputIndex:(NSUInteger)index
{
    if (index >= self.inputControls.count) {
        NSAssert(NO, @"ERROR: index value out of range.");
        return;
    }
    MinimalistControlView *control = self.inputControls[index];
    control.descriptor = descriptor;
}

- (CGFloat)valueForInputIndex:(NSUInteger)index
{
    if (index >= self.inputControls.count) {
        NSAssert(NO, @"ERROR: index value out of range.");
        return 0;
    }
    MinimalistControlView *control = self.inputControls[index];
    return control.value;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - MinimalistInputDelegate

- (void)minimalistInput:(MinimalistControlView *)control didSetValue:(CGFloat)value
{
    if ([self.delegate respondsToSelector:@selector(minimalistControl:didSetValue:forInputIndex:)]) {
        [self.delegate minimalistControl:self didSetValue:value forInputIndex:control.index];
    }
}

#pragma mark - IBAction

- (IBAction)closeTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(minimalistControlShouldClose:)]) {
        [self.delegate minimalistControlShouldClose:self];
    }
}

@end
