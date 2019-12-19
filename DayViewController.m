//
//  DayViewController.m
//  AppDev Calendar
//
//  Created by Brandon Flude on 20/03/2017.
//  Copyright © 2017 wenchaoios. All rights reserved.
//

#import "DayViewController.h"

@interface DayViewController ()

@end

@implementation DayViewController

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
    
    // Set the back button to say back instead of "Your Calendar"
    self.navigationController.navigationBar.topItem.title = @"Back";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
