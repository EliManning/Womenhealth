//
//  SPsettingsViewController.m
//  SmartParking
//
//  Created by smart_parking on 2/5/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			6.0
#define kTextFieldHeight		30.0
#define kSliderHeight			7.0
#define kProgressIndicatorSize	40.0
#define kUIProgressBarWidth		160.0
#define kUIProgressBarHeight	24.0
#define kViewTag				1
static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kLabelKey = @"labelKey";
static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";

#import "SPsettingsViewController.h"
#import "ExampleAppDataObject.h"
#import "AppDelegateProtocol.h"

@interface SPsettingsViewController ()

@end

@implementation SPsettingsViewController
@synthesize sliderCtl;
@synthesize dataSourceArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSourceArray = [NSMutableArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:
                             @"Set Preference", kSectionTitleKey,
                             @"Better spot                     Cheap price", kLabelKey,
                             self.sliderCtl, kViewKey,
							 nil],nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.dataSourceArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.dataSourceArray objectAtIndex: section] valueForKey:kSectionTitleKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 38;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    
	if ([indexPath row] == 0)
	{
		static NSString *kDisplayCell_ID = @"DisplayCellID";
		cell = [self.tableView dequeueReusableCellWithIdentifier:kDisplayCell_ID];
        if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDisplayCell_ID];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		else
		{
			// the cell is being recycled, remove old embedded controls
			UIView *viewToRemove = nil;
			viewToRemove = [cell.contentView viewWithTag:kViewTag];
			if (viewToRemove)
				[viewToRemove removeFromSuperview];
		}
		
		cell.textLabel.text = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kLabelKey];
		  cell.textLabel.font = [UIFont systemFontOfSize:18.0];
		UIControl *control = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kViewKey];
		[cell.contentView addSubview:control];
	}
	else
	{
		static NSString *kSourceCellID = @"SourceCellID";
		cell = [self.tableView dequeueReusableCellWithIdentifier:kSourceCellID];
        if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			cell.textLabel.opaque = NO;
            cell.textLabel.textColor = [UIColor grayColor];
			cell.textLabel.numberOfLines = 2;
			cell.textLabel.highlightedTextColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:8.0];
        }
		
		cell.textLabel.text = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kSourceKey];
	}
    
	return cell;
}

- (void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
     ExampleAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.preference = [slider value];
     NSLog(@"sliderAction: value = %f",  theDataObject.preference);
}
- (UISlider *)sliderCtl
{
    if (sliderCtl == nil)
    {
        CGRect frame = CGRectMake(110.0, 12.0, 90.0, kSliderHeight);
        sliderCtl = [[UISlider alloc] initWithFrame:frame];
        [sliderCtl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        sliderCtl.backgroundColor = [UIColor clearColor];
        
        sliderCtl.minimumValue = 0.0;
        sliderCtl.maximumValue = 100.0;
        sliderCtl.continuous = YES;
         ExampleAppDataObject* theDataObject = [self theAppDataObject];
        if (theDataObject.preference > 0) {
            sliderCtl.value = theDataObject.preference;
        }
        else{
               sliderCtl.value = 50.0;
        }
		// Add an accessibility label that describes the slider.
		[sliderCtl setAccessibilityLabel:NSLocalizedString(@"StandardSlider", @"")];
		
		sliderCtl.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
    }
    return sliderCtl;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (ExampleAppDataObject*) theAppDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	ExampleAppDataObject* theDataObject;
	theDataObject = (ExampleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
@end
