//
//  QuestionTwoViewController.h
//  womenhealth
//
//  Created by smart_parking on 5/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTwoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIButton *YesButton;
@property (strong, nonatomic) IBOutlet UIButton *NoButton;
@property (strong, nonatomic) IBOutlet UIButton *DontKnowButton;
- (IBAction)pressYes:(id)sender;
- (IBAction)pressNo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *undoButton;
- (IBAction)pressDontKnow:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)previousButton:(id)sender;
- (IBAction)nextQuestionButton:(id)sender;

@end
