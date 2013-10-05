//
//  PagedScrollViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "TutorialViewController.h"
#import "AFImageViewer.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface TutorialViewController (){
    ExampleAppDataObject* theDataObject;
}

-(NSArray *) images;

@end
@implementation TutorialViewController
@synthesize imageViewer;

- (void)viewDidLoad
{
    [super viewDidLoad];
 //   self.title = @"Data source example";
    
    self.imageViewer.images = [self images];
    
    self.imageViewer.contentMode = UIViewContentModeScaleAspectFit;
}

-(NSArray *) images
{
    NSArray *imageNames = [NSArray arrayWithObjects:@"t1.png", @"t2.png", @"t3.png",@"t4.png",@"t5.png",@"t6.png", nil];
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSString *imageName in imageNames) [images addObject:[UIImage imageNamed:imageName]];
    
    return images;
}

- (void)viewDidUnload
{
    [self setImageViewer:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
@end

