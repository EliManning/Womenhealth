//
//  SPHistoryRecordView.h
//  SmartParking
//
//  Created by smart_parking on 1/28/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDataObject.h"
#import "ExampleAppDataObject.h"
#import "SPAppDelegate.h"
@interface SPHistoryRecordView : UITableViewController{
	NSMutableArray *recordList;
   // ExampleAppDataObject* theDataObject;
    NSManagedObjectContext *managedObjectContext;
    IBOutlet UITableView *tblSimpleTable;
}

- (IBAction)backButton:(id)sender;
@property (strong,nonatomic) SPAppDelegate *myDelegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	  
@property (nonatomic, retain) NSMutableArray *recordList;
@property (nonatomic, readwrite) NSString *address;
- (IBAction) EditTable:(id)sender;
@end
