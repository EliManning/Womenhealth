//
//  PagedScrollViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "PagedScrollViewController.h"

@interface PagedScrollViewController ()
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation PagedScrollViewController
@synthesize pageController = _pageController;
//@synthesize scrollView = _scrollView;
//@synthesize pageControl = _pageControl;
@synthesize scrollview = _scrollview;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollview.frame.size.width;
     thepage = (NSInteger)floor((self.scrollview.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    NSLog(@"current page %d",thepage);
    // Update the page control
    self.pageController.currentPage = thepage;
    
    // Work out which pages we want to load
    NSInteger firstPage = thepage - 1;
    NSInteger lastPage = thepage + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
        NSLog(@"purge %d",thepage);
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
        NSLog(@"load %d",thepage);
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
        NSLog(@"purge %d",thepage);
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        NSLog(@"Loading %d %d",page,self.pageImages.count);
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.view.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        NSLog(@"show %d",page);
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.view addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
       NSLog(@"A %d",page);
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
         NSLog(@"B %d",page);
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Paged";
    
    // Set up the image we want to scroll & zoom and add it to the scroll view
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"photo1.png"],
                       [UIImage imageNamed:@"photo2.png"],
                       [UIImage imageNamed:@"photo3.png"],
                       nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    // Set up the page control
    self.pageController.currentPage = 0;
    self.pageController.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollview.frame.size;
    self.scrollview.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
}

- (void)viewDidUnload {
    [self setPageController:nil];
   
    [self setScrollview:nil];
    [super viewDidUnload];
    
    self.scrollview = nil;
    self.pageController = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen

    [self loadVisiblePages];
}

@end
