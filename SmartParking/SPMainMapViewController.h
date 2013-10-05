//
//  SPMainMapViewController.h
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SPAppDelegate.h"
@interface SPMainMapViewController: UIViewController <UIActionSheetDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UIPickerViewDelegate, UIPickerViewDataSource>{
    CLLocationManager *locationManager;
    NSTimer *fsmTimer;
    NSTimer *cTimer;
    NSTimer *gpsTimer;
    NSTimer *timeoutTimer;
    NSTimer *waitTimer;
    IBOutlet UISearchBar *sBar;
    NSManagedObjectContext *managedObjectContext;
    MKCircle *radiusOverlay;
    MKCircle *closeRadiusOverlay;
    UIBackgroundTaskIdentifier bgTask ;
    float time;
    NSString *timestr;
    NSTimer* pollingTimer;
    NSTimer *FarAwaytimer;
    NSTimer *NoSpottimer;
    ExampleAppDataObject* theDataObject;
}
-(void)setFsmTimer:(NSTimer *)fsmTimer;
-(void)startGps;
-(void)isClose;
-(void)writeToCoreData:(NSString *) address;
-(NSString *) writeNotificationMessage:(NSString *)deviceuid;
-(NSString *) writeAPNSMessage:(NSString *)clientid Arg2:(NSString *)deviceuid;
-(void)setFSMInterval:(float) theTime;
-(void)setWaitInterval:(float) theTime;
-(void)setRegionTimer:(float) theTime;
-(void)cancelSpot:(NSString *)userID;
-(void)dropPinDestination:(NSString *)address;
-(void)initActivityIndicator;
-(void)cancelUserState;
-(void)fireNotification:(int) notificationIndex;

- (IBAction)backButton:(id)sender;
//- (IBAction)logoutButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)parkingButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

//-(void)setSPMethod:(NSString *)method;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic)  UIBackgroundTaskIdentifier bgTask ;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIPickerView *pickDestination;
@property (nonatomic, retain) NSArray *pickerViewArray;
@property (nonatomic, retain) NSArray *addressArray;
@property (strong,nonatomic) SPAppDelegate *myDelegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *parkingButton;
@property (weak, nonatomic) IBOutlet UIToolbar *topToolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *infoBar;
- (IBAction)tutorialButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
 
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSTimer *fsmTimer;
@property (nonatomic) NSTimer *cTimer;
//@property (nonatomic) NSTimer *gpsTimer;
@property (nonatomic) NSTimer *timeoutTimer;
@property (nonatomic) NSTimer *waitTimer;
@property (nonatomic) NSString *method;
@property (nonatomic) NSString *address;
@end
