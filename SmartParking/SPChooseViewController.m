//
//  SPChooseViewController.m
//  SmartParking
//
//  Created by smart_parking on 1/30/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPChooseViewController.h"
#import "SPMainMapViewController.h"
#import "SPKeychainItem.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "SPWelcomeViewController.h"
@interface SPChooseViewController (){
    ExampleAppDataObject* theDataObject;
  

}

@end

@implementation SPChooseViewController
@synthesize activityIndicator = _activityIndicator;
@synthesize indicatorSubview = _indicatorSubview;
@synthesize statusBar = _statusBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // keychain = [[SPKeychainItem alloc] initWithIdentifier:@"testID" accessGroup:nil];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (void)viewWillAppear:(BOOL)animated
{
 //   locationManager = [[CLLocationManager alloc] init];
 //   locationManager.delegate = self;
    [super viewDidAppear:animated];
}*/
- (void)viewDidLoad
{
    theDataObject = [self theAppDataObject];
   [self.activityIndicator stopAnimating];
    self.indicatorSubview.hidden = YES;
    self.activityIndicator.hidden = YES;
    
   // theDataObject.parkingCondition = @"none";
    NSLog(@"conditon %@  spot %@",theDataObject.parkingCondition, theDataObject.spot);
    
    if([theDataObject.parkingCondition isEqualToString:@"reserved"]||[theDataObject.parkingCondition isEqualToString:@"nearby"]){
        NSString* msg= @"Your reserved spot is ";
     msg=   [msg stringByAppendingFormat:@"%@",theDataObject.spot];
          NSLog(@"%@",msg);
        self.statusBar.topItem.title = msg;
    }
    else if ([theDataObject.parkingCondition isEqualToString:@"parked"]) {
        NSString* msg= @"You are parked in spot ";
        msg=   [msg stringByAppendingFormat:@"%@",theDataObject.spot];

        NSLog(@"%@",msg);
        self.statusBar.topItem.title =msg;
    }
    else{
         self.statusBar.topItem.title = @"Please select your destination";
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([theDataObject.parkingCondition isEqualToString: @"parked"]){
        UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapBoard"];
        [self.navigationController pushViewController:manuView animated:YES];
        return;
    }
    else {
    if ([segue.identifier isEqualToString:@"pinSegue"]) {
   
        [segue.destinationViewController setMethod:@"pin"];
    
    } else if ([segue.identifier isEqualToString:@"markSegue"]) {
   
        [segue.destinationViewController setMethod:@"mark"];
     
    } else if ([segue.identifier isEqualToString:@"searchSegue"]) {
        
        [segue.destinationViewController setMethod:@"search"];
        
    }
        
    }
   
}
- (IBAction)buttonClicked:(id)sender {
    self.indicatorSubview.hidden = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (IBAction)logoutButton:(id)sender {
  
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @""
                          message: @"Are you sure you want to log out?"
                          delegate: self
                          cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil
                          ];
    [alert show];
   }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"cancel logout");
        return;
    }
    if(buttonIndex == 1){
        keychain = [[SPKeychainItem alloc] initWithIdentifier:@"testID" accessGroup:nil];
        [keychain resetKeychainItem];
        NSLog(@"reset key chain");
        UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeBoard"];
    [self.navigationController pushViewController:manuView animated:YES];
    }

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
    //return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

- (void)viewDidUnload {
   
    [self setActivityIndicator:nil];
    [self setIndicatorSubview:nil];
    [self setStatusBar:nil];
    [super viewDidUnload];
}
@end
