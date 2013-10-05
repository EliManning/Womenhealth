//
//  smart_parkingViewController.m
//  map_annotation
//
//  Created by smart_parking on 1/2/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//
#define allowAssignDistance			   2000000000000000
#define closeDetectDistance            500
#import "SPMainMapViewController.h"
#import "SPDestAnnotation.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "SPPinAnnotation.h"
#import "SPHistoryRecordView.h"
//#import "CustomAnnotationView.h"
#import "Event.h"
#import <dispatch/dispatch.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AddressBook/AddressBook.h>
#import <MapKit/MapKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
enum
{
    //
    annotationIndex=0,
    destIndex=1,
};
static int distance = 0;

@interface SPMainMapViewController ()
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end


@implementation SPMainMapViewController{
    NSMutableArray *_mapAnnotations;    
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@synthesize activityIndicator=_activityIndicator;
@synthesize infoBar = _infoBar;
@synthesize cancelButton = _cancelButton;
@synthesize topToolBar = _topToolBar;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize fsmTimer = _fsmTimer;
@synthesize cTimer = _cTimer;
@synthesize parkingButton = _parkingButton;
@synthesize pickDestination = _pickDestination;
@synthesize pickerViewArray= _pickerViewArray;
@synthesize addressArray = _addressArray;
@synthesize method = _method;
@synthesize myDelegate = _myDelegate;
@synthesize managedObjectContext;
@synthesize address = _address;
//@synthesize gpsTimer = _gpsTimer;
@synthesize timeoutTimer = _timeoutTimer;
@synthesize waitTimer = _waitTimer;
@synthesize backButton = _backButton;
@synthesize timerLabel = _timerLabel;


- (NSMutableArray*) mapAnnotations{
    if(!_mapAnnotations){
        _mapAnnotations=[NSMutableArray new];
    }
    return _mapAnnotations;
}
+ (int)distance {
    return distance;
}
+ (void)setDistance:(int)newDistance {
    distance = newDistance;
}
+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 42.351059;
    newRegion.center.longitude = -71.106803;
    newRegion.span.latitudeDelta = 0.102872;
    newRegion.span.longitudeDelta = 0.099863;
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Enter Region.");
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"didExitRegion");
}

-(void)gotoPinLocation:(CLLocationCoordinate2D) pinCoord
{
     MKCoordinateRegion newRegion;
    newRegion.center.latitude = pinCoord.latitude;
    newRegion.center.longitude =pinCoord.longitude;
    newRegion.span.latitudeDelta = 0.0062872;
    newRegion.span.longitudeDelta = 0.0059986;
    [self.mapView setRegion:newRegion animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{

    [self startGps];
    [self getParkingState];
    
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelAllStates];
    [super viewWillDisappear:animated];
}

-(void)cancelAllStates{

        [locationManager stopUpdatingLocation];
        [locationManager stopMonitoringSignificantLocationChanges];
        [locationManager setDelegate:nil];

    [theDataObject.fsmTimer invalidate];
    theDataObject.fsmTimer = nil;
    [self.cTimer invalidate];
    self.cTimer = nil;
    [gpsTimer invalidate];
    gpsTimer = nil;
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    [self.waitTimer invalidate];
    self.waitTimer = nil;
    [FarAwaytimer invalidate];
    FarAwaytimer =nil;
    [NoSpottimer invalidate];
    NoSpottimer = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
 
    return toInterfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
}
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our three custom annotations
    //
    if ([annotation isKindOfClass:[parkingAnnotation class]]) 
    {
        // try to dequeue an existing pin view first

      static NSString *BridgeAnnotationIdentifier = @"parkingAnnotationIdentifier";
        
       MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
         //   customPinView.canBecomeFirstResponder = YES;
            customPinView.selected = YES;
         //   customPinView.
           // customPinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iphone_settings_icon.png"]];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
           // UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            [rightButton addTarget:self
                            action:@selector(actionSheetAppearForParking)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
        
    }
    else if ([annotation isKindOfClass:[destAnnotation class]])
    {
        // try to dequeue an existing pin view first
        
        static NSString *DestAnnotationIdentifier = @"destAnnotationIdentifier";
        
        MKPinAnnotationView *pView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:DestAnnotationIdentifier];
        if (pView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *cPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:DestAnnotationIdentifier];
            cPinView.pinColor = MKPinAnnotationColorRed;
            cPinView.animatesDrop = YES;
            cPinView.canShowCallout = YES;
            //   customPinView.
            // customPinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iphone_settings_icon.png"]];
            UIButton* rButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            // UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            [rButton addTarget:self
                            action:@selector(actionSheetAppear)
               forControlEvents:UIControlEventTouchUpInside];
            cPinView.rightCalloutAccessoryView = rButton;
            
            return cPinView;
        }
        else
        {
            pView.annotation = annotation;
        }
        return pView;
        
    }
    return nil;
}
-(void)actionSheetAppearForParking{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"See Parking Map" otherButtonTitles: @"Get Direction",nil];
    [actionSheet setTag:2];
    [actionSheet showInView:self.view];
    
}
- (void)showParkingMapViewBoard {
    [theDataObject.fsmTimer invalidate];
    theDataObject.fsmTimer =nil;
    UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"parkingMapBoard"];
    [self.navigationController pushViewController:manuView animated:YES];
  
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location. Please check your location services in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)viewDidLoad
{
 
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    self.myDelegate = (SPAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.mapView.delegate = self;
    geocoder = [[CLGeocoder alloc] init];
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
    parkingAnnotation *pAnnotation = [[parkingAnnotation alloc] init];
    [self.mapAnnotations insertObject:pAnnotation atIndex:annotationIndex];
    [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:annotationIndex]];
    
    radiusOverlay = [MKCircle circleWithCenterCoordinate:pAnnotation.coordinate radius:pAnnotation.radius];
    closeRadiusOverlay = [MKCircle circleWithCenterCoordinate:pAnnotation.coordinate radius:pAnnotation.closeRadius];
    [self.mapView addOverlay:radiusOverlay level:MKOverlayLevelAboveLabels];
    [self.mapView addOverlay:closeRadiusOverlay level:MKOverlayLevelAboveLabels];
//    [self.mapView addOverlay:radiusOverlay];
//    [self.mapView addOverlay:closeRadiusOverlay];
        
        
    [self gotoLocation];
    [self setRegionTimer:0.2];
     fsmTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getFSMState) userInfo:nil repeats:NO];
  
