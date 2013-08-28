//
//  ResultViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "ResultViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface ResultViewController ()

@end

@implementation ResultViewController
@synthesize fobtResult;
@synthesize colonResult;
@synthesize resultLabel;
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
    NSString* fobtReultStr = [NSString stringWithFormat:@"%d", theDataObject.fobtNum];
    self.fobtResult.text =  fobtReultStr;
    NSString* colonReultStr = [NSString stringWithFormat:@"%d", theDataObject.colonNum];
    self.colonResult.text = colonReultStr;
    if(theDataObject.fobtNum > theDataObject.colonNum){
        self.resultLabel.text = @"FOBT";
         theDataObject.result = @"FOBT";
    }
    else{
         theDataObject.result = @"COLONOSCOPY";
        self.resultLabel.text = @"COLONOSCOPY";
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
- (IBAction)clearButtonClicked:(id)sender {
     ExampleAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.fobtNum = 0;
    theDataObject.colonNum = 0;
    self.fobtResult.text=@"0";
    self.colonResult.text= @"0";
    theDataObject.firstVoted = NO;
    theDataObject.secondVoted = NO;
    theDataObject.thirdVoted = NO;
    theDataObject.fourthVoted = NO;
    theDataObject.resultSubmitted=NO;
    UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroBoard"];
    [self.navigationController pushViewController:nextView animated:YES];
    
}

- (IBAction)backToFirstPage:(id)sender {
    UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroBoard"];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)logoutButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: @"Are you sure you want to log out?"
                          delegate: self
                          cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil
                          ];
    [alert show];
    [alert setTag:0];
  
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0){
        if(buttonIndex == 0){
                      
            return;
        }
        else if(buttonIndex == 1){
            ExampleAppDataObject* theDataObject = [self theAppDataObject];
           
            theDataObject.fobtNum = 0;
            theDataObject.colonNum = 0;
            self.fobtResult.text=@"0";
            self.colonResult.text= @"0";
            theDataObject.firstVoted = NO;
            theDataObject.secondVoted = NO;
            theDataObject.thirdVoted = NO;
            theDataObject.fourthVoted = NO;
            theDataObject.resultSubmitted=NO;
            theDataObject.questionCount = 0;
            theDataObject.riskCount = 0;
            theDataObject.riskScore = 0;
            theDataObject.riskAssessFinished= NO;
            theDataObject.beliefScore = 0;
            
            UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"firstBoard"];
            [self.navigationController pushViewController:nextView animated:YES];
            return;
        }
    }
}
- (IBAction)submitButton:(id)sender {
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyyHH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    NSLog(@"%@", dateInStringFormated);

     ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(!theDataObject.resultSubmitted){
       
    [self connectToRemoteDB:theDataObject.username Arg2:theDataObject.result Arg3:dateInStringFormated];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                           //   message:dateInStringFormated
                              message: @"Thank you for your submission.  "
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    theDataObject.resultSubmitted = YES;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Sorry, you have submitted the result to our server.  "
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    
        
    }
}
- (NSString *) connectToRemoteDB:(NSString *)username Arg2:(NSString *)result Arg3:(NSString *)time{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/mylifecloud/admin/snipper.php?username=%@&result=%@&curtime=%@",username,result,time];
    NSLog(@"URL is %@", strURL);
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    return strResult;
}
@end
