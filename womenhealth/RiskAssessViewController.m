//
//  RiskAssessViewController.m
//  womenhealth
//
//  Created by smart_parking on 6/22/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "RiskAssessViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface RiskAssessViewController ()

@end

@implementation RiskAssessViewController{
    BOOL firstSelected;
    BOOL secondSelected;
    BOOL thirdSelected;
    BOOL fourthSelected;
    BOOL fifthSelected;
    NSInteger newAssessScore;
    NSInteger lastAssessScore;
    NSMutableDictionary *myDictionary;
    NSHashTable *hashTable;
    NSMutableArray *myArr;
}
@synthesize questionBar;
@synthesize pickerView = _pickerView;
@synthesize pickerViewArray = _pickerViewArray;
@synthesize ageField = _ageField;

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

    if(!theDataObject.riskCount || !theDataObject.riskScore){
        theDataObject.riskCount = 1;
        theDataObject.riskScore = 0;
    }
    [self createPicker];
  
    NSLog(@"Count: %d, Score: %d",theDataObject.riskCount,theDataObject.riskScore);
    self.firstButton.hidden =YES;
    self.secondButton.hidden=YES;
    self.thirdButton.hidden=YES;
    self.fourthButton.hidden=YES;
    self.fifthButton.hidden=YES;
    self.ageField.hidden = YES;
    theDataObject.riskAssessFinished = NO;
    theDataObject.riskCount = 1;
    theDataObject.riskScore = 0;
    newAssessScore = 0;
    myDictionary = [[NSMutableDictionary alloc]init];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: @"Before you can decide on the best colorectal cancer screening for you, you must know your risk for colorectal cancer.  Most people are at average risk. But others are at increased risk due to factors like family history, genetics, and environment to name a few. By taking this assessment, you will know your risk for colorectal cancer."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //[self createPicker];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)labelDisappear{
    
      ExampleAppDataObject* theDataObject = [self theAppDataObject];
    // NSLog(@"Count: %d, Score: %d",theDataObject.riskCount,theDataObject.riskScore);
    lastAssessScore = theDataObject.riskScore;
           [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         [self.questionBar setAlpha:1.0];
     }
                     completion:^(BOOL finished)
     {
         if(finished){
          //   NSLog(@"Label fade out");
            
             if(theDataObject.riskCount == 1){
                 [self.questionBar setText:@"Select your race/ethnicity "];
                //[self.firstButton setTitle:@"Next" forState:UIControlStateNormal];
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;
                 self.thirdButton.hidden = YES;
                 self.secondButton.hidden = YES;
                 self.firstButton.hidden = YES;
             }
             else if(theDataObject.riskCount== 2){
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;
                 self.thirdButton.hidden = YES;
                 self.secondButton.hidden = YES;
                 self.firstButton.hidden = YES;
                 self.pickerView.hidden = YES;
                 self.ageField.hidden = NO;
                 [[self ageField]becomeFirstResponder];
                 [self.questionBar setText:@"How old are you? "];
                 
             }
             else if(theDataObject.riskCount== 3){
                 [[self ageField]resignFirstResponder];

                 [self.questionBar setText:@"In the past 10 years, have you had a colonoscopy?"];
                 [self.firstButton setTitle:@"YES" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"NO" forState:UIControlStateNormal];
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;
                 self.thirdButton.hidden = YES;
                 self.pickerView.hidden = YES;
                 self.secondButton.hidden = NO;
                 self.firstButton.hidden= NO;
                 self.ageField.hidden = YES;
             }
             else if(theDataObject.riskCount== 4){
                 [self.questionBar setText:@"In the past 10 years did a healthcare provider tell you that you had a polyp in your colon or rectum? "];
             }
             else if(theDataObject.riskCount== 5){
                 [self.questionBar setText:@"In the past 1-2 years, have you had a Fecal occult blood test (FOBT)? "];
                 self.thirdButton.hidden = YES;
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;
                 [self.firstButton setTitle:@"YES" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"NO" forState:UIControlStateNormal];
                
         
             }
             else if(theDataObject.riskCount== 6){
                 [self.questionBar setText:@"Have you had any of the following? Select all that apply."];
                 self.thirdButton.hidden = NO;
                 self.fourthButton.hidden = NO;
                 self.fifthButton.hidden = NO;
                 [self.firstButton setTitle:@"Colorectal cancer " forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"Ovarian cancer" forState:UIControlStateNormal];
                 [self.thirdButton setTitle:@"Uterine cancer " forState:UIControlStateNormal];
                 [self.fourthButton setTitle:@"Breast cancer" forState:UIControlStateNormal];
                 [self.fifthButton setTitle:@"None of the above" forState:UIControlStateNormal];
                 [self.firstButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                 [self.secondButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                 [self.thirdButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                 [self.fourthButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                 [self.fifthButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
             }
             else if(theDataObject.riskCount== 7){
                 [self.questionBar setText:@"Do you still have periods?"];
                 [self.firstButton setTitle:@"YES" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"NO" forState:UIControlStateNormal];
                 self.thirdButton.hidden = YES;
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;
             }
             
             else if(theDataObject.riskCount== 8){
                 [self.questionBar setText:@"During the past 2 years, have you used estrogen, progestin, or other female hormones? "];
             }
             else if(theDataObject.riskCount== 9){
                 [self.questionBar setText:@"Has a healthcare provider ever told you that you have ulcerative or crohn colitis? "];
             }
             else if(theDataObject.riskCount== 10){
                 [self.questionBar setText:@"Has a close relative (parent, siblings or children) had colorectal cancer? "];
             }
             else if(theDataObject.riskCount== 11){
                 [self.questionBar setText:@"During the past 30 days, have you taken aspirin, Bufferin, Bayer or Excedrin at least 3 times a week? "];
             }
             else if(theDataObject.riskCount== 12){
                 [self.questionBar setText:@"During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen or Nuprin at least 3 times a week?"];
                 self.thirdButton.hidden = YES;
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;
             }
             else if(theDataObject.riskCount== 13){
                 [self.questionBar setText:@"How many hours per week do you exercise vigorously (enough to cause sweating and heavy breathing)? "];
                 [self.firstButton setTitle:@"0" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"1-3" forState:UIControlStateNormal];
                 [self.thirdButton setTitle:@"4 or more" forState:UIControlStateNormal];
                 self.thirdButton.hidden = NO;
                 
             }
             else if(theDataObject.riskCount== 14){
                 [self.questionBar setText:@"How many servings per day of vegetables or leafy salad greens do you eat? Do not include potatoes, french fries or fried potatoes"];
                 [self.firstButton setTitle:@"0-2" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"3-5" forState:UIControlStateNormal];
                 [self.thirdButton setTitle:@"6 or more" forState:UIControlStateNormal];
                 self.thirdButton.hidden = NO;
             }
             else if(theDataObject.riskCount== 15){
                 [self.questionBar setText:@"How many cigarettes do you smoke every day?"];
                 [self.firstButton setTitle:@"0" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"1-10" forState:UIControlStateNormal];
                 [self.thirdButton setTitle:@"11-19" forState:UIControlStateNormal];
                 [self.fourthButton setTitle:@"20 or more" forState:UIControlStateNormal];
                 self.thirdButton.hidden = NO;
                 self.fourthButton.hidden = NO;
             }
             else if(theDataObject.riskCount== 16){
                 [self.questionBar setText:@"Has your health care provider told you that you are obese and need to lose more than 10 pounds? "];
                 [self.firstButton setTitle:@"YES" forState:UIControlStateNormal];
                 [self.secondButton setTitle:@"NO" forState:UIControlStateNormal];
                 self.thirdButton.hidden = YES;
                 self.fourthButton.hidden = YES;
                 self.fifthButton.hidden = YES;

             }
            
           
         }
     }];
    NSLog(@"You enter count: %d, your current score: %d",theDataObject.riskCount,theDataObject.riskScore);

}
-(void)recoverButtons{

    [self.firstButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.secondButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.thirdButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.fourthButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.fifthButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    self.firstButton.highlighted=NO;
    self.secondButton.highlighted = NO;
    self.thirdButton.highlighted = NO;
    self.fourthButton.highlighted= NO;
    self.fifthButton.highlighted = NO;
    firstSelected = NO;
    secondSelected = NO;
    thirdSelected = NO;
    fourthSelected = NO;
    fifthSelected = NO;
    self.firstButton.enabled=YES;
    self.secondButton.enabled = YES;
    self.thirdButton.enabled = YES;
    self.fourthButton.enabled= YES;
    self.fifthButton.enabled = YES;
}
/*
-(void)labelAppear{
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         [self.questionBar setAlpha:1.0];
     }
                     completion:^(BOOL finished)
     {
         if(finished)
             NSLog(@"Label fade in");
     }];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuestionBar:nil];
    [self setPickerView:nil];
    [self setFirstButton:nil];
    [self setSecondButton:nil];
    [self setThirdButton:nil];
    [self setFourthButton:nil];
    [self setFifthButton:nil];
    [self setAgeField:nil];
    [self setAgeField:nil];
    [self setNextArrow:nil];
    [self setPreviousArrow:nil];
    [super viewDidUnload];
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
- (IBAction)previousArrowPressed:(id)sender {
    [self recoverButtons];
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.riskCount -=1;
    lastAssessScore = [[myDictionary objectForKey:[NSString stringWithFormat:@"%d",theDataObject.riskCount]] intValue];
    NSLog(@"Subtract risk count: %d, Score: %d ",theDataObject.riskCount, lastAssessScore);
    theDataObject.riskScore -= lastAssessScore;
    if(theDataObject.riskCount == 1){
        int selectedIndex = [self.pickerView selectedRowInComponent:0];
        NSString *e = [self.pickerViewArray objectAtIndex:selectedIndex];
        theDataObject.userEthnicity = e;
        self.ageField.hidden = YES;
        [self.ageField resignFirstResponder];
        self.pickerView.hidden=NO;
 
    }
    
    else if (theDataObject.riskCount<1) {
       
        theDataObject.riskCount =1;
        theDataObject.riskScore = 0;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"This is the first question."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self labelDisappear];
}

- (IBAction)nextArrowPressed:(id)sender {
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(theDataObject.riskCount!=1 && theDataObject.riskCount!=2 && !firstSelected && !secondSelected && !thirdSelected && !fourthSelected & !fifthSelected){
       UIAlertView *alert = [[UIAlertView alloc]
                             initWithTitle: @""
                             message: @"Please select an option."
                             delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
      [alert show];
      return;
    }
    if(theDataObject.riskCount == 1){
        int selectedIndex = [self.pickerView selectedRowInComponent:0];
        NSString *e = [self.pickerViewArray objectAtIndex:selectedIndex];
        theDataObject.userEthnicity = e;
    }
    
    else if(theDataObject.riskCount == 2){
        if(([self.ageField.text length]==0)||([self.ageField.text intValue]>100)){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Please enter a valid number."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }

        else{
            theDataObject.userage = [self.ageField.text integerValue];
        }
    }
    lastAssessScore = theDataObject.riskScore - lastAssessScore;
    NSLog(@"Last score is %d", lastAssessScore);
    [myDictionary setObject:[NSString stringWithFormat:@"%d",lastAssessScore] forKey:[NSString stringWithFormat:@"%d",theDataObject.riskCount]];
    NSLog(@"set score %@ to risk count %d",[myDictionary objectForKey:[NSString stringWithFormat:@"%d",theDataObject.riskCount]] , theDataObject.riskCount);

    if (theDataObject.riskCount<16) {
         theDataObject.riskCount +=1;
        [self recoverButtons];

    }
    else{
        theDataObject.riskAssessFinished = YES;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Last question. Please click Next to continue."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    [self labelDisappear];
}

- (IBAction)firstButtonPressed:(id)sender {
 
    ExampleAppDataObject* theDataObject = [self theAppDataObject];

    if (theDataObject.riskCount == 8 || theDataObject.riskCount == 9 || theDataObject.riskCount == 10  || theDataObject.riskCount == 14 || theDataObject.riskCount == 16 ) {
        newAssessScore = 1;
 
    }
    else if(theDataObject.riskCount == 13 ){
               newAssessScore = 2;
    }
    else if(theDataObject.riskCount == 6 ){
        newAssessScore = 100;
    }
    else{
        newAssessScore = 0;
        
    }
      [self performSelector:@selector(toggleButton1:) withObject:sender afterDelay:0];

}

- (IBAction)secondButtonPressed:(id)sender {
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    //theDataObject.riskScore -= newAssessScore;
    if (theDataObject.riskCount == 8 || theDataObject.riskCount == 9 || theDataObject.riskCount == 10  || theDataObject.riskCount == 16 ) {
        newAssessScore = 0;
    }
    else if(theDataObject.riskCount == 14 ){
        newAssessScore = 2;
    }
    else{
        newAssessScore = 1;
       
    }

    [self performSelector:@selector(toggleButton2:) withObject:sender afterDelay:0];  

}

- (IBAction)thirdButtonPressed:(id)sender {
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if (theDataObject.riskCount == 13 || theDataObject.riskCount == 6 ) {
        newAssessScore = 1;
    }
    else if (theDataObject.riskCount == 14) {
        newAssessScore = 3;
    }
    else if (theDataObject.riskCount == 15) {
        newAssessScore = 2;
    }
    else{
        newAssessScore = 0;
    }
   /*
    if(!thirdSelected)
        theDataObject.riskScore += newAssessScore;
    else
        theDataObject.riskScore -= newAssessScore;
*/
    [self performSelector:@selector(toggleButton3:) withObject:sender afterDelay:0];

    
}

- (IBAction)fourthButtonPressed:(id)sender {
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if (theDataObject.riskCount == 15 ) {
        newAssessScore =3;
    }
    else{
        newAssessScore = 1;
    }

   
    [self performSelector:@selector(toggleButton4:) withObject:sender afterDelay:0];

}
- (IBAction)fifthButtonPressed:(id)sender {
    ExampleAppDataObject* theDataObject = [self theAppDataObject];

        newAssessScore = 1;
        if(firstSelected){
        theDataObject.riskScore -= newAssessScore;
        [self.firstButton setHighlighted:NO];
        firstSelected = NO;
        }
        if(secondSelected){
        theDataObject.riskScore -= newAssessScore;
        [self.secondButton setHighlighted:NO];
        secondSelected = NO;
        }
        if(thirdSelected){
        theDataObject.riskScore -= newAssessScore;
        [self.thirdButton setHighlighted:NO];
        thirdSelected = NO;
        }
        if(fourthSelected){
        theDataObject.riskScore -= newAssessScore;
        [self.fourthButton setHighlighted:NO];
        fourthSelected = NO;
        }
        [self performSelector:@selector(toggleButton5:) withObject:sender afterDelay:0];
        NSLog(@"5 After Count: %d, Score: %d, last point %d",theDataObject.riskCount,theDataObject.riskScore, newAssessScore);


}

-(void)toggleButton1:(UIButton*)b{
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(!firstSelected){
        b.highlighted = YES;
        firstSelected= YES;
        if(theDataObject.riskCount!=6){
            if(secondSelected){
                [self performSelector:@selector(secondButtonPressed:) withObject:self.secondButton afterDelay:0];
            }
            if(thirdSelected){
                [self performSelector:@selector(thirdButtonPressed:) withObject:self.thirdButton afterDelay:0];
            }
            if(fourthSelected){
                [self performSelector:@selector(fourthButtonPressed:) withObject:self.fourthButton afterDelay:0];
            }
        }
          theDataObject.riskScore += newAssessScore;
           }
    else{
        b.highlighted = NO;
        firstSelected = NO;
        theDataObject.riskScore -= newAssessScore;
    }
}
-(void)toggleButton2:(UIButton*)b{
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(!secondSelected){
        b.highlighted = YES;
        secondSelected= YES;
         if(theDataObject.riskCount!=6){
             if(firstSelected){
                 [self performSelector:@selector(firstButtonPressed:) withObject:self.firstButton afterDelay:0];
             }
             if(thirdSelected){
                 [self performSelector:@selector(thirdButtonPressed:) withObject:self.thirdButton afterDelay:0];
             }
             if(fourthSelected){
                 [self performSelector:@selector(fourthButtonPressed:) withObject:self.fourthButton afterDelay:0];
             }
         }
        theDataObject.riskScore += newAssessScore;
    }
    else{
        b.highlighted = NO;
        secondSelected = NO;
        theDataObject.riskScore -= newAssessScore;
    }
}
-(void)toggleButton3:(UIButton*)b{
     ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(!thirdSelected){
        b.highlighted = YES;
        thirdSelected= YES;
        if(theDataObject.riskCount!=6){
            if(firstSelected){
                [self performSelector:@selector(firstButtonPressed:) withObject:self.firstButton afterDelay:0];
            }
            if(secondSelected){
                [self performSelector:@selector(secondButtonPressed:) withObject:self.secondButton afterDelay:0];
            }
            if(fourthSelected){
                [self performSelector:@selector(fourthButtonPressed:) withObject:self.fourthButton afterDelay:0];
            }
        }
        theDataObject.riskScore += newAssessScore;

    }
    else{
        b.highlighted = NO;
        thirdSelected = NO;
        theDataObject.riskScore -= newAssessScore;

    }
}
-(void)toggleButton4:(UIButton*)b{
     ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(!fourthSelected){
        b.highlighted = YES;
        fourthSelected= YES;
        if(theDataObject.riskCount!=6){
            if(firstSelected){
                [self performSelector:@selector(firstButtonPressed:) withObject:self.firstButton afterDelay:0];
            }
            if(thirdSelected){
                [self performSelector:@selector(thirdButtonPressed:) withObject:self.thirdButton afterDelay:0];
            }
            if(secondSelected){
                [self performSelector:@selector(secondButtonPressed:) withObject:self.secondButton afterDelay:0];
            }
        }
        theDataObject.riskScore += newAssessScore;
    }
    else{
        b.highlighted = NO;
        fourthSelected= NO;
        theDataObject.riskScore -= newAssessScore;

    }
}
-(void)toggleButton5:(UIButton*)b{
 
    if(!fifthSelected){
        b.highlighted = YES;
        fifthSelected= YES;
        NSLog(@"highlight");
        [self.firstButton setEnabled:NO];
         [self.secondButton setEnabled:NO];
         [self.thirdButton setEnabled:NO];
         [self.fourthButton setEnabled:NO];
    }
    else{
        b.highlighted = NO;
        fifthSelected= NO;
         NSLog(@"no highlight");
        [self.firstButton setEnabled:YES];
        [self.secondButton setEnabled:YES];
        [self.thirdButton setEnabled:YES];
        [self.fourthButton setEnabled:YES];
       
    }
}


- (IBAction)nextButton:(id)sender {
 
        [self performSegueWithIdentifier: @"nextzero" sender:self];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"sada");
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    
    if ([identifier isEqualToString:@"nextzero"]&& !theDataObject.riskAssessFinished) {
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
-(void)createPicker{
  //  ExampleAppDataObject* theDataObject = [self theAppDataObject];

    
    NSArray *arrayToLoadPicker = [[NSArray alloc] initWithObjects:@"African American/Black",@"Caucasian",nil];
    self.pickerViewArray = arrayToLoadPicker;
    self.pickerView.delegate=self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator=YES;
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerViewArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewArray objectAtIndex:row];
}

@end