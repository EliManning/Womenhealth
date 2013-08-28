//
//  SPPinAnnotation.h
//  SmartParking
//
//  Created by smart_parking on 1/25/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface destAnnotation : MKPinAnnotationView<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSString *title;
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *subtitle;
@property (nonatomic,retain) NSString *title;

- (id) initWithCoords:(CLLocationCoordinate2D) coords;
@end