//    });
    theDataObject = [self theAppDataObject];
    NSLog(@"condition 1 is %@",theDataObject.parkingCondition);
    [self initView];
    
  
}
- (void)imageLongPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Image Long Press");
             
    }
}
-(void)initView{
    /*
     for (UIView* view in [self.view subviews]) {
         if([view isKindOfClass:[CustomAnnotationView class]]){
             
             CustomAnnotationView *img = (CustomAnnotationView*)view;
             UILongPressGestureRecognizer *imageLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPress:)];
             [img addGestureRecognizer:imageLongPress];
             //  [img setImage:[UIImage imageNamed:@"ic_red_light.png" ]];
             img.userInteractionEnabled = YES;
             
         }
    }
*/
     NSLog(@"condition 2 is %@",theDataObject.parkingCondition);
    if(_method != nil){
        NSLog(@"segue method: %@",_method);
        theDataObject.method = _method;
    }
     NSLog(@"condition 3 is %@",theDataObject.parkingCondition);
    if(!theDataObject.requestFlag){
        NSLog(@"Set request flag %c",theDataObject.requestFlag);
        theDataObject.requestFlag = NO;
    }
     NSLog(@"condition 4 is %@",theDataObject.parkingCondition);
    if([theDataObject.method isEqualToString:@"fromHistoryToPin"]&& ([theDataObject.parkingCondition isEqualToString:@"reserved"]|| [theDataObject.parkingCondition isEqualToString:@"nearby"])){
       dispatch_async(dispatch_get_main_queue(), ^{
           UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"You have already reserved spot for former destination."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        });
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self getFSMState];
        
    });
    NSLog(@"condition is 5 %@",theDataObject.parkingCondition);
 
  
    [self resetTimerToNil];
 //   [self checkParkingCondition];
    
   // [self getParkingState];
  
    [self checkParkingCondition];
   
    if([theDataObject.parkingCondition isEqualToString:@"nearby"]){
        [self setFSMInterval:5];
    }
    else if([theDataObject.parkingCondition isEqualToString:@"reserved"]){
         [self setFSMInterval:20];
    }
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isEqual:radiusOverlay]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay] ;
		circleView.strokeColor = [UIColor purpleColor];
		circleView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.0];
		
		return circleView;
	}
    else if([overlay isEqual:closeRadiusOverlay]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay] ;
		circleView.strokeColor = [UIColor blueColor];
		circleView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.0];
		
		return circleView;
	}
	
	return nil;
}
- (void)viewDidUnload
{
    [self setTimerLabel:nil];
    [super viewDidUnload];
  // [locationManager stopUpdatingLocation];
   // [locationManager setDelegate:nil];
}
-(void)checkParkingCondition{
    NSLog(@"Check parking condition: %@",theDataObject.parkingCondition);
    if (theDataObject.destAddress != nil) {
        [self dropPinDestination:theDataObject.destAddress];
    }

    
    if([theDataObject.parkingCondition isEqualToString:@"reserved"]){
        NSString *infoBarStr = @"Your reserved spot is ";
        infoBarStr = [infoBarStr stringByAppendingFormat:@"%@",theDataObject.spot];
        self.infoBar.topItem.title = infoBarStr;
        self.bottomToolBar.hidden=NO;
        self.cancelButton.title=@"Cancel";
        self.cancelButton.enabled = YES;
        self.pickDestination.hidden = YES;
        self.parkingButton.title = @"I am nearby";
        
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords: theDataObject.destination];
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
      
    }
    else if([theDataObject.parkingCondition isEqualToString:@"nearby"]){
    
        NSString *infoBarStr = @"Your reserved spot is ";
        infoBarStr = [infoBarStr stringByAppendingFormat:@"%@",theDataObject.spot];
        self.infoBar.topItem.title = infoBarStr;
        self.bottomToolBar.hidden=NO;
        self.cancelButton.title=@"Cancel";
        self.cancelButton.enabled = YES;
        self.pickDestination.hidden = YES;
        self.parkingButton.title = @"I parked";
     //   theDataObject.confirmParkedFlag = YES;
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords: theDataObject.destination];
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
          
        
    }
    else if([theDataObject.parkingCondition isEqualToString:@"parked"]){
        
        [self cancelAllStates];
        self.bottomToolBar.hidden=YES;
        self.pickDestination.hidden = YES;
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords: theDataObject.destination];
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
       
    }
    else 
    {
        [self checkMethod];
    }

}
-(NSString *)checkMethod{
    NSLog(@"NOW check method %@",theDataObject.method);
    if([theDataObject.method isEqualToString:@"pin"]){
        self.infoBar.topItem.title = @"Press and hold on a destination";
        self.bottomToolBar.hidden=YES;
        self.pickDestination.hidden=YES;
        sBar.hidden=YES;
   
            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleLongPress:)];
            lpgr.minimumPressDuration = 0.8;
            [self.mapView addGestureRecognizer:lpgr];

    }
    else if([theDataObject.method isEqualToString:@"mark"]){
        
        self.infoBar.topItem.title = @"Select your BU destination";
        self.bottomToolBar.hidden=NO;
        self.pickDestination.hidden=NO;
        self.cancelButton.title = @"Hide";
        self.parkingButton.title = @"Select";
        self.cancelButton.enabled=YES;
        self.parkingButton.enabled = YES;
        [self createPicker];
    }
    else if([theDataObject.method isEqualToString:@"search"]){
        self.bottomToolBar.hidden=YES;
        self.pickDestination.hidden=YES;
        self.infoBar.hidden=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        
        [self.mapView addGestureRecognizer:tap];
        sBar.hidden=NO;
        [sBar becomeFirstResponder];
           }
    else if([theDataObject.method isEqualToString:@"fromHistoryToPin"]){

        self.bottomToolBar.hidden = YES;
        self.pickDestination.hidden = YES;
        NSLog(@"History record destination is %@",theDataObject.destAddress);
        [self dropPinDestination:theDataObject.destAddress];
    }


     return theDataObject.method;
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
   
    if(([theDataObject.parkingCondition isEqualToString: @"reserved"]) || ([theDataObject.parkingCondition isEqualToString: @"nearby"]) || ([theDataObject.parkingCondition isEqualToString: @"parked"])){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Sorry, you have already reserved a spot."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
   //   ExampleAppDataObject* theDataObject = [self theAppDataObject];
    @try {
        [self.mapView removeAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        NSLog(@"try");
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
         [self gotoPinLocation:touchMapCoordinate];
        NSLog(@"log:%f",touchMapCoordinate.longitude);
        NSLog(@"lat:%f",touchMapCoordinate.latitude);
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords:touchMapCoordinate];
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        theDataObject.destination = touchMapCoordinate;
    
        CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];

        distance = [self distanceBetweenCoordinates:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.administrativeArea];
                [self writeToCoreData:address];
                NSLog(@"Address %@",address);
                theDataObject.destAddress = address;
            }
            else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];

        
    }
    @catch (NSException *exception) {
        NSLog(@"catch");
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        [self gotoPinLocation:touchMapCoordinate];
        NSLog(@"log:%f",touchMapCoordinate.longitude);
        NSLog(@"lat:%f",touchMapCoordinate.latitude);
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords:touchMapCoordinate];
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        theDataObject.destination = touchMapCoordinate;
        CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        distance = [self distanceBetweenCoordinates:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.administrativeArea];
                NSLog(@"Address %@",address);
                 theDataObject.destAddress = address;
                [self writeToCoreData:address];
                }
            else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
    sBar.hidden=YES;
    self.infoBar.hidden=NO;
    self.infoBar.topItem.title=@"Press red pin to get a spot";
}
-(BOOL)allowAssignSpot{
    if (theDataObject.distance <=0 ){
        [self resetUserState];
        [self.waitTimer invalidate];
        self.waitTimer = nil;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Sorry, GPS get error. Please check the GPS settings in your phone"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return NO ;
    }
    
    if (theDataObject.distance > allowAssignDistance && theDataObject.requestFlag ){
        theDataObject.requestFlag = NO;
        [self resetTimerToNil];
        self.timerLabel.hidden = YES;
        NSString *msg = @"";
        if ([[self getCapacity] isEqualToString:@"0"]) {
        msg = @"Sorry, no parking spaces are currently available. Select Proceed below if you want to be placed in a waiting queue. You will be automatically assigned a space when one becomes available. Automatic assignment will be canceled in 10 minutes if no space is available. Otherwise, select CANCEL.";
        }
        else{
        msg = @"Sorry, you are more than 20 minutes away. There are currently ";
        msg= [msg stringByAppendingFormat:@"%@",[self getCapacity]];
        msg = [msg stringByAppendingString:@" spot available. You will be automatically assigned one and get a notification when you are within 20 minutes if you proceed to it. Automatic assignment will be canceled in 10 minutes."];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Oops" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Proceed", nil];
        [alert setTag:4];
        [alert show];
        return NO;
    }
    else if(theDataObject.distance < allowAssignDistance){
        return YES;
    }
    else{
        return NO;
    }
}
-(void)actionSheetAppear{
    
    if ([theDataObject.parkingCondition isEqualToString:@"reserved"]||[theDataObject.parkingCondition isEqualToString:@"parked"]||[theDataObject.parkingCondition isEqualToString:@"nearby"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Sorry, you have already reserved a spot. You cannot request spot at this point."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Request Spot" otherButtonTitles: @"Select Spot",nil];
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
    }

    
}
-(void)requestSpot{
    theDataObject.timeoutFlag = NO;
    [self requestSpot:theDataObject.userID destinaion:theDataObject.destination];
}
-(void)getSpot{
    NSLog(@"get spot state");
    if(![self allowAssignSpot])
        return;
  //   ExampleAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.nearbyFlag = NO;
    NSString *getSpotStr = [self getSpot:theDataObject.userID];
    NSLog(@"spot state %@", getSpotStr);
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(main,
                   ^{
            //     if([getSpotStr isEqualToString:@"waiting"]){
    if([getSpotStr isEqualToString:@"nospot"]){
        if(theDataObject.showNoSpotNotifyFlag && theDataObject.distance < allowAssignDistance){
            theDataObject.showNoSpotNotifyFlag =NO;
        [self.waitTimer invalidate];
        self.waitTimer = nil;
        self.timerLabel.hidden = YES;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        [self fireNotification:7];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Sorry, no parking spaces are currently available. Select Proceed below if you want to be placed in a waiting queue. You will be automatically assigned a space when one becomes available. Automatic assignment will be canceled in 10 minutes if no space is available. Otherwise, select CANCEL."
                              delegate: self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Proceed"
                              ,nil];
        [alert setTag:5];
        [alert show];
        }
    }
    else if([getSpotStr isEqualToString:@"waiting"]){
        if(theDataObject.distance<allowAssignDistance){
        [self requestSpot];
        }
    }
    else if([getSpotStr isEqualToString:@"confirm"]){
        /*
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"You have asked the spot."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];*/
        [self.activityIndicator stopAnimating];
        [self resetTimerToNil];
        self.backButton.enabled = YES;
        [self checkParkingCondition];
        
    }
    else if([getSpotStr integerValue]>0){
        [self.waitTimer invalidate];
        self.waitTimer=nil;
        [self resetTimerToNil];
        theDataObject.spot = getSpotStr;
        NSString *infoBarStr = @"Your reserved spot is ";
        infoBarStr = [infoBarStr stringByAppendingFormat:@"%@",theDataObject.spot];
        self.infoBar.topItem.title=infoBarStr;
        NSString *msg = @"You have a new assignment: spot  ";
        msg= [msg stringByAppendingFormat:@"%@",theDataObject.spot];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        [self fireNotification:1];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Congratulations!"
                              message: msg
                              delegate: self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Accept",nil];
        [alert setTag:7];
        [alert show];
    }
                      
                   });


}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   //  ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if(actionSheet.tag == 1){
        
        if(buttonIndex == [actionSheet destructiveButtonIndex])
        {
            theDataObject.requestFlag = YES;
            theDataObject.showNoSpotNotifyFlag = YES;
            [self setWaitInterval:3];
            [actionSheet dismissWithClickedButtonIndex:[actionSheet destructiveButtonIndex] animated:YES];
        }
        if(buttonIndex != [actionSheet cancelButtonIndex] && buttonIndex != [actionSheet destructiveButtonIndex])
        {
            UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"parkingMapBoard"];
            [self.navigationController pushViewController:manuView animated:YES];
            
        }
        if(buttonIndex == [actionSheet cancelButtonIndex])
        {
            if([theDataObject.parkingCondition isEqualToString:@"none"])
                [self.mapView removeAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        }
 
    }
    else if(actionSheet.tag == 2){
        if(buttonIndex == [actionSheet destructiveButtonIndex])
        {
            [self showParkingMapViewBoard];
        }
        if(buttonIndex != [actionSheet cancelButtonIndex] && buttonIndex != [actionSheet destructiveButtonIndex])
        {
            [self showDirection];
        }
        if(buttonIndex == [actionSheet cancelButtonIndex])
        {
           
        }

        
    }
}
-(void)showDirection{
    float latitude = 42.349616;
    float longitude = -71.106911;
     CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
   [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@", placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.locality,
                                 placemark.administrativeArea,placemark.postalCode,placemark.ocean,placemark.subThoroughfare,placemark.subLocality,placemark.subAdministrativeArea
                                 ];
            NSLog(@"%@",address);
            [self showMap];
        }
    
      } ];
    

}
-(void)showMap{
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: placemark.thoroughfare,
                              (NSString *)kABPersonAddressCityKey: placemark.locality,
                              (NSString *)kABPersonAddressStateKey:placemark.administrativeArea,
                              (NSString *)kABPersonAddressZIPKey: placemark.postalCode
                              };
    
    MKPlacemark *place = [[MKPlacemark alloc]
                          initWithCoordinate:theDataObject.destination
                          addressDictionary:address];
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
/*   NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    NSTimeInterval oldLocationAge = -[oldLocation.timestamp timeIntervalSinceNow];
    NSLog(@"time is %f %f",locationAge,oldLocationAge);
    if (locationAge > 5.0) return;
*/
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    distance = [self distanceBetweenCoordinates:currentCoordinates.latitude longitude:currentCoordinates.longitude];
    
    NSLog(@"distance: %d",distance);
    theDataObject.distance = distance;
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager setDelegate:nil];
    locationManager = nil;
    NSLog(@"updated latitude %+.6f, longitude %+.6f\n",
          currentCoordinates.latitude,
          currentCoordinates.longitude);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (double)distanceBetweenCoordinates:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocationDegrees latitude1 =42.351059;
    CLLocationDegrees longitude1 =-71.106803;
    
    CLLocation *to = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    
    CLLocation *from = [[CLLocation alloc] initWithLatitude:latitude  longitude:longitude];
    
    CLLocationDistance distance = [to distanceFromLocation:from];
    
    return distance;
}

- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
//	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

-(void)createPicker{
    NSArray *arrayToLoadPicker = [[NSArray alloc] initWithObjects:@"Mugar Libarary",@"Photonics Center",@"School of Theology",@"George Sherman Union",@"BU beach",@"Fit Rec", @"EMB",nil];
    NSArray *addressArray = [[NSArray alloc] initWithObjects:@"Mugar Library,Boston University",@"Photonics Center,Boston University",@"School of Theology, Boston University",@"George Sherman Union,Boston University",@"BU Beach,Boston University",@"Fit Recreation,Boston University",@"EMB, Boston University", nil];
    //  NSArray *numberArray2 = [[NSArray alloc] initWithObjects:@"5",@"4",@"3",@"2",@"1",@"0", nil];
    self.pickerViewArray = arrayToLoadPicker;
    self.addressArray = addressArray;
    self.pickDestination.delegate =self;
    self.pickDestination.dataSource = self;
    [self.pickDestination selectRow:3 inComponent:0 animated:YES];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerViewArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewArray objectAtIndex:row];
}

- (IBAction)cancelButton:(id)sender {
  //  ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if([self.cancelButton.title isEqualToString:@"Cancel"]){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Are you sure you want to cancel your reservation?"
                              delegate: self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Confirm",nil];
        [alert setTag:1];
        [alert show];

    }
    else if([self.cancelButton.title isEqualToString:@"Hide"]){
        self.bottomToolBar.hidden=NO;
        self.cancelButton.title = @"Show";
        if (theDataObject.destAddress != nil) {
            self.infoBar.topItem.title = @"Press red pin to get a Spot";
        }
        else{
             self.infoBar.topItem.title = @"Select your BU destination";
        }
        self.pickDestination.hidden=YES;
        self.parkingButton.enabled=NO;
    }
    else if([self.cancelButton.title isEqualToString:@"Show"]){
        self.bottomToolBar.hidden=NO;
        self.cancelButton.title = @"Hide";
         self.infoBar.topItem.title = @"Select your BU destination";
        self.pickDestination.hidden=NO;
        self.parkingButton.enabled=YES;
    }
}


