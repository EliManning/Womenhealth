//
//  loginPageViewController.m
//  womenhealth
//
//  Created by smart_parking on 5/14/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "loginPageViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface loginPageViewController ()
@end

@implementation loginPageViewController
@synthesize username;
@synthesize password;
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
    [self.username addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
	[self.password addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
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
             ExampleAppDataObject* theDataObject = [self theAppDataObject];
            theDataObject.userID = [resultArray objectAtIndex:1];
            theDataObject.username = [resultArray objectAtIndex:2];
            UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroBoard"];
            [self.navigationController pushViewController:nextView animated:YES];
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
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/login.php?username=%@&password=%@",self.userNameStr,self.passWordStr];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
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
