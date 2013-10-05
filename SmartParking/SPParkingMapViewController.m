//
//  SPParkingMapViewController.m
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//
#define allowAssignDistance				20000
#import "SPParkingMapViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "SPMainMapViewController.h"

@interface SPParkingMapViewController (){
    ExampleAppDataObject* theDataObject;
}
- (IBAction)backButton:(id)sender;

@end

@implementation SPParkingMapViewController

@synthesize webView=_webView;
@synthesize selectButton;

- (void)viewDidLoad{
    NSURL *url = [NSURL URLWithString:@"http://smartpark.bu.edu/adminview2012/map.html"];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestURL];
    theDataObject = [self theAppDataObject];
    NSLog(@"Parking condition: %@", theDataObject.parkingCondition);
 
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender {
    UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapBoard"];
    [self.navigationController pushViewController:manuView animated:YES];
}
- (IBAction)selectSpotButton:(id)sender {
    if([theDataObject.parkingCondition isEqualToString: @"reserved"] ||[theDataObject.parkingCondition isEqualToString: @"nearby"]||[theDataObject.parkingCondition isEqualToString: @"parked"]){
        NSString *msg = @"You have reserved spot ";
        msg = [msg stringByAppendingFormat:@"%@", theDataObject.spot];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: msg
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];

    }
    else{
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Please enter your spot number:"
                                                     message:@"\n"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Enter", nil];
    [prompt setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [prompt show];
    }

}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText integerValue]> 0 && [inputText integerValue]<27 )
    {
        
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     if(buttonIndex == 0) return;
    if(![self allowAssignSpot]) return;
    
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        
        NSString *tmpSpotStr = [[alertView textFieldAtIndex:0] text];
        NSInteger tmpSpot = [tmpSpotStr integerValue];

    if(tmpSpot>20 || tmpSpot <7){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops!"
                              message: @"Sorry, only spots 7-20 are available."
                              delegate: nil
                              cancelButtonTitle:@"I know"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    else{
                if([[self reserveSpot:theDataObject.userID Spot:tmpSpotStr] isEqualToString:@"success"]){
                    theDataObject.spot = tmpSpotStr;
                    theDataObject.parkingCondition = @"reserved";
                    theDataObject.nearbyFlag = NO;
                    theDataObject.showCompleteNotifyFlag = YES;
                    theDataObject.showConfirmNotifyFlag = YES;
                //    SPMainMapViewController *mainMap = [[SPMainMapViewController alloc]init];
               
                    NSString *msg = @"You have a new assignment: spot ";
                    msg= [msg stringByAppendingFormat:@"%@",theDataObject.spot];
                    NSLog(@"%@",msg);
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    AudioServicesPlaySystemSound(1004);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Congratulations!"
                                          message: msg
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    
              //     NSTimer *switchBoardTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(switchBoard) userInfo:nil repeats:NO];
                    
                }
                else if([[self reserveSpot:theDataObject.userID Spot:tmpSpotStr] isEqualToString:@"fail"]){
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Oops!"
                                          message: @"Sorry, you cannot reserve this spot at this time."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
        

- (NSString *) reserveSpot:(NSString *)userID Spot:(NSString *)spot{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/reserveSpot.php?ID=%@&spot=%@",userID,spot];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    return strResult;
}

-(BOOL)allowAssignSpot{
    if (theDataObject.distance > allowAssignDistance){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Sorry, you are too far away from the spot.The system cannot allocate spot for you." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    else
        return YES;
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
-(void)switchBoard{
    UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapBoard"];
    [self.navigationController pushViewController:manuView animated:YES];
}
@end
