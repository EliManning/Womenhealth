//
//  SPsettingsViewController.h
//  SmartParking
//
//  Created by smart_parking on 2/5/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPsettingsViewController : UITableViewController
@property (nonatomic, retain, readonly) UISlider *sliderCtl;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@end
