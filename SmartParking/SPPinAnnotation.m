//
//  SPPinAnnotation.m
//  SmartParking
//
//  Created by smart_parking on 1/25/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPPinAnnotation.h"
@interface destAnnotation ()

@end

@implementation destAnnotation
@synthesize coordinate;
@synthesize subtitle;
@synthesize title;

- (id) initWithCoords:(CLLocationCoordinate2D) coords {
    self = [super init];
    if (self != nil) {
        coordinate = coords;
    }
    return self;
}


- (NSString *)title
{
    return @"Destination";
}
- (NSString *)subtitle
{
    return @"Press button to select spot";
}
@end
