//
//  SPKeychainItem.h
//  SmartParking
//
//  Created by smart_parking on 2/3/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPKeychainItem : NSObject
{
    NSMutableDictionary *keychainItemData;		// The actual keychain item data backing store.
    NSMutableDictionary *genericPasswordQuery;	// A placeholder for the generic keychain item query used to locate the item.
}

@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;
@end
