//
//  SPSignUpViewController.h
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPKeychainItem.h"

@interface SPSignUpViewController : UIViewController{
    SPKeychainItem *keychain;
}

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *passWord;
@property (copy, nonatomic) NSString *confirmedePassWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
- (IBAction)submit:(id)sender;
@end
