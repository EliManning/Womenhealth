//
//  Event.h
//  SmartParking
//
//  Created by smart_parking on 2/5/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * userID;

@end
