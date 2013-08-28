//
//  ViewController.h
//  pageControl
//
//  Created by smart_parking on 4/9/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFImageViewer;
@interface TutorialViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet AFImageViewer *imageViewer;
@end