- (IBAction)parkingButton:(id)sender {
  //  [self getFSMState];
  //  ExampleAppDataObject* theDataObject = [self theAppDataObject];
    if([self.parkingButton.title isEqualToString:@"I am nearby"]){
        if(theDataObject.distance <  closeDetectDistance){
            [self isClose];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, you are not close enough to the spot. Please try again later or simply proceed to it. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }

    }
    else if([self.parkingButton.title isEqualToString:@"I parked"]){
        if(!theDataObject.confirmParkedFlag){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
           
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Confirm you have parked? "
                              delegate: self
                              cancelButtonTitle:@"NO"
                              otherButtonTitles:@"YES",nil];
        [alert setTag:9];
        [alert show];
            
        }
        else{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Thank you for your confirmation. Please allow a few minutes for our sensor to detect your vehicle."
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert setTag:8];
            [alert show];
        }
        theDataObject.nearbyFlag = NO;
       // self.cancelButton.enabled = NO;
    }
   else if([self.parkingButton.title isEqualToString:@"Select"]){
       //do nothing
       int selectedIndex = [self.pickDestination selectedRowInComponent:0];
       NSString *address = [self.addressArray objectAtIndex:selectedIndex];
       theDataObject.destAddress = address;
       NSString *message = [NSString stringWithFormat:@"You selected: %@",[self.addressArray objectAtIndex:selectedIndex]];
       NSLog(@"%@",message);
       self.bottomToolBar.hidden=NO;
       self.pickDestination.hidden=YES;
       [self dropPinDestination:address];
       self.cancelButton.title=@"Show";
        self.parkingButton.enabled = NO;
    }   
}
-(void)setMethod:(NSString *)method
{
    _method = method;
    NSString* result = [NSString stringWithFormat:@"%@", _method];
    NSLog(@"get method %@", result);
}

