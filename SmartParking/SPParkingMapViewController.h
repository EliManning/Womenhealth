//
//  SPParkingMapViewController.h
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SPParkingMapViewController : UIViewController<UIWebViewDelegate> {
    UIWebView *webView;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
- (IBAction)selectSpotButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
