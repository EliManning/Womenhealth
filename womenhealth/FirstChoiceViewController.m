//
//  FirstChoiceViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "FirstChoiceViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface FirstChoiceViewController (){
    ExampleAppDataObject* theDataObject;
}

@end

@implementation FirstChoiceViewController

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
    theDataObject = [self theAppDataObject];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fobtButton:(id)sender {
    if(theDataObject.firstVoted){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"You have chosen an option. Please click Next to continue."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
    theDataObject.fobtNum +=1;
    theDataObject.firstVoted = YES;
    NSString* msg = @"You chose FOBT. Please click Next to continue.";
    // msg = [msg stringByAppendingFormat:@"%d ", theDataObject.fobtNum];
        self.fobtButtton.highlighted = YES;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: msg
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    }
}

- (IBAction)colonButton:(id)sender {
    if(theDataObject.firstVoted){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"You have chosen an option. Please click Next to continue."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
    theDataObject.firstVoted = YES;
    theDataObject.colonNum +=1;
    self.colonButton.highlighted = YES;
    NSString* msg = @"You chose Colonoscopy. Please click Next to continue.";
   // msg = [msg stringByAppendingFormat:@"%d ", theDataObject.colonNum];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: msg
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    }
}

- (IBAction)nextButton:(id)sender {
    NSLog(@"sadweqw");

    if (theDataObject.firstVoted) {
         [self performSegueWithIdentifier: @"next1" sender:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please select an option."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
 
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"sada");
    if ([identifier isEqualToString:@"next1"]&& !theDataObject.firstVoted) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please select an option."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else
        return YES;
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
@end
