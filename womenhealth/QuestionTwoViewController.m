//
//  QuestionTwoViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "QuestionTwoViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface QuestionTwoViewController (){
    ExampleAppDataObject* theDataObject;
    BOOL yesSelected;
    BOOL noSelected;
    BOOL dontKnowSelected;
    NSInteger newAssessScore;
    BOOL finishFlag;
}


@end

@implementation QuestionTwoViewController
@synthesize questionLabel = _questionLabel;
@synthesize YesButton = _YesButton;
@synthesize NoButton = _NoButton;
@synthesize DontKnowButton = _DontKnowButton;
@synthesize textField;

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
    [self.textField addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    theDataObject = [self theAppDataObject];
    theDataObject.supportCount = 1;
    newAssessScore = 1;
    finishFlag = NO;
    self.DontKnowButton.hidden=YES;
    self.textField.hidden = YES;
    [self.questionLabel setText:@"When you get a colonoscopy you will need a ride to and from the screening site. Will getting a ride to your colonoscopy be a problem?"];
    [self labelAppear];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)dismissKeyboard {
    [self.textField resignFirstResponder];
}
-(void)labelDisappear{
   
     //  self.DontKnowButton.hidden=YES;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         [self.questionLabel setAlpha:0.0];
     }
                     completion:^(BOOL finished)
     {
         if(finished){
             if(theDataObject.supportCount == 1){
                 [self.questionLabel setText:@"When you get a colonoscopy you will need a ride to and from the screening site. Will getting a ride to your colonoscopy be a problem? "];
                 self.DontKnowButton.hidden= YES;
                 self.textField.hidden = YES;
                 self.YesButton.hidden = NO;
                 [self.YesButton setTitle:@"YES" forState:UIControlStateNormal];
                 self.NoButton.hidden = NO;
             }
             else if(theDataObject.supportCount == 2){
                 [self.questionLabel setText:@"Think about your family and friends. Who will you talk to about your decision to get screened for colorectal cancer? "];
                
                 self.YesButton.hidden = YES;
                 self.NoButton.hidden = YES;
                 self.textField.hidden = NO;
                 self.DontKnowButton.hidden = YES;
             }
             else if(theDataObject.supportCount == 3){
                 [self.questionLabel setText:@"I want to do what members of my immediate family think I should do about colorectal cancer screening"];
                 self.DontKnowButton.hidden= NO;
                 self.YesButton.hidden = NO;
                 [self.DontKnowButton setTitle:@"Don‘t know" forState:UIControlStateNormal];
                 [self.YesButton setTitle:@"Yes" forState:UIControlStateNormal];
                  self.textField.hidden = YES;
                 self.NoButton.hidden = NO;
             }
             else if(theDataObject.supportCount == 4){
                 [self.questionLabel setText:@"Members of my immediate family think I should have colorectal cancer screening."];
                self.DontKnowButton.hidden= YES;
                  self.YesButton.hidden = NO;
                  self.textField.hidden = YES;
                 self.NoButton.hidden = NO;
             }
             else if(theDataObject.supportCount == 5){
                 [self.questionLabel setText:@"I want to do what my friends think I should do about colorectal cancer screening."];
                 self.DontKnowButton.hidden= YES;
                  self.textField.hidden = YES;
                  self.YesButton.hidden = NO;
                 self.NoButton.hidden = NO;
             }
             else if(theDataObject.supportCount == 6){
                 [self.questionLabel setText:@"My friends think I should have colorectal cancer screening."];
                  self.textField.hidden = YES;
                 self.DontKnowButton.hidden= YES;
                 self.NoButton.hidden = NO;
                  self.YesButton.hidden = NO;
                 //  [self.DontKnowButton setTitle:@"Don’t know" forState:UIControlStateNormal];
                
             }
             else if(theDataObject.supportCount == 7){
                 [self.questionLabel setText:@"Have any of your friends or family been screened for colorectal cancer?"];
                 self.DontKnowButton.hidden=  NO;
                  self.YesButton.hidden = NO;
                  self.textField.hidden = YES;
                  [self.DontKnowButton setTitle:@"Don‘t know" forState:UIControlStateNormal];
                 [self.YesButton setTitle:@"Yes" forState:UIControlStateNormal];
                 //   self.YesButton.titleLabel.text = @"FOBT";
                 [self.NoButton setTitle:@"No" forState:UIControlStateNormal];
               
             }
             else if(theDataObject.supportCount == 8){
                 [self.questionLabel setText:@"If yes, what test did they do? "];
                 self.DontKnowButton.hidden= NO;
                 [self.YesButton setTitle:@"FOBT" forState:UIControlStateNormal];
              //   self.YesButton.titleLabel.text = @"FOBT";
                 [self.NoButton setTitle:@"Colonoscopy" forState:UIControlStateNormal];
               //  [self.NoButton setFrame:CGRectFromString(self.NoButton.titleLabel.text)];

               //  self.NoButton.titleLabel.text = @"Colonoscopy";
             }
             [self labelAppear];
         }
     }];
    
}