- (void) requestSpot:(NSString *)userID destinaion:(CLLocationCoordinate2D )destination{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/requestSpot.php?ID=%@&latitude=%f&longitude=%f",userID,destination.latitude,destination.longitude];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
}
- (NSString *) getCapacity{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/getCapacity.php"];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    NSString *capStr = strResult;
    NSArray *capAry = [capStr componentsSeparatedByString:@"&"];
    NSString *avl = [capAry objectAtIndex:1];
    return avl;
}
- (NSString *) getSpot:(NSString *)userID{

    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/getSpot.php?ID=%@",userID];
//    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/getSpotCopy.php?ID=%@",userID];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    return strResult;
         
}
- (NSString *) reserveSpot:(NSString *)userID Spot:(NSString *)spot{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/reserveSpot.php?ID=%@&spot=%@",userID,spot];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    
    return strResult;
}
- (NSString *) getParkingState{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/get_parking_state.php?ID=%@",theDataObject.userID];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"get parking state %@",strResult);
    NSArray *parkingState = [strResult componentsSeparatedByString: @"&"];
    NSString *spot_id = [parkingState objectAtIndex:0];
    NSInteger fsm_state = [[parkingState objectAtIndex:1] integerValue];
    NSInteger driver_confirm = [[parkingState objectAtIndex:2]integerValue];
    
    if(fsm_state == 2){
        theDataObject.parkingCondition=@"reserved";
        theDataObject.spot = spot_id;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        NSString *msg = @"You have successfully reserved spot ";
        msg = [msg stringByAppendingFormat:@"%@. ", theDataObject.spot];
        msg = [msg stringByAppendingString:@"You will get a notification once you are close to the spot."];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: msg
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
     
    }
    else if (fsm_state >=4 && fsm_state <=7){
        
        theDataObject.parkingCondition=@"nearby";
        theDataObject.spot = spot_id;
        
        dispatch_async(dispatch_get_main_queue(), ^{ 
         
        if(driver_confirm == 1){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Thank you for your confirmation. Please allow a few minutes for our sensor to detect your vehicle."
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert setTag:8];
            [alert show];
        }
        else{
            NSLog(@"init close %@",strResult);
            NSTimer *closetimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(isClose) userInfo:nil repeats:NO];
              
        }
        });
    }
    else if (fsm_state == 8 || fsm_state == 9 ){
        theDataObject.parkingCondition = @"parked";
        theDataObject.spot = spot_id;
        dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = @"You are parked in spot ";
        msg = [msg stringByAppendingFormat:@"%@", theDataObject.spot];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
        self.infoBar.topItem.title = msg;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Congratulations!"
                              message: @"Your reservation is completed. Parking fee will be charged once your vehicle leaves the spot. "
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        });
     
    }
    else{
        theDataObject.parkingCondition = @"none";
        theDataObject.spot = 0;
    }
   // NSLog(@"%@",theDataObject.destAddress);
    [self checkParkingCondition];
    return strResult;
}
- (void) cancelSpot:(NSString *)userID{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("Cancel spot", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/cancel.php?ID=%@",userID];
        NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
        NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strResult);
    });
  
}
- (void) confirmParked:(NSString *)userID{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("confirm parked", NULL);
    dispatch_async(backgroundQueue, ^(void) {
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/confirmParked.php?ID=%@",userID];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    });   
}
- (void) confirmNearby:(NSString *)userID{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("confirm nearby", NULL);
    dispatch_async(backgroundQueue, ^(void) {
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/confirmNearby.php?ID=%@",userID];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
            });
}
- (void) driverConfirm:(NSString *)userID Parked:(NSInteger) parked{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("driver confirm", NULL);
    dispatch_async(backgroundQueue, ^(void) {
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/driverConfirm.php?ID=%@&parked=%d",userID,parked];
        NSLog(@"%@",strURL);
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    });

}

- (NSString *) getFSMState {
 //   ExampleAppDataObject* theDataObject = [self theAppDataObject];
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/get_state_FSM.php?ID=%@",theDataObject.userID];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    theDataObject.FSM_state = strResult;
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(main,
                   ^{
    [self doWithFSMState:[theDataObject.FSM_state integerValue]];
       });
    return strResult;
}
-(NSString *)doWithFSMState:(int)fsmState{
  
    switch (fsmState) {
        case 0:
            NSLog(@"FSM state 0");
             if(([theDataObject.parkingCondition isEqualToString:@"reserved"]|| [theDataObject.parkingCondition isEqualToString:@"nearby"]) && ([self readTimeoutFlag]>0)){
                NSLog(@"timeout state fire");
                [self cancelAllStates];
                [self fireNotification:3];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1004);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Oops"
                                      message: @"Sorry, Your reservation has timed out."
                                      delegate: self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert setTag:10];
                [alert show];
                [self resetUserState];
                theDataObject.timeoutFlag = NO;

            }
            else if([theDataObject.parkingCondition isEqualToString: @"parked"]){
                 NSLog(@"left spot %@, user Id %@",theDataObject.parkingCondition,theDataObject.userID);
                [self fireNotification:5];
                theDataObject.parkingCondition = @"none";
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1004);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Congratulation"
                                      message: @"Your vehicle has been detected leaving the spot. Thank you for using the Smart Parking system."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [self cancelSpot:theDataObject.userID];
                [self resetUserState];
                [self checkParkingCondition];
                 theDataObject.parkingCondition = @"none";
                UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
                [self.navigationController pushViewController:manuView animated:NO];
            }
            break;
            
        case 1:
            NSLog(@"FSM state 1");
            break;
            
        case 2:
            NSLog(@"FSM state 2");
            theDataObject.parkingCondition=@"reserved";
            [self isClose];
            break;
            
        case 3:
        {
            NSLog(@"FSM state 3");
            theDataObject.nearbyFlag = NO;
        if(theDataObject.showStolenNotifyFlag){
            theDataObject.showStolenNotifyFlag = NO;
            [self fireNotification:6];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, your spot has been taken by an unauthorized vehicle. The system will assign you a new one."
                                  delegate: self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK",nil];
            [alert setTag:3];
            [alert show];
            }
            break;
        }
            
        case 4:
        {
            NSLog(@"FSM state 4");
            theDataObject.parkingCondition=@"nearby";
            theDataObject.nearbyFlag = NO;
            break;
        }
        case 5:
            NSLog(@"FSM state 5");
            break;
            
        case 6:
            NSLog(@"FSM state 6");
            break;
        case 7:
        {
            NSLog(@"FSM state 7");
        
            if(theDataObject.showConfirmNotifyFlag){
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1004);
            theDataObject.showConfirmNotifyFlag = NO;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Have you parked?"
                                  delegate: self
                                  cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil
                                  ];
            [alert setTag:0];
            [alert show];
            }
            break;
            
        }
        case 8:
        {
            NSLog(@"FSM state 8");
            if(theDataObject.showCompleteNotifyFlag){
                                  theDataObject.showCompleteNotifyFlag = NO;
                                  [self fireNotification:4];
                                   AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                   AudioServicesPlaySystemSound(1004);
                                   UIAlertView *alert = [[UIAlertView alloc]
                                                         initWithTitle: @"Congratulations!"
                                                         message: @"Your vehicle has been detected by a sensor. Your reservation is completed. Parking fee will be charged once your vehicle leaves the spot. "
                                                         delegate: nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                                   [alert show];
                                   NSString *msg = @"You have parked in spot ";
                                    msg = [msg stringByAppendingFormat:@"%@", theDataObject.spot];
                                   self.infoBar.topItem.title = msg;
                                   self.bottomToolBar.hidden=YES;
                                   [self cancelAllStates];
                                   theDataObject.parkingCondition=@"parked";
                                   
                               }
                              
                    break;
        }
        case 9:
        {
            NSLog(@"FSM state 9");
            if(theDataObject.showCompleteNotifyFlag){
                theDataObject.showCompleteNotifyFlag = NO;
                [self fireNotification:4];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1004);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Congratulations"
                                      message: @"Your vehicle has been detected by a sensor. Your reservation is complete. "
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                NSString *msg = @"You have parked in spot ";
                msg = [msg stringByAppendingFormat:@"%@", theDataObject.spot];
                self.infoBar.topItem.title = msg;
                self.bottomToolBar.hidden=YES;
                [self cancelAllStates];
                theDataObject.parkingCondition=@"parked";
            }
            
            break;
        }
        case 10:
        {
            NSLog(@"FSM state 10");
            
            if(theDataObject.showStolenNotifyFlag){
                theDataObject.showStolenNotifyFlag = NO;
                [self fireNotification:6];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1004);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Oops"
                                      message: @"Sorry, your spot has been taken by an unauthorized vehicle. The system will assign you a new one."
                                      delegate: self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK",nil];
                [alert setTag:3];
                [alert show];
            }

            break;
        }
        case 11:
        {
            [self cancelAllStates];
            UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
            [self.navigationController pushViewController:manuView animated:YES];
            [self fireNotification:3];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, Your reservation has timed out."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [self resetUserState];
            theDataObject.timeoutFlag = NO;
            NSLog(@"FSM state 11");
            break;
        }
        default:
            return nil;
            break;
            
    }   
     return nil;
}/*
-(void)methodToBePerformedOnMainThread{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1004);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Congratulations"
                          message: @"Your car have been detected by the sensor. Your reservation has completed."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     if(alertView.tag == 0){
        if(buttonIndex == 0){
            NSLog(@"NO");
            [self driverConfirm:theDataObject.userID Parked:0];
            
            if(theDataObject.showStolenNotifyFlag){
                theDataObject.showStolenNotifyFlag = NO;
                [self fireNotification:6];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1004);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Oops"
                                      message: @"Sorry, your spot has been taken by an unauthorized vehicle. The system will assign you a new one."
                                      delegate: self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK",nil];
                [alert setTag:3];
                [alert show];
            }

            return;
        }
        else if(buttonIndex == 1){
            [self driverConfirm:theDataObject.userID Parked:1];
            NSLog(@"YES");
            return;
        }
    }
    else if(alertView.tag ==1){
        if(buttonIndex == 0){
            NSLog(@"NO");
            return;
        }
        else if(buttonIndex == 1){
            [theDataObject.fsmTimer invalidate];
            theDataObject.fsmTimer = nil;
            [self cancelSpot:theDataObject.userID];
            [self resetUserState];
            [self checkParkingCondition];
            [self checkParkingCondition];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Your reservation has been cancelled."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"Reservation has been cancelled.");
           
       //     NSLog(@"%@",theDataObject.method);
            return;
            
        }

    }
    else if(alertView.tag ==2){
        if(buttonIndex == 0){
            NSLog(@"NO");
            return;
        }
        else if(buttonIndex == 1){
            [self cancelSpot:theDataObject.userID];
            [self cancelAllStates];
            [self resetUserState];
          /*  [self checkParkingCondition];
            [self checkParkingCondition];*/
            [self resetTimerToNil];
            NSLog(@"Back to select board");
           /* AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Your reservation has been cancelled."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];*/
            UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
            [self.navigationController pushViewController:manuView animated:YES];
            return;
        }
    
    }
    else if(alertView.tag ==3){
        if(buttonIndex == 0){
            [theDataObject.fsmTimer invalidate];
           theDataObject.fsmTimer = nil;
            [self cancelSpot:theDataObject.userID];
            [self resetUserState];
            [self checkParkingCondition];
            [self checkParkingCondition];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Your reservation has been cancelled."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"Reservation has been cancelled.");
            return;
        }
       else if(buttonIndex == 1){
            NSLog(@"stolen then request spot");
            [self cancelSpot:theDataObject.userID];
            [self resetUserState];
            self.infoBar.topItem.title = @"Waiting for assignment";
            [self setWaitInterval:3];
            return;
        }
        
    }
    else if(alertView.tag ==4){
        if(buttonIndex == 0){
            NSLog(@"Press Cancel");
         //   [self resetUserState];
            [self.waitTimer invalidate];
            self.waitTimer = nil;
            [self checkParkingCondition];
            [self checkParkingCondition];
            return;
        }
        else if(buttonIndex == 1){
            NSLog(@"Press Proceed");
            [self setFarAwayWaitingAllowTimeout:600];
            [self setWaitInterval:20];
        }
    }
    else if(alertView.tag ==5){
        if(buttonIndex == 0){
          //  [self resetUserState];
            [self.waitTimer invalidate];
            self.waitTimer = nil;
            [self checkParkingCondition];
            [self checkParkingCondition];
        }
        else if(buttonIndex == 1){
           [self setNoSpotTimeout:900];
           [self setWaitInterval:20];
        }
    }
    else if(alertView.tag ==6){
            if(buttonIndex == 0){
                self.parkingButton.title = @"I parked";
            }
        
    }
    else if(alertView.tag ==7){
        if(buttonIndex == 1){
            theDataObject.showConfirmNotifyFlag = YES;
            theDataObject.showCompleteNotifyFlag = YES;
            theDataObject.showStolenNotifyFlag = YES;
            [self dispatchFsmTimer];
            [self setFSMInterval:20];
        /*    UIDevice *dev = [UIDevice currentDevice];
            NSString *deviceUuid;
            deviceUuid = dev.uniqueIdentifier;
            [self writeNotificationMessage:deviceUuid];
            [self writeAPNSMessage:theDataObject.userID Arg2:deviceUuid];
         */
       
            self.parkingButton.enabled= YES;
            self.cancelButton.enabled = YES;
            self.bottomToolBar.hidden = NO;
            self.cancelButton.title=@"Cancel";
            if(![self.parkingButton.title isEqualToString:@"I parked"]){
                self.parkingButton.title = @"I am nearby";
            }
            self.cancelButton.tintColor = [UIColor redColor];
            [self.activityIndicator stopAnimating];
            self.backButton.enabled = YES;
        }
        else if(buttonIndex == 0){
            [self cancelSpot:theDataObject.userID];
            [self resetUserState];
            [self checkParkingCondition];
            [self checkParkingCondition];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1004);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Your reservation has been cancelled."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"Reservation has been cancelled.");
        }
    }
    else if(alertView.tag ==8){
      if(buttonIndex == 0){
         self.infoBar.topItem.title =@"Please allow a few minutes...";
         self.parkingButton.title = @"I parked";
      }
    }
    else if(alertView.tag == 9){
        if(buttonIndex == 0){
            
        }
        if(buttonIndex == 1){
            [self confirmParked:theDataObject.userID];
             theDataObject.confirmParkedFlag = YES;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Thank you for your confirmation. Please allow a few minutes for our sensor to detect your vehicle."
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert setTag:8];
            [alert show];

        }
        
    }
    else if(alertView.tag == 10){
        if(buttonIndex == 0){
            theDataObject.parkingCondition = @"none";
            UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
            [self.navigationController pushViewController:manuView animated:YES];
        }
    }
}

