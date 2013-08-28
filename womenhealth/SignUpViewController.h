//
//  SignUpViewController.h
//  womenhealth
//
//  Created by smart_parking on 5/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *passWord;
@property (copy, nonatomic) NSString *confirmedePassWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
- (IBAction)submit:(id)sender;

@end
