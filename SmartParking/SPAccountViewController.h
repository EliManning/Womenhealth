//
//  SPAccountViewController.h
//  SmartParking
//
//  Created by smart_parking on 2/9/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *username;
//@property (weak, nonatomic) IBOutlet UILabel *make;

//@property (weak, nonatomic) IBOutlet UILabel *model;
//@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *plate;
@property (weak, nonatomic) IBOutlet UILabel *resvFee;
@property (weak, nonatomic) IBOutlet UILabel *parkFee;
@property (weak, nonatomic) IBOutlet UILabel *resvTime;
@property (weak, nonatomic) IBOutlet UILabel *parkTime;
@property (weak, nonatomic) IBOutlet UILabel *arriveTime;
@property (weak, nonatomic) IBOutlet UILabel *accountBalance;
@end