-(void)fireNotification:(int) notificationIndex{
    NSDate *alertTime = [[NSDate date]
                         dateByAddingTimeInterval:0];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
                                        init];
    NSString *msg = @"";
    switch (notificationIndex) {
        case 1:
            msg = @"You have a new assignment: spot ";
            msg = [msg stringByAppendingFormat:@"%@.", theDataObject.spot];
            break;
        case 2:
            msg = @"You are almost there! Spot ";
            msg = [msg stringByAppendingFormat:@"%@ is now ready for you.", theDataObject.spot];
            break;
        case 3:
            msg = @"Sorry, your reservation has timed out.";
            break;
        case 4:
            msg = @"Your vehicle has been detected by a sensor. Your reservation is complete";
            break;
        case 5:
            msg = @"Your vehicle has been detected leaving the spot. Thank you for using the Smart Parking system.";
            break;
        case 6:
            msg = @"Sorry, your spot has been taken by an unauthorized vehicle. The system will assign you a new one.";
            break;
        case 7:
            msg = @"Sorry, no parking space currently available.";
            break;
        case 8:
            msg = @"Sorry, you are no longer in the queue for assignment. ";
            break;
        default:
            break;
    }
    
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName =  UILocalNotificationDefaultSoundName;
        notifyAlarm.alertBody = msg;
        [app scheduleLocalNotification:notifyAlarm];
    }
}
-(void)resetUserState{
    theDataObject.spot = 0;
    theDataObject.parkingCondition = @"none";
    theDataObject.destAddress=nil;
    theDataObject.requestFlag = NO;
    theDataObject.nearbyFlag = NO;
    theDataObject.confirmParkedFlag = NO;
    theDataObject.showCompleteNotifyFlag = YES;
    theDataObject.showConfirmNotifyFlag = YES;
    theDataObject.showNoSpotNotifyFlag = YES;
    theDataObject.showStolenNotifyFlag = YES;
    theDataObject.showWaitSensorNotifyFlag = YES;
    [self.mapView removeAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
    [theDataObject.fsmTimer invalidate];
   theDataObject.fsmTimer = nil;
}

-(Boolean)readTimeoutFlag{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/read_timeout_flag.php?spot=%@",theDataObject.spot];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"get timeout state: %@",strResult);
    theDataObject.timeout_state = strResult;
    
    if (!theDataObject.timeoutFlag) {
        theDataObject.timeoutFlag = NO;
        if([theDataObject.timeout_state integerValue]==2 || [theDataObject.timeout_state integerValue]==4|| [theDataObject.timeout_state integerValue]==6|| [theDataObject.timeout_state integerValue]==7  ) {
                       theDataObject.timeoutFlag = YES;
        }

   }
    return theDataObject.timeoutFlag;
}
/*
-(void)dispatchGpsTimer{
   
        if (nil == locationManager)
            locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
  
}*/
/*
-(void)setTimeoutInterval:(float) theTime  {
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(dispatchTimeoutTimer) userInfo:nil repeats:YES];
}*/

-(void)setRegionTimer:(float) theTime  {
    self.cTimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(gotoLocation) userInfo:nil repeats:NO];
}
-(void)initWaitingTimer{

    self.timerLabel.hidden = NO;
    self.timerLabel.text =[NSString stringWithFormat:@"00:00"];
    [self.timerLabel setFrame:self.mapView.frame];
    self.timerLabel.center = self.mapView.center;
    [self.timerLabel.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.80] CGColor]];
    [pollingTimer invalidate];
    pollingTimer = nil;
    pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
 

    /*

     */
}
-(void)resetTimerToNil{
   
        self.timerLabel.hidden=YES;
        self.timerLabel.text=@"00:00";
        time = 0;
        [pollingTimer invalidate];
    pollingTimer = nil;
    
}
- (float) updateTime
{
    time+=1;
    int minutes = floor(time/60);
    int seconds = (int)(time - ( 60 * (int)( time / 60 ) ));
    timestr = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    [self.timerLabel setText:timestr];
    return time;
}

