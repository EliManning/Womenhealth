//
//  PagedScrollViewController.h
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedScrollViewController : UIViewController <UIScrollViewDelegate>{
    NSInteger thepage;
}

@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end
