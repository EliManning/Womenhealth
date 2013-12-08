//
//  AppDelegate.h
//  womenhealth
//
//  Created by smart_parking on 5/9/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateProtocol.h"
@class ExampleAppDataObject;
@interface AppDelegate : UIResponder <UIApplicationDelegate,AppDelegateProtocol>{
    ExampleAppDataObject* theAppDataObject;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ExampleAppDataObject* theAppDataObject;
@end

