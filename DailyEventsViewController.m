//
//  DailyEventsViewController.m
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "DailyEventsViewController.h"
#import "Event.h"
#import "EventTableCell.h"
#import "EditEventViewController.h"

@interface DailyEventsViewController () {
    DailyEventsModel *_dailyEventsModel;
    NSArray *_feedItems;
    Event *_selectedEvent;
}

@end

@implementation DailyEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *months[12] = {@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"};
    
    // Fetch the day they selected on the calendar
    NSString *dateString = [[NSUserDefaults standardUserDefaults] stringForKey:@"date_selected"];
    
    // Split the dateString up so we can reformat it to query the database with a GET request
    NSArray *date = [dateString componentsSeparatedByString:@"/"];
    NSString *year = date[0];
    NSString *month = date[1];
    NSString *day = date[2];
    
    NSString *monthAsWord = months[month.intValue - 1];
    
    // Set title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@ %@", day, monthAsWord, year];
    
    // Set this view controller object as the delegate and data source for the table view
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    // Create array object and assign it to _feedItems variable
    _feedItems = [[NSArray alloc] init];
    
    // Create new HomeModel object and assign it to _homeModel variable
    _dailyEventsModel = [[DailyEventsModel alloc] init];
    
    // Set this view controller object as the delegate for the home model object
    _dailyEventsModel.delegate = self;
    
    // Call the download items method of the home model object
    [_dailyEventsModel downloadItems];
}

-(void)viewDidAppear:(BOOL)animated {
    // Load it back into to view to refresh if any changes have been made
    [self viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.listTableView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemsDownloaded:(NSArray *)items {
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
        
    // Reload the table view
    [self.listTableView reloadData];
}

#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of feed items (initially 0)
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"EventTableCell";
    
    EventTableCell *cell = (EventTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Fetch Information for the Cell
    Event *item = _feedItems[indexPath.row];
    
    cell.event_id.text = item.event_id;
    cell.event_detail.text = item.event_detail;
    cell.event_tm.text = item.event_tm;
    cell.event_dt.text = item.event_dt;
    
    // Return the Cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set selected location to var
    _selectedEvent = _feedItems[indexPath.row];
    
    // Manually call segue to detail view controller
    [self performSegueWithIdentifier:@"showEditView" sender:self];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,3)];
    additionalSeparator.backgroundColor = [UIColor whiteColor];
    [cell addSubview:additionalSeparator];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get reference to the destination view controller
    EditEventViewController *detailVC = segue.destinationViewController;
    
    // Set the property to the selected location so when the view for
    // detail view controller loads, it can access that property to get the feeditem obj
    detailVC.selectedEvent = _selectedEvent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.00;
}

@end
