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
    NSInteger fobtNum;
    NSInteger colonNum;
    NSInteger questionCount;
    NSInteger beliefScore;
    NSInteger supportCount;
    BOOL firstVoted;
    BOOL secondVoted;
    BOOL thirdVoted;
    BOOL fourthVoted;
    NSString* result;
    BOOL resultSubmitted;
    NSInteger riskCount;
    NSInteger riskScore;
    NSInteger userage;
    NSString* userEthnicity;
    BOOL riskAssessFinished;
    NSInteger lastAssessScore;
}
@property (nonatomic) NSInteger lastAssessScore;
@property (nonatomic,copy) NSString* username;
@property (nonatomic,copy) NSString* userID;
@property (nonatomic, copy) NSString* result;
@property (nonatomic, copy) NSString* userEthnicity;
@property (nonatomic, copy) NSString* riskLevel;
@property (nonatomic) NSInteger fobtNum;
@property (nonatomic) NSInteger userage;
@property (nonatomic) NSInteger colonNum;
@property (nonatomic) NSInteger questionCount;
@property (nonatomic) NSInteger beliefScore;
@property (nonatomic) NSInteger riskCount;
@property (nonatomic) NSInteger supportCount;
@property (nonatomic) NSInteger riskScore;
@property (nonatomic) BOOL firstVoted;
@property (nonatomic) BOOL secondVoted;
@property (nonatomic) BOOL thirdVoted;
@property (nonatomic) BOOL fourthVoted;
@property (nonatomic) BOOL resultSubmitted;
@property (nonatomic) BOOL riskAssessFinished;

@end
