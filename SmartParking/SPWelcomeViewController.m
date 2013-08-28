//
//  SPWelcomeViewController.m
//  SmartParking
//
//  Created by smart_parking on 2/3/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPWelcomeViewController.h"
#import "SPLoginViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface SPWelcomeViewController ()

@end

@implementation SPWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    keychain = [[SPKeychainItem alloc] initWithIdentifier:@"testID" accessGroup:nil];
   // [self resetKeychainItem];
    NSString *savedUsername = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *savedPassword = [keychain objectForKey:(__bridge id)kSecValueData];
    NSLog(@"username: %@",savedUsername);
    NSLog(@"password: %@",savedPassword);
    if(savedPassword!=nil && savedUsername!=nil){
        
        [self keychainActivated:savedUsername Arg2:savedPassword];
        return;
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)keychainActivated:(NSString *)username Arg2:(NSString *)password{
    NSString *resultStr = [self connectToRemoteDB:username Arg2:password];
    NSArray *resultArray = [resultStr componentsSeparatedByString:@"&"];
    if([[resultArray objectAtIndex:0] isEqualToString:@"success"]){
        ExampleAppDataObject* theDataObject = [self theAppDataObject];
        theDataObject.userID = [resultArray objectAtIndex:1];
        theDataObject.username = [resultArray objectAtIndex:2];
        NSLog(@"%@",theDataObject.userID);
        NSLog(@"%@",theDataObject.username);
        UIViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
        [self.navigationController pushViewController:mapView animated:YES];
    }
    
}
-(void)resetKeychainItem{
    [keychain resetKeychainItem];
}
- (NSString *) connectToRemoteDB:(NSString *)username Arg2:(NSString *)password{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/login.php?username=%@&password=%@",username,password];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
@end
