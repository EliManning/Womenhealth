//
//  SPUpdateInfoViewController.h
//  smartparking
//
//  Created by smart_parking on 2/28/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPUpdateInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernametxt;
@property (weak, nonatomic) IBOutlet UITextField *newpwtxt;
@property (weak, nonatomic) IBOutlet UITextField *oldpwtxt;
@property (weak, nonatomic) IBOutlet UITextField *newplatetxt;
- (IBAction)confirmButton:(id)sender;

@end
