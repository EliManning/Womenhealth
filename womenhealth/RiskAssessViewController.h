//
//  RiskAssessViewController.h
//  womenhealth
//
//  Created by smart_parking on 6/22/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
#import <QuartzCore/QuartzCore.h>
@interface RiskAssessViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIPickerView *pickerView;
    NSArray *pickerViewArray;
}

@property (strong, nonatomic) IBOutlet UILabel *questionBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *pickerViewArray;
@property (strong, nonatomic) IBOutlet UIButton *firstButton;
@property (strong, nonatomic) IBOutlet UIButton *secondButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdButton;
@property (strong, nonatomic) IBOutlet UIButton *fourthButton;
@property (strong, nonatomic) IBOutlet UIButton *fifthButton;
@property (strong, nonatomic) IBOutlet UIButton *nextArrow;
@property (strong, nonatomic) IBOutlet UIButton *previousArrow;
- (IBAction)previousArrowPressed:(id)sender;
- (IBAction)nextArrowPressed:(id)sender;
- (IBAction)firstButtonPressed:(id)sender;
- (IBAction)secondButtonPressed:(id)sender;
- (IBAction)thirdButtonPressed:(id)sender;
- (IBAction)fourthButtonPressed:(id)sender;
- (IBAction)fifthButtonPressed:(id)sender;
- (IBAction)nextButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ageField;


@end
