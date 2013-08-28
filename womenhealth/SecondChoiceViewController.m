//
//  SecondChoiceViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "SecondChoiceViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface SecondChoiceViewController (){
    ExampleAppDataObject* theDataObject;
}

@end

@implementation SecondChoiceViewController

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
   // theDataObject.secondVoted=NO;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fobtButton:(id)sender {
    
    if(theDataObject.secondVoted){
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
        theDataObject.secondVoted =YES;
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
    if(theDataObject.secondVoted){
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
    theDataObject.secondVoted =YES;
    theDataObject.colonNum +=1;
    NSString* msg = @"You chose Colonoscopy. Please click Next to continue.";
  //  msg = [msg stringByAppendingFormat:@"%d ", theDataObject.colonNum];
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
    
    if (theDataObject.secondVoted) {
        [self performSegueWithIdentifier: @"next2" sender:self];
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
    if ([identifier isEqualToString:@"next2"]&& !theDataObject.secondVoted) {
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
