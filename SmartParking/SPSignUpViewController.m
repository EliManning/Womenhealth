//
//  SPSignUpViewController.m
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPSignUpViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface SPSignUpViewController ()

@end
@implementation SPSignUpViewController
@synthesize userName = _userName;
@synthesize passWordTextField;
@synthesize userNameTextField;
@synthesize confirmPasswordTextField;

- (void)viewDidLoad
{
   [[self userNameTextField]becomeFirstResponder];
	[self.userNameTextField addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
	[self.passWordTextField addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.confirmPasswordTextField addTarget:self
                                      action:@selector(textFieldFinished:)
                            forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload
{
    [self setPassWordTextField:nil];
    [self setUserNameTextField:nil];
    [self setConfirmPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

 - (BOOL)usernameFieldFinished:(id)sender {
 [passWordTextField becomeFirstResponder];
 return NO;
 }
 - (BOOL)passwordFieldFinished:(id)sender {
 [ confirmPasswordTextField becomeFirstResponder];
 return NO;
 }
 - (BOOL)confirmPasswordFieldFinished:(id)sender {
 return NO;
 }
- (BOOL)textFieldFinished:(id)sender {
	return NO;
}

- (IBAction)submit:(id)sender {
    
    self.userName = self.userNameTextField.text;
    self.passWord = self.passWordTextField.text;
    self.confirmedePassWord = self.confirmPasswordTextField.text;
    NSString *nameString = self.userName;
    NSString *pwString = self.passWord;
    NSString *confirmPwString = self.confirmedePassWord;
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
    else if(![pwString isEqualToString:confirmPwString]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Sorry, the two password doesn't match. Please try again."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    else{
        NSString* resultStr = [self connectToRemoteDB:nameString Arg2:pwString];
        NSArray *resultArray = [resultStr componentsSeparatedByString:@"&"];
        ExampleAppDataObject* theDataObject = [self theAppDataObject];
        theDataObject.userID = [resultArray objectAtIndex:1];
        NSString* resultState = [resultArray objectAtIndex:0];
        theDataObject.username = self.userName;
        NSLog(@"User ID %@", theDataObject.userID);
        if([resultState isEqualToString:@"success"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Congratulation!"
                                  message: @"Your account has been successfully created. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            UIViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBoard"];
            [self.navigationController pushViewController:mapView animated:YES];
            
        }
        else if([resultState isEqualToString:@"duplicate"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, the username has already existed. Please try another one. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, your account doesn't create successfully :( "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (NSString *) connectToRemoteDB:(NSString *)username Arg2:(NSString *)password{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/signup.php?username=%@&password=%@",username,password];
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

/*
 - (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
 if (theTextField == self.userNameTextField) {
 [theTextField resignFirstResponder];
 
 }
 return YES;
 }*/
@end

