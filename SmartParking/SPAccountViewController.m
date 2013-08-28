//
//  SPAccountViewController.m
//  SmartParking
//
//  Created by smart_parking on 2/9/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPAccountViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"

@interface SPAccountViewController ()

@end

@implementation SPAccountViewController
@synthesize username,plate,resvFee,parkFee,resvTime,parkTime,accountBalance,arriveTime;



- (void)viewDidLoad
{
     ExampleAppDataObject* theDataObject = [self theAppDataObject];
    NSLog(@"%@",theDataObject.userID);
    NSString *resultStr = [self connectToRemoteDB:theDataObject.userID];
    NSArray *resultArray = [resultStr componentsSeparatedByString:@"&"];
    self.username.text = [resultArray objectAtIndex:0];
    self.accountBalance.text = [resultArray objectAtIndex:1];
    self.resvFee.text = [resultArray objectAtIndex:2];
    self.parkFee.text = [resultArray objectAtIndex:3];
    self.resvTime.text = [resultArray objectAtIndex:4];
    self.arriveTime.text = [resultArray objectAtIndex:5];
   // self.arriveTimeII.text = [resultArray objectAtIndex:5];
    self.parkTime.text = [resultArray objectAtIndex:6];
    self.plate.text = [resultArray objectAtIndex:7];
  //  self.make.text = [resultArray objectAtIndex:8];
 //   self.model.text = [resultArray objectAtIndex:9];
 //   self.color.text = [resultArray objectAtIndex:10];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *) connectToRemoteDB:(NSString *)userID{
    NSLog(@"%@",userID);
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/get_user_info.php?ID=%@",userID];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}

- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

@end
