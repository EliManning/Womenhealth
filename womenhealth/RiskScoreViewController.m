//
//  RiskScoreViewController.m
//  womenhealth
//
//  Created by smart_parking on 6/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "RiskScoreViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface RiskScoreViewController ()

@end

@implementation RiskScoreViewController
@synthesize riskResultBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    NSString *riskscore = [NSString stringWithFormat:@"%d",theDataObject.riskScore];
    NSLog(@"Score: %@",riskscore);
    if(theDataObject.riskScore >1 && theDataObject.riskScore<14){
        theDataObject.riskLevel = @"average risk";
        [self.riskResultBar setText:@"Average Risk"];
    }
    else{
        theDataObject.riskLevel = @"high risk";
        [self.riskResultBar setText:@"High Risk"];
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    


- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
- (void)viewDidUnload {
   
    [self setRiskResultBar:nil];
  //  [self setNextButton:nil];

    [super viewDidUnload];
}
- (IBAction)notifyLater:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: @"Have a rest and come back in 10 minutes :) You can press the home button to return to the Home screen. Please do not quit the app, or your records will be lost."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];

    UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
    NSDate * tensecond = [NSDate dateWithTimeIntervalSinceNow:10*60];
    [localNotification setFireDate:tensecond]; //Set the date when the alert will be launched using the date adding the time the user selected on the time
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
  //  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
   // AudioServicesPlaySystemSound(1004);
    [localNotification setAlertAction:@"Launch"]; //The button's text that launches the application and is shown in the alert
    [localNotification setAlertBody:@"Let's come back to Mylife Cloud"]; //Set the message in the notification from the textField's text
    [localNotification setHasAction: YES]; //Set that pushing the button will launch the application
   // [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1]; //Set the Application Icon Badge Number of the application's icon to the current Application Icon Badge Number plus 1
   
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (IBAction)nextButton:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}/*
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
   
    if ([identifier isEqualToString:@"removeRest"]){
       
        return YES;
    }
    else if ([identifier isEqualToString:@"backToAssessment"]){
        UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"RiskAssessmentBoard"];
        [self.navigationController pushViewController:manuView animated:YES];
        return YES;
    }
    else
        return NO;
}*/
@end