-(void)setFarAwayWaitingAllowTimeout:(float)theTime{
  FarAwaytimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(FarAwayWaitingTimeout) userInfo:nil repeats:NO];
}
-(void)FarAwayWaitingTimeout{
    if([self.infoBar.topItem.title isEqualToString:@"Waiting for assignment"] && theDataObject.distance > allowAssignDistance){
    [self resetTimerToNil];
    [self resetUserState];
    [self checkParkingCondition];
    [self checkParkingCondition];
    [self.waitTimer invalidate];
    self.waitTimer = nil;
    self.timerLabel.hidden = YES;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1004);
    [self fireNotification:8];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message:@"Sorry, you are no longer in the queue for assignment. "
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    }

}

-(void)setNoSpotTimeout:(float)theTime{
    NoSpottimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(noSpotTimeout) userInfo:nil repeats:NO];
}
-(void)noSpotTimeout{
    if ([self.infoBar.topItem.title isEqualToString:@"Waiting for assignment"]) {
    [self resetTimerToNil];
    [self resetUserState];
    [self checkParkingCondition];
    [self checkParkingCondition];
    [self.waitTimer invalidate];
    self.waitTimer = nil;
    self.timerLabel.hidden = YES;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1004);
    [self fireNotification:8];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message:@"Sorry, you are no longer in the queue for assignment. "
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    }
    
}
-(void)setWaitInterval:(float) theTime  {
   // [self getSpot];
    [self resetTimerToNil];
    [self.waitTimer invalidate];
    self.waitTimer = nil;
    [self initWaitingTimer];
    self.infoBar.topItem.title = @"Waiting for assignment";
    self.backButton.enabled = YES;
    self.bottomToolBar.hidden=YES;
    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(getSpot) userInfo:nil repeats:YES];
    
}
-(void)startGps{
    
    [gpsTimer invalidate];
    gpsTimer = nil;
    if(![theDataObject.parkingCondition isEqualToString:@"parked"]){
        if (nil == locationManager)
            locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
             
    
    if(distance > 20000){
        [self setGpsInterval:120];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        [locationManager setDistanceFilter:2000];
        [locationManager startMonitoringSignificantLocationChanges];

        NSLog(@"distance > 20000, time interval 30s, accuracy 1000m");
    }
    else if(distance >5000){
        [self setGpsInterval:180];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        [locationManager setDistanceFilter:1000];
        [locationManager startMonitoringSignificantLocationChanges];

        NSLog(@"5000 < distance < 20000, time interval 20s, accuracy 100m");
        
    }
    else if(distance>2000){
        [self setGpsInterval:30];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [locationManager setDistanceFilter:10];
        [locationManager startMonitoringSignificantLocationChanges];

        NSLog(@"2000<distance <5000, time interval 10s, accuracy 10m");
    }
    else if(distance>500){
        [self setGpsInterval:10];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [locationManager setDistanceFilter:10];
        [locationManager startMonitoringSignificantLocationChanges];

        NSLog(@"500<distance <2000, time interval 10s, accuracy 10m");
    }
    else if(distance<500){
        [self setGpsInterval:30];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [locationManager setDistanceFilter:10];
        [locationManager startMonitoringSignificantLocationChanges];

        NSLog(@"distance <200, time interval 10s, accuracy 10m");
    }
    }
           
}

