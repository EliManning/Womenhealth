//
//  QuestionOneViewController.h
//  womenhealth
//
//  Created by smart_parking on 5/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionOneViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *questionBar;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
- (IBAction)pressYes:(id)sender;
- (IBAction)pressNo:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)previousButton:(id)sender;
- (IBAction)nextQuestionButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *yesButton;

@property (strong, nonatomic) IBOutlet UIButton *noButton;

@end
