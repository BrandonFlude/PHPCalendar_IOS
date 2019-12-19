//
//  EditEventViewController.m
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "EditEventViewController.h"

@interface EditEventViewController ()

@end

@implementation EditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title for this page
    self.navigationItem.title = @"Update Your Event";
        
    // Populate all the fields with the event data so they can quickly edit
    _event_detail_field.text = _selectedEvent.event_detail;
    
    // Set the date picker to the time of the event
    NSString *dateTime = _selectedEvent.event_dt_default;
    NSString *dateString = dateTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateString];
    [_event_date_time_field setDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateEventButton:(id)sender {
    // Generate string I will need with the data to put
    NSString *fullURL = [NSString stringWithFormat:@"http://appdev.brandonflude.xyz/api/events/%@", _selectedEvent.event_id];
    
    // Split the value of the date picker up so we can send it back to the API.
    NSDate *myDate = _event_date_time_field.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY MM dd hh mm aa"];
    NSString *parsedDate = [dateFormat stringFromDate:myDate];
    
    NSArray *dateArray = [parsedDate componentsSeparatedByString:@" "];
    NSString *year = dateArray[0];
    NSString *month = dateArray[1];
    NSString *day = dateArray[2];
    NSString *hour = dateArray[3];
    NSString *mins = dateArray[4];
    NSString *rotation = dateArray[5];
    
    NSString *put = [NSString stringWithFormat:@"user_api_key=%@&event_detail=%@&day=%@&month=%@&year=%@&hour=%@&minute=%@&rotation=%@", [self getAPIKey], _event_detail_field.text, day, month, year, hour, mins, rotation];
    NSData *putData = [put dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *putLength = [NSString stringWithFormat:@"%lu", (unsigned long)[putData length]];
    
    // Basically accumulate all of this data into a HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:fullURL]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:putData];
    
    // Assign the request to a session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Receive the data and do what I need to do with it, handle the login
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *responseType = dict[@"type"];
        NSString *responseMessage = dict[@"message"];
        
        // Dispatch an Async task to avoid the delay.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Print out the message from the server
            if([responseType isEqual: @"success"]) {
                // Push them back to the calendar view
                [self performSegueWithIdentifier:@"pushBackToCalendar" sender:nil];
            }
            [self setAlertMessage:responseMessage];
        });
    }] resume];
}

- (IBAction)deleteEventButton:(id)sender {
    // Generate string I will need with the data to put
    NSString *fullURL = [NSString stringWithFormat:@"http://appdev.brandonflude.xyz/api/events/delete/%@/%@", [self getAPIKey], _selectedEvent.event_id];
    
    // Basically accumulate all of this data into a HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:fullURL]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Assign the request to a session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Receive the data and do what I need to do with it, handle the login
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *responseType = dict[@"type"];
        NSString *responseMessage = dict[@"message"];
        
        // Dispatch an Async task to avoid the delay.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Print out the message from the server
            if([responseType isEqual: @"success"]) {
                // Push them back to the calendar view
                [self performSegueWithIdentifier:@"pushBackToCalendar" sender:nil];
            }
            [self setAlertMessage:responseMessage];
        });
    }] resume];
}

- (NSString *) getAPIKey {
    NSString *user_api_key = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_api_key"];
    return user_api_key;
}

- (void) setAlertMessage:(NSString *)message {
    _responseLabel.text = [NSString stringWithFormat:@"%@", message];
}

@end
