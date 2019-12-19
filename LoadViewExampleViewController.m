//
//  LoadViewExampleViewController.m
//  Calendar
//
//  Created by Brandon Lyes on 19/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "LoadViewExampleViewController.h"
#import "FSCalendar.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoadViewExampleViewController()<FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDictionary<NSString *, UIImage *> *images;

@end

NS_ASSUME_NONNULL_END

@implementation LoadViewExampleViewController

/*
#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
        self.images = @{@"2016/11/01":[UIImage imageNamed:@"icon_cat"],
                        @"2016/11/05":[UIImage imageNamed:@"icon_footprint"],
                        @"2016/11/20":[UIImage imageNamed:@"icon_cat"],
                        @"2016/11/07":[UIImage imageNamed:@"icon_footprint"]};
    }
    return self;
}
*/

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), view.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:calendar];
    self.calendar = calendar;
    
    // Set the title for this page
    self.navigationItem.title = @"Your Calendar";
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    self.navigationItem.title = @"Your Calendar";
    
    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Add"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(addEvent)];
    self.navigationItem.rightBarButtonItem = addEventButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Logout"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    
    // Trigger the calendar to think it's changed so that it will GET a list of days in the month in view with events on
    [self calendarCurrentPageDidChange:(FSCalendar *)_calendar];
}

-(IBAction)addEvent {
    [self performSegueWithIdentifier:@"addEventSegue" sender:nil];
}

-(IBAction)logout {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user_api_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title = @"Your Calendar";
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - <FSCalendarDelegate>

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    // Fetch the date as a string and send it to the next view
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"date_selected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // User successfully created, forward to the daily view
    [self performSegueWithIdentifier:@"loadDayView" sender:nil];
}

-(void) listOfDays:(NSString*) partialDate {
    NSString *user_api_key = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_api_key"];
    NSString *urlToQuery = [NSString stringWithFormat:@"http://appdev.brandonflude.xyz/api/events-by-month/%@/%@", user_api_key, partialDate];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlToQuery] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Split the result into an array and then just fetch the list of days that have an event on them.
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *daysString = dict[@"days"];
        
        // Save a list of days
        [[NSUserDefaults standardUserDefaults] setObject:daysString forKey:@"valid_days"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }]resume];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    //NSString *dateString = [self.dateFormatter stringFromDate:calendar.currentPage];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

#pragma mark - <FSCalendarDataSource>

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return [self.dateFormatter dateFromString:@"2016/01/01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    return [self.dateFormatter dateFromString:@"2019/12/31"];
}


- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    return self.images[dateString];
}

@end