-(void)labelAppear{
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         [self.questionLabel setAlpha:1.0];
     }
                     completion:^(BOOL finished)
     {

     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressYes:(id)sender {
    [self.textField resignFirstResponder];
  /*  if (theDataObject.supportCount<9) {
         theDataObject.supportCount +=1;
    }*/
    [self performSelector:@selector(toggleButton1:) withObject:sender afterDelay:0];

    NSLog(@"%d",theDataObject.supportCount);
}

- (IBAction)pressNo:(id)sender {
     [self.textField resignFirstResponder];
  /*  if (theDataObject.supportCount<9 && theDataObject.supportCount != 7) {
        theDataObject.supportCount +=1;
    }
    else if(theDataObject.supportCount == 7){
        theDataObject.supportCount = 9;
    }*/
    [self performSelector:@selector(toggleButton2:) withObject:sender afterDelay:0];

    NSLog(@"%d",theDataObject.supportCount);
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


- (IBAction)pressDontKnow:(id)sender {
     NSLog(@"%d",theDataObject.supportCount);
    [self performSelector:@selector(toggleButton3:) withObject:sender afterDelay:0]; 
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"next5"]&& !finishFlag) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please finish the questions first."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];

        return NO;
    }
    else
        return YES;
}
- (IBAction)nextButton:(id)sender {

        [self performSegueWithIdentifier: @"next5" sender:self];
 }

- (IBAction)previousButton:(id)sender {
    if (theDataObject.supportCount== 1) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"This is the first question."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    } 
    if (theDataObject.supportCount > 0 ) {
        theDataObject.supportCount -=1;
    }
        [self recoverButtons];
        [self labelDisappear];

}

- (IBAction)nextQuestionButton:(id)sender {
    [self.textField resignFirstResponder];

    if(theDataObject.supportCount == 2 && [self.textField.text length] ==0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"The text field shall not be empty."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }

    if(theDataObject.supportCount != 2 && !yesSelected && !noSelected && !dontKnowSelected){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please select an option."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSLog(@"Count %d %d %d", theDataObject.supportCount,noSelected,dontKnowSelected);
       if (theDataObject.supportCount== 8 || (theDataObject.supportCount == 7 && (noSelected || dontKnowSelected))) {
           finishFlag = YES;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"This is the last question. Please click Next to continue."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    else if (theDataObject.supportCount<8) {
        theDataObject.supportCount +=1;
    }
       [self recoverButtons];
       [self labelDisappear];

}

-(void)toggleButton1:(UIButton*)b{
    if(!yesSelected){
        b.highlighted = YES;
        yesSelected= YES;
            if(noSelected){
                [self performSelector:@selector(pressNo:) withObject:self.NoButton afterDelay:0];
            }
            if(dontKnowSelected){
                [self performSelector:@selector(pressDontKnow:) withObject:self.DontKnowButton afterDelay:0];
            }
        theDataObject.riskScore += newAssessScore;
    }
    else{
        b.highlighted = NO;
        yesSelected = NO;
        theDataObject.riskScore -= newAssessScore;
    }
}
-(void)toggleButton2:(UIButton*)b{
    if(!noSelected){
        b.highlighted = YES;
        noSelected= YES;
            if(yesSelected){
                [self performSelector:@selector(pressYes:) withObject:self.YesButton afterDelay:0];
            }
            if(dontKnowSelected){
                [self performSelector:@selector(pressDontKnow:) withObject:self.DontKnowButton afterDelay:0];
            }
             
        theDataObject.riskScore += newAssessScore;
    }
    else{
        b.highlighted = NO;
        noSelected = NO;
        theDataObject.riskScore -= newAssessScore;
    }
}
-(void)toggleButton3:(UIButton*)b{
    if(!dontKnowSelected){
        b.highlighted = YES;
        dontKnowSelected= YES;
            if(yesSelected){
                [self performSelector:@selector(pressYes:) withObject:self.YesButton afterDelay:0];
            }
            if(noSelected){
                [self performSelector:@selector(pressNo:) withObject:self.NoButton afterDelay:0];
            }
        theDataObject.riskScore += newAssessScore;
        
    }
    else{
        b.highlighted = NO;
        dontKnowSelected = NO;
        theDataObject.riskScore -= newAssessScore;
        
    }
}
-(void)recoverButtons{
    
    self.NoButton.highlighted=NO;
    self.YesButton.highlighted = NO;
    self.DontKnowButton.highlighted = NO;
   
    yesSelected = NO;
    noSelected = NO;
    dontKnowSelected = NO;
}
@end
