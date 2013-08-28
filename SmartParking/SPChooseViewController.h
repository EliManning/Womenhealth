//
//  SPChooseViewController.h
//  SmartParking
//
//  Created by smart_parking on 1/30/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPKeychainItem.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface SPChooseViewController : UIViewController{
    SPKeychainItem *keychain;
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *indicatorSubview;
- (IBAction)buttonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *statusBar;


- (IBAction)logoutButton:(id)sender;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
