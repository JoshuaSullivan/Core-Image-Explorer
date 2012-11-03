//
//  InfoModalViewController.h
//  Core Image Explorer
//
//  Created by Joshua Sullivan on 11/2/12.
//  Copyright (c) 2012 Joshua Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoModalViewController : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

- (IBAction)dismissInfoModal:(id)sender;

@end
