//
//  SPHistoryRecordView.m
//  SmartParking
//
//  Created by smart_parking on 1/28/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//

#import "SPHistoryRecordView.h"
#import "Event.h"
#import "SPAppDelegate.h"
#import "SPMainMapViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"
@interface SPHistoryRecordView ()

@end

@implementation SPHistoryRecordView
@synthesize recordList;
@synthesize editButton;
@synthesize managedObjectContext;
@synthesize myDelegate = _myDelegate;
@synthesize address=_address;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myDelegate = (SPAppDelegate *)[[UIApplication sharedApplication] delegate];
     //self.managedObjectContext = [self managedObjectContext];
    [self fetchCoreData];
    self.title = @"History";
    
   
}

    
-(void)fetchCoreData{
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.myDelegate.managedObjectContext];
        [request setEntity:entity];
        
        // Order the events by creation date, most recent first.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[self.myDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResults == nil) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
        }
        self.recordList = mutableFetchResults;
        
        NSLog(@"The count of entry:%i",[self.recordList count]);
        
        for (Event *event in self.recordList) {
            NSLog(@"Address:%@---Date:%@",event.address,event.creationDate);
        }
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self recordList]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
    static NSString *CellIdentifier = @"PlayCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	//cell.textLabel.text = [[self.recordList objectAtIndex:indexPath.row] objectForKey:kTitleKey];
  // cell.textLabel.text  = [self.recordList objectAtIndex:indexPath.row];
    Event *event = (Event *)[self.recordList objectAtIndex:indexPath.row];
	cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];
	
	/*NSString *string = [NSString stringWithFormat:@"%@, %@",
						[numberFormatter stringFromNumber:[event latitude]],
						[numberFormatter stringFromNumber:[event longitude]]];*/
    cell.detailTextLabel.text = [event address];   // cell.detailTextLabel.text = @"aaa";
	return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [recordList objectAtIndex:indexPath.row];
		[self.myDelegate.managedObjectContext deleteObject:eventToDelete];
		
		// Update the array and table view.
        [recordList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// Commit the change.
		NSError *error;
		if (![self.myDelegate.managedObjectContext  save:&error]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
		}
        else{
            NSLog(@"Delete success");
        }
    }
}
/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already
    // existing content. Existing content can be deleted.
    if (self.editing && indexPath.row == ([self.recordList count])) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
    return UITableViewCellEditingStyleNone;
}
 */
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   self.address = cell.detailTextLabel.text;
    NSLog(@"you select %@",self.address);
    ExampleAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.destAddress = self.address;
   // theDataObject.parkingCondition = @"fromHistoryToPin";
    theDataObject.method = @"fromHistoryToPin";
    UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapBoard"];
    [self.navigationController pushViewController:manuView animated:YES];
}



- (IBAction)EditTable:(id)sender{
	if(self.editing)
	{
        self.editButton.title = @"Edit";
        [self.editButton setStyle:UIBarButtonItemStylePlain];
		[super setEditing:NO animated:NO];
		[tblSimpleTable setEditing:NO animated:NO];
		[tblSimpleTable reloadData];
	}
	else
	{
        self.editButton.title = @"Done";
        [self.editButton setStyle:UIBarButtonItemStyleDone];
		[super setEditing:YES animated:YES];
		[tblSimpleTable setEditing:YES animated:YES];
		[tblSimpleTable reloadData];
	}
}


//Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (IBAction)backButton:(id)sender {
    UIViewController *manuView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapBoard"];
    [self.navigationController pushViewController:manuView animated:YES];
}

- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

@end
