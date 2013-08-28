//
//  ExampleAppDataObject.h
//  ViewControllerDataSharing
//
//  Created by Duncan Champney on 7/29/10.

#import <Foundation/Foundation.h>
#import "AppDataObject.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ExampleAppDataObject : AppDataObject 
{
	NSString* username;
    NSString* userID;
    NSString* spot;
    NSString* parkingFlag;
    CLLocation *currentLocation;
    CLLocationCoordinate2D destination;
    int distance;
    NSString* FSM_state;
    NSString* parkingCondition;
    NSMutableArray *recordList;
    NSString* destAddress;
    float preference;
    NSString* method;
    bool nearbyFlag;
    bool requestFlag;
    bool timeoutFlag;
    bool showCompleteNotifyFlag;
    bool showConfirmNotifyFlag;
    bool showStolenNotifyFlag;
    bool showNoSpotNotifyFlag;
    bool showWaitSensorNotifyFlag;
    bool confirmParkedFlag;
    NSString* currentView;
    NSTimer *fsmTimer;

}
@property (nonatomic, readwrite)NSMutableArray*  recordList;
@property (nonatomic)  CLLocation *currentLocation;
@property (nonatomic, readwrite) CLLocationCoordinate2D destination;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* destAddress;
@property (nonatomic, copy) NSString* userID;
@property (nonatomic, copy) NSString* spot;
@property (nonatomic, copy) NSString* currentView;
@property (nonatomic, copy) NSString* parkingFlag;
@property (nonatomic) bool nearbyFlag;
@property (nonatomic) bool requestFlag;
@property (nonatomic) bool showCompleteNotifyFlag;
@property (nonatomic) bool showConfirmNotifyFlag;
@property (nonatomic) bool showStolenNotifyFlag;
@property (nonatomic) bool showNoSpotNotifyFlag;
@property (nonatomic) bool confirmParkedFlag;
@property (nonatomic) bool showWaitSensorNotifyFlag;
@property (nonatomic) bool timeoutFlag;
@property (nonatomic, copy) NSString* method;
@property (nonatomic) int distance;
@property (nonatomic, copy) NSString*  FSM_state;
@property (nonatomic, copy) NSString*  timeout_state;
@property (nonatomic, readwrite) NSString*  parkingCondition;

@property (nonatomic) float  preference;
@property (nonatomic) NSTimer*  fsmTimer;
@end
