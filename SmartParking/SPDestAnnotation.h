//
//  SPDestAnnotation.h
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface parkingAnnotation : MKPinAnnotationView <MKAnnotation>{
  CLLocationDistance radius;
    CLLocationDistance closeRadius;
}
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, readwrite) CLLocationDistance radius;
@property (nonatomic, readwrite) CLLocationDistance closeRadius;
@end