-(void)setFSMInterval:(float) theTime  {
    /*UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];*/
    [theDataObject.fsmTimer invalidate];
    theDataObject.fsmTimer = nil;
    theDataObject.fsmTimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(dispatchFsmTimer) userInfo:nil repeats:YES];
 
    
}
-(void)dispatchFsmTimer{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("get FSM State", NULL);
    // dispatch_release(backgroundQueue);
    dispatch_async(backgroundQueue, ^(void) {
        [self getFSMState];
    });
}
-(void)setGpsInterval:(float) theTime  {
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    [gpsTimer invalidate];
    gpsTimer = nil;
    gpsTimer = [NSTimer scheduledTimerWithTimeInterval:theTime target:self selector:@selector(startGps) userInfo:nil repeats:YES];
}
-(void)isClose{
   // ExampleAppDataObject* theDataObject = [self theAppDataObject];
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(main,
                   ^{
                       if((theDataObject.distance<closeDetectDistance) && (theDataObject.distance >0)){
                          
                          
                           
                           if(!theDataObject.nearbyFlag && (theDataObject.spot>0)&& ![theDataObject.parkingCondition isEqualToString:@"parked"]){
                               NSLog(@"Is nearby");
                               [self confirmNearby:theDataObject.userID];
                               [self fireNotification:2];
                               AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                               AudioServicesPlaySystemSound(1004);
                               NSString *msg = @"You are almost there! Spot ";
                               msg = [msg stringByAppendingFormat:@"%@ is now ready for you.", theDataObject.spot];
                               UIAlertView *alert = [[UIAlertView alloc]
                                                     initWithTitle: @""
                                                     message: msg
                                                     delegate: self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                               [alert setTag:6];
                               [alert show];
                               msg = @"Spot ";
                               msg = [msg stringByAppendingFormat:@"%@ is now ready for you",theDataObject.spot];
                               self.infoBar.topItem.title = msg;
                               [self setFSMInterval:5];
                               theDataObject.parkingCondition=@"nearby";
                               theDataObject.nearbyFlag = YES;
                           }
                       }

                   });
  }
-(void)dismissKeyboard {
    [sBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",sBar.text);
    [self dropPinDestination:sBar.text];
    [sBar resignFirstResponder];
    sBar.hidden=YES;
    self.bottomToolBar.hidden=YES;
    
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [sBar resignFirstResponder];
    sBar.hidden=YES;
    self.infoBar.hidden=NO;
    self.infoBar.topItem.title = @"Press red pin to get a spot";
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    CLLocationCoordinate2D center;
    
    double latitude = 0.0;
    double longitude = 0.0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    // NSLog(@"%@",req);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    // NSLog(@"result %@",result);
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    center.latitude = latitude;
    center.longitude = longitude;
    NSLog(@"location %f, %f",latitude,longitude);
    return center;
    
}
-(void)dropPinDestination:(NSString *)address{

    sBar.hidden=YES;
    self.infoBar.hidden=NO;
    self.infoBar.topItem.title=@"Press red pin to get a spot";
    theDataObject.destAddress = address;
    NSLog(@"drop pin destination");
    @try {
        NSLog(@"try");
        [self.mapView removeAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        CLLocationCoordinate2D coordinate = [self geoCodeUsingAddress:address];
        [self gotoPinLocation:coordinate];
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords:coordinate];
        theDataObject.destination = coordinate;
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        if(![theDataObject.method isEqualToString: @"fromHistoryToPin"])
        [self writeToCoreData:address];
    }
    @catch (NSException *exception) {
        NSLog(@"catch");
        CLLocationCoordinate2D coordinate = [self geoCodeUsingAddress:address];
        [self gotoPinLocation:coordinate];
        destAnnotation *annot = [[destAnnotation alloc] initWithCoords:coordinate];
        theDataObject.destination = coordinate;
        [self.mapAnnotations insertObject:annot atIndex:destIndex];
        [self.mapView addAnnotation:[self.mapAnnotations objectAtIndex:destIndex]];
        if(![theDataObject.method isEqualToString: @"fromHistoryToPin"])
        [self writeToCoreData:address];
    }
}

-(void)writeToCoreData:(NSString *) address{
    Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.myDelegate.managedObjectContext];
    // Should be the location's timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[event setCreationDate:[NSDate date]];
    [event setAddress:address];
    NSLog(@"add new event");
	NSError *error;

    BOOL isSaveSuccess = [self.myDelegate.managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"Save successful!");
    }
}
- (IBAction)backButton:(id)sender {
    if([self.infoBar.topItem.title isEqualToString:@"Waiting for assignment"] ){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Your reservation will be cancelled, are you sure?"
                              delegate: self
                              cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil
                              ];
        [alert show];
        [alert setTag:2];
    }
    else if([theDataObject.parkingCondition isEqualToString:@"parked"] || [theDataObject.parkingCondition isEqualToString:@"none"] || theDataObject.parkingCondition == nil){
        UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
        [self.navigationController pushViewController:manuView animated:YES];
   
    }
    else{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1004);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"Your reservation will be cancelled, are you sure?"
                              delegate: self
                              cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil
                              ];
        [alert show];
        [alert setTag:2];
        
    }
}
- (NSString *) writeNotificationMessage:(NSString *)deviceuid{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/apns/samples.php?deviceuid=%@",deviceuid];
    NSLog(@"write notification message");
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
- (NSString *) writeAPNSMessage:(NSString *)clientid Arg2:(NSString *)deviceuid{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/writeAPNSMessage.php?clientid=%@&deviceuid=%@",clientid,deviceuid];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
- (IBAction)tutorialButton:(id)sender {
    if(![self.infoBar.topItem.title isEqualToString:@"Waiting for assignment"])
    {
        UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"infoBoard"];
        [self.navigationController pushViewController:manuView animated:YES];
   
    }
    else
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Sorry" message:@"Please wait for the assignment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}
@end
