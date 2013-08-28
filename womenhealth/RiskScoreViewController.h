//
//  RiskScoreViewController.h
//  womenhealth
//
//  Created by smart_parking on 6/24/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface RiskScoreViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *riskResultBar;
- (IBAction)notifyLater:(id)sender;
- (IBAction)nextButton:(id)sender;

@end
