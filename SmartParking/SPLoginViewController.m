//
//  SPLoginViewController.m
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPLoginViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface SPLoginViewController ()

@end

@implementation SPLoginViewController
- (void)viewDidLoad
{
    [[self username]becomeFirstResponder];
    keychain = [[SPKeychainItem alloc] initWithIdentifier:@"testID" accessGroup:nil];
    NSString *savedUsername = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *savedPassword = [keychain objectForKey:(__bridge id)kSecValueData];
    NSLog(@"username: %@",savedUsername);
    NSLog(@"password: %@",savedPassword);
    if(savedPassword!=nil && savedUsername!=nil){
   
        [self keychainActivated:savedUsername Arg2:savedPassword];
        return;
    }
    [self.username addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
	[self.password addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (BOOL)textFieldFinished:(id)sender {
	return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keychainActivated:(NSString *)username Arg2:(NSString *)password{
    NSString *resultStr = [self connectToRemoteDB:username Arg2:password];
    NSArray *resultArray = [resultStr componentsSeparatedByString:@"&"];
    if([[resultArray objectAtIndex:0] isEqualToString:@"success"]){
        UIViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
        [self.navigationController pushViewController:mapView animated:YES];
    }
    
}
- (IBAction)loginClicked:(id)sender {
    self.userNameStr = self.username.text;
    self.passWordStr = self.password.text;
    
    NSString *nameString = self.userNameStr;
    NSString *pwString = self.passWordStr;
   
    if ([nameString length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"The username shall not be empty!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:
                              nil];
        [alert show];
    }
    else if ([pwString length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"The password shall not be empty!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSString *resultStr = [self connectToRemoteDB:nameString Arg2:pwString];
        NSArray *resultArray = [resultStr componentsSeparatedByString:@"&"];
     
        if([[resultArray objectAtIndex:0] isEqualToString:@"success"])
        {
            [keychain setObject:nameString forKey:(__bridge id)kSecAttrAccount];
            [keychain setObject:pwString forKey:(__bridge id)kSecValueData];
            NSLog(@"Set keychain username:%@, password:%@",nameString,pwString);
            ExampleAppDataObject* theDataObject = [self theAppDataObject];
            theDataObject.userID = [resultArray objectAtIndex:1];
            theDataObject.username = [resultArray objectAtIndex:2];
            NSLog(@"%@",theDataObject.userID);
            NSLog(@"%@",theDataObject.username);
        //    UIDevice *dev = [UIDevice currentDevice];
        //NSLog(@"device uid: %@",dev.uniqueIdentifier);
       //     [self writeAPNSDeviceUid:theDataObject.userID Arg2:dev.uniqueIdentifier];
        //    [self writeAPNSMessage:theDataObject.userID Arg2:dev.uniqueIdentifier];
            /*UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Congratulation!"
                                  message: @"Your have successfully login. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];*/
            if([theDataObject.parkingCondition isEqualToString: @"reserved"] && [theDataObject.parkingCondition isEqualToString:@"parked"]){
            UIViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapBoard"];
            [self.navigationController pushViewController:mapView animated:YES];
            }
            else{
                UIViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
                [self.navigationController pushViewController:mapView animated:YES];
            }
        }
         else if([[self connectToRemoteDB:nameString Arg2:pwString]isEqualToString:@"notExist"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, we did not found that username in our database. Please sign up. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else if([[self connectToRemoteDB:nameString Arg2:pwString]isEqualToString:@"notMatch"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, your password doesn't match the username.Please try again. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
        else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, login failed :( "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}
- (NSString *) connectToRemoteDB:(NSString *)username Arg2:(NSString *)password{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/login.php?username=%@&password=%@",username,password];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
- (NSString *) writeAPNSDeviceUid:(NSString *)clientid Arg2:(NSString *)deviceuid{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/writeAPNSDeviceUid.php?clientid=%@&deviceuid=%@",clientid,deviceuid];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
/*
- (NSString *) writeAPNSMessage:(NSString *)clientid Arg2:(NSString *)deviceuid{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/writeAPNSMessage.php?clientid=%@&deviceuid=%@",clientid,deviceuid];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}*/
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

@end
