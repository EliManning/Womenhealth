//
//  SPViewController.m
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPDestAnnotation.h"

@interface parkingAnnotation ()

@end

@implementation parkingAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    
    theCoordinate.latitude = 42.349616;
    theCoordinate.longitude = -71.106911;
    return theCoordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return @"Boston University Central";
}
- (void)setRadius:(CLLocationDistance )newRadius {
    radius = newRadius;
}
-(CLLocationDistance )radius{
    radius = 20000;
    return  radius;
}
-(CLLocationDistance )closeRadius{
    closeRadius = 500;
    return  closeRadius;
}

// optional
- (NSString *)subtitle
{
    NSString *capStr = [self getCapacity];
    NSArray *capAry = [capStr componentsSeparatedByString:@"&"];
    NSString *cap = [capAry objectAtIndex:0];
    NSString *avl = [capAry objectAtIndex:1];
    NSString *CapLabel = @"Capacity:";
    CapLabel = [CapLabel stringByAppendingFormat:@"%@ Available:%@",cap,avl];
    return CapLabel;
}
- (NSString *) getCapacity{
    NSString *strURL =[NSString stringWithFormat:@"http://smartpark.bu.edu/iosApp/getCapacity.php"];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //if([strResult isEqualToString:@"success"])
    return strResult;
}
@end
