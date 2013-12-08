//
//  FirstChoiceViewController.h
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstChoiceViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *fobtButtton;
@property (strong, nonatomic) IBOutlet UIButton *colonButton;
- (IBAction)fobtButton:(id)sender;
- (IBAction)colonButton:(id)sender;
- (IBAction)nextButton:(id)sender;

@end
