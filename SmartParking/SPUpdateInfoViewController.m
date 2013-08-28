//
//  SPUpdateInfoViewController.m
//  smartparking
//
//  Created by smart_parking on 2/28/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPUpdateInfoViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface SPUpdateInfoViewController (){
ExampleAppDataObject* theDataObject;
}


@end

@implementation SPUpdateInfoViewController
@synthesize newplatetxt,newpwtxt,oldpwtxt,usernametxt;

- (void)viewDidLoad
{
   theDataObject = [self theAppDataObject];
   // ExampleAppDataObject* theDataObject = [[ExampleAppDataObject alloc]init];
     NSLog(@"sdsd %@", theDataObject.userID);
    [self.usernametxt addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
	[self.oldpwtxt addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.newpwtxt addTarget:self
                                      action:@selector(textFieldFinished:)
                            forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.newplatetxt addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (BOOL)textFieldFinished:(id)sender {
	return NO;
}
- (NSString *) connectToRemoteDB:(NSString *)username Arg2:(NSString *)oldpw Arg3:(NSString *)newpw Arg4:(NSString *)newplate{
 //    ExampleAppDataObject* theDataObject = [[ExampleAppDataObject alloc]init];
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/updateInfo.php?userId=%@&username=%@&oldpw=%@&newpw=%@&newplate=%@",theDataObject.userID, username,oldpw,newpw,newplate];
   NSLog(@"%@",strURL);
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

- (IBAction)confirmButton:(id)sender {
    NSString *userName = self.usernametxt.text;
    NSString *newpw = self.newpwtxt.text;
    NSString *oldpw = self.oldpwtxt.text;
    NSString *newPlate = self.newplatetxt.text;
    
    if ([oldpw length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"Please enter your old password."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:
                              nil];
        [alert show];
    }
    else{
        if([[self connectToRemoteDB:userName Arg2:oldpw Arg3:newpw Arg4:newPlate] isEqualToString:@"success"]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Congratulations"
                                  message: @"Your account has been updated succesfully "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];

        }
        else if([[self connectToRemoteDB:userName Arg2:oldpw Arg3:newpw Arg4:newPlate] isEqualToString:@"duplicate"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle: @"Oops"
                                   message: @"Your new username has existed in our database. Please use another one "
                                   delegate: nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
           [alert show];
        }
        else if([[self connectToRemoteDB:userName Arg2:oldpw Arg3:newpw Arg4:newPlate] isEqualToString:@"notMatch"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Sorry, the password does not match. "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Oops"
                                  message: @"Update failed "
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];

        }
   }

}
@end
