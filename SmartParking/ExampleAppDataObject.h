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
@property (nonatomic, strong)NSMutableArray*  recordList;
@property (nonatomic, strong)  CLLocation *currentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D destination;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* destAddress;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* spot;
@property (nonatomic, strong) NSString* currentView;
@property (nonatomic, strong) NSString* parkingFlag;
@property (nonatomic, assign) bool nearbyFlag;
@property (nonatomic, assign) bool requestFlag;
@property (nonatomic, assign) bool showCompleteNotifyFlag;
@property (nonatomic, assign) bool showConfirmNotifyFlag;
@property (nonatomic, assign) bool showStolenNotifyFlag;
@property (nonatomic, assign) bool showNoSpotNotifyFlag;
@property (nonatomic, assign) bool confirmParkedFlag;
@property (nonatomic, assign) bool showWaitSensorNotifyFlag;
@property (nonatomic, assign) bool timeoutFlag;
@property (nonatomic, strong) NSString* method;
@property (nonatomic, assign) int distance;
@property (nonatomic, strong) NSString*  FSM_state;
@property (nonatomic, strong) NSString*  timeout_state;
@property (nonatomic, strong) NSString*  parkingCondition;
@property (nonatomic, assign) float  preference;
@property (nonatomic, strong) NSTimer*  fsmTimer;
@end
