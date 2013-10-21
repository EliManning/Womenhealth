//
//  QuestionOneViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "QuestionOneViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface QuestionOneViewController (){
    ExampleAppDataObject* theDataObject;
    BOOL yesSelected;
    BOOL noSelected;
    NSInteger lastPoint;
    NSMutableDictionary *myDictionary;
}

@end

@implementation QuestionOneViewController
@synthesize questionLabel= _questionLabel;
@synthesize questionBar;
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
    myDictionary = [[NSMutableDictionary alloc]init];
    theDataObject.questionCount = 1;
    self.questionBar.hidden= NO;
    theDataObject.beliefScore = 0;
    [self.questionLabel setText:@"It is extremely likely that I will get colorectal cancer."];
    [self labelAppear];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)labelAppear{
    
    [UIView animateWithDuration:0.2
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
-(void)labelDisappear{
    NSLog(@"The score is %d Count is %d", theDataObject.beliefScore, theDataObject.questionCount);
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         [self.questionLabel setAlpha:0.0];
     }
                     completion:^(BOOL finished)
     {
         if(finished){
             
             if(theDataObject.questionCount == 1){
                 [self.questionLabel setText:@"Developing colorectal cancer is currently a possibility for me."];
             }
             else if(theDataObject.questionCount == 2){
                 self.questionBar.hidden = YES;
                 [self.questionLabel setText:@"Colorectal cancer is a hopeless disease."];
             }
             else if(theDataObject.questionCount == 3){
                 [self.questionLabel setText:@"I am afraid to have colorectal cancer screening because I do not understand what will be done in the test."];
             }
             else if(theDataObject.questionCount == 4){
                 [self.questionLabel setText:@"Doing a FOBT is embarrassing."];
             }
             else if(theDataObject.questionCount == 5){
                 [self.questionLabel setText:@"Having a colonoscopy is embarrassing."];
             }
             else if(theDataObject.questionCount == 6){
                 [self.questionLabel setText:@"Colorectal cancer screening is embarrassing."];
             }
             else if(theDataObject.questionCount == 7){
                 [self.questionLabel setText:@"Having colorectal cancer screening would take too much time."];
             }
             else if(theDataObject.questionCount == 8){
                 [self.questionLabel setText:@"I cannot remember to schedule an appointment for a colonoscopy."];
             }
             
             [self labelAppear];
         }
     }];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%d",theDataObject.questionCount);
    if ([identifier isEqualToString:@"next4"]&& theDataObject.questionCount < 8) {
        NSLog(@"dksfkldsf");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please finish the questions first."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    else{
        NSLog(@"dfdsf");
        return YES;
    }
}
- (IBAction)pressYes:(id)sender {
    if(theDataObject.questionCount == 1){
        lastPoint = 0;
    }
    else{
        lastPoint = 1;
    }
    [self performSelector:@selector(toggleButton1:) withObject:sender afterDelay:0];
    
    
}
- (IBAction)pressNo:(id)sender {
    if(theDataObject.questionCount == 1){
        lastPoint = 1;
    }
    else{
        lastPoint = 0;
    }
    
    [self performSelector:@selector(toggleButton2:) withObject:sender afterDelay:0];
}

- (IBAction)nextButton:(id)sender {
    
    NSLog(@"question count %d",theDataObject.questionCount);
    [self performSegueWithIdentifier: @"next4" sender:self];
    
}

- (IBAction)previousButton:(id)sender {
    if (theDataObject.questionCount== 0) {
        theDataObject.questionCount= 1;
        theDataObject.beliefScore = 0;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"This is the first question."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSLog(@"Subtract risk count: %d, Score: %d ",theDataObject.riskCount, lastPoint);
    lastPoint =  [[myDictionary objectForKey:[NSString stringWithFormat:@"%d",theDataObject.questionCount]] intValue];
    theDataObject.beliefScore -= lastPoint;
    
    if (theDataObject.questionCount > 0 ) {
        theDataObject.questionCount -=1;
    }
    
    [self recoverButtons];
    [self labelDisappear];
    
}

- (IBAction)nextQuestionButton:(id)sender {
    
    [myDictionary setObject:[NSString stringWithFormat:@"%d",lastPoint] forKey:[NSString stringWithFormat:@"%d",theDataObject.questionCount]];
    NSLog(@"set score %@ to risk count %d",[myDictionary objectForKey:[NSString stringWithFormat:@"%d",theDataObject.questionCount]] , theDataObject.questionCount);
    
    
    if(!yesSelected && !noSelected ){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please select an option."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(theDataObject.beliefScore == 0 && theDataObject.questionCount >= 8){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Wonderful news! You are ready to get screened for colorectal cancer. Please click Next to continue."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if(theDataObject.beliefScore > 0 && theDataObject.questionCount >= 8){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Many people have the same thoughts as you about colorectal cancer screening and still get screened. Most cancer survivors are colorectal cancer survivors.  There should be nothing embarrassing or too time consuming about finding colorectal cancer when it is most treatable. This app will provide you with some of the information you need to understand colorectal cancer screening."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
        
        return;
        
        
    }
    if (theDataObject.questionCount > 0 ) {
        theDataObject.questionCount +=1;
    }
    
    [self recoverButtons];
    [self labelDisappear];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Please click Next to continue."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
- (void)viewDidUnload {
    
    [self setQuestionBar:nil];
    [self setYesButton:nil];
    [self setNoButton:nil];
    [super viewDidUnload];
}
-(void)toggleButton1:(UIButton*)b{
    if(!yesSelected){
        b.highlighted = YES;
        yesSelected= YES;
        if(noSelected){
            [self performSelector:@selector(pressNo:) withObject:self.noButton afterDelay:0];
        }
        theDataObject.beliefScore += lastPoint;
    }
    else{
        b.highlighted = NO;
        yesSelected = NO;
        theDataObject.beliefScore -= lastPoint;
    }
}
-(void)toggleButton2:(UIButton*)b{
    if(!noSelected){
        b.highlighted = YES;
        noSelected= YES;
        if(yesSelected){
            [self performSelector:@selector(pressYes:) withObject:self.yesButton afterDelay:0];
        }
        
        theDataObject.beliefScore += lastPoint;
    }
    else{
        b.highlighted = NO;
        noSelected = NO;
        theDataObject.beliefScore -= lastPoint;
    }
}
-(void)recoverButtons{
    
    self.noButton.highlighted=NO;
    self.yesButton.highlighted = NO;
    yesSelected = NO;
    noSelected = NO;
}
@end
