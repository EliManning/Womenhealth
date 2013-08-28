//
//  ResultViewController.h
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *fobtResult;
@property (strong, nonatomic) IBOutlet UILabel *colonResult;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)clearButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)backToFirstPage:(id)sender;
- (IBAction)logoutButton:(id)sender;
- (IBAction)submitButton:(id)sender;

@end
