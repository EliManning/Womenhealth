//
//  SPLoginViewController.h
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPKeychainItem.h"
@interface SPLoginViewController : UIViewController{
     SPKeychainItem *keychain;
}
- (IBAction)loginClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;

@property (copy, nonatomic) NSString *userNameStr;
@property (copy, nonatomic) NSString *passWordStr;
@end
