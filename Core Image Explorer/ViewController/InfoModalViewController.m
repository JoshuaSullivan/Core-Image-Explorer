//
//  InfoModalViewController.m
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 11/2/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import "InfoModalViewController.h"

@interface InfoModalViewController ()

@end

@implementation InfoModalViewController


#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions
- (IBAction)dismissInfoModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
