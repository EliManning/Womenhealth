//
//  ThirdChoiceViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "ThirdChoiceViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface ThirdChoiceViewController (){
    ExampleAppDataObject* theDataObject;
}

@end

@implementation ThirdChoiceViewController

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
    if(theDataObject.thirdVoted){
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
    theDataObject.thirdVoted =YES;
    theDataObject.fobtNum +=1;
    NSString* msg = @"You chose FOBT. Please click Next to continue.";
  //  msg = [msg stringByAppendingFormat:@"%d ", theDataObject.fobtNum];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: msg
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    }
}
- (IBAction)ColonButton:(id)sender {
    if(theDataObject.thirdVoted){
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
    theDataObject.thirdVoted =YES;
    theDataObject.colonNum +=1;
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
    
    if (theDataObject.thirdVoted) {
        [self performSegueWithIdentifier: @"next3" sender:self];
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
    if ([identifier isEqualToString:@"next3"]&& !theDataObject.thirdVoted) {
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
	//ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
@end
