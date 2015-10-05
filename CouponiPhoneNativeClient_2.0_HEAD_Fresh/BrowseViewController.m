//
//  BrowseViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/12/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "BrowseViewController.h"
#import "RivePointAppDelegate.h"
#import "PoiRequestParams.h"
#import "BrowseViewCell.h"
#import "GeneralUtil.h"
#import "RightBarButtonItemsController.h"

@implementation BrowseViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[GeneralUtil setRivepointLogo:self.navigationItem];
	
	RightBarButtonItemsController *rBarButtonItemsController = [[RightBarButtonItemsController alloc] initWithNibName:@"RightBarButtonItems" bundle:nil];
	UIImageView *imgView = (UIImageView *) rBarButtonItemsController.view ;
	imgView.image=[[UIImage imageNamed:@"rigntBarItem_bg.png"] autorelease];
	[rBarButtonItemsController.nextButton setHidden:YES];
	[rBarButtonItemsController.prevButton setHidden:YES];
	UIBarButtonItem *rightTopBarItem = [[[UIBarButtonItem alloc] initWithCustomView:imgView] autorelease];
	[imgView release];
	[rBarButtonItemsController release];
	
	self.navigationItem.rightBarButtonItem = rightTopBarItem;
	
	
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate resetGetCouponPoiList];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)setCategoryAndGo:(NSString *) catrgory{
	appDelegate.categoryId = catrgory;
	appDelegate.currentPoiCommand = (int)BROWSE_POI_COMMAND;
	if(mvController == nil)
		mvController = [[BrowseVendorController alloc] initWithNibName:@"ListVendorView" bundle:nil];
	

	[[self navigationController] pushViewController:mvController animated:YES];
}
-(IBAction) coffeeClick{
	[self setCategoryAndGo:@"9996"];
}
-(IBAction) americanClick{
	[self setCategoryAndGo:@"4"];
}
-(IBAction) chineseClick{
	[self setCategoryAndGo:@"3"];
}
-(IBAction) italianClick{
	[self setCategoryAndGo:@"9"];
}
-(IBAction) ffoodClick{
	[self setCategoryAndGo:@"27"];
}
-(IBAction) mexicanClick{
	[self setCategoryAndGo:@"47"];
}
-(IBAction) snacksClick{
	[self setCategoryAndGo:@"58"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)viewWillAppear:(BOOL)animated{
	[self setNavigationBarHidden:NO animated:NO];
	//[appDelegate resetGetCouponPoiList];
	[appDelegate resetBrowsePoiList];
	
}

- (void) setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
	[[self navigationController] setNavigationBarHidden:hidden animated:NO];
	
	CGRect frame = self.navigationController.navigationBar.frame;
	int height = [[UIScreen mainScreen] bounds].size.height  - frame.size.height;
	int width = frame.size.width;
	self.view.bounds = CGRectMake(0, 0, width, height);
	
	self.view.center = CGPointMake(width/2, height/2 );
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)dealloc {
    [super dealloc];
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"BrowseViewController:didSelectRowAtIndexPath cell clicked {%d, %d}}", indexPath.row, indexPath.section);
	[self runCatgoryAndGoForSelectedRow:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *browseCell = @"BrowseViewCell";
								 
	BrowseViewCell *cell = (BrowseViewCell *)[tv dequeueReusableCellWithIdentifier:browseCell];
	if(nil == cell) {
		UIViewController *cLstCellController = [[UIViewController alloc] initWithNibName:browseCell bundle:nil];
		cell = (BrowseViewCell *) cLstCellController.view;
		[cLstCellController release];
	}
	[cell setCellData:indexPath.row];

	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;	
}

-(void) runCatgoryAndGoForSelectedRow:(NSInteger )rowSelected{
	NSLog(@"## Selected Row  runCatgoryAndGoForSelectedRow {%d}", rowSelected);
	NSArray *categoryIds = [[[NSArray alloc] initWithObjects:@"9996",@"4",@"3",@"9", @"27", @"47",@"58", nil]autorelease];
	
	[self setCategoryAndGo:[categoryIds objectAtIndex:rowSelected] ];
}

@end
