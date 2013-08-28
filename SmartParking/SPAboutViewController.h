//
//  SPAboutViewController.h
//  SmartParking
//
//  Created by smart_parking on 1/30/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAboutViewController : UITableViewController{
    NSMutableArray *menuList;
    // ExampleAppDataObject* theDataObject;
    IBOutlet UITableView *tblSimpleTable;
}
@property (nonatomic, retain) NSMutableArray *menuList;

@end
