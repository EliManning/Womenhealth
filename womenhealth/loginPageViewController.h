//
//  loginPageViewController.h
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginButton:(id)sender;
@property (copy, nonatomic) NSString *userNameStr;
@property (copy, nonatomic) NSString *passWordStr;
@end
