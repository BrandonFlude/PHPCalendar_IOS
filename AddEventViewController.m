//
//  AddEventViewController.m
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Title
    self.navigationItem.title = @"Add Event";
    
    // Set the back button to say back instead of "Your Calendar"
    self.navigationController.navigationBar.topItem.title = @"Back";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addEventButton:(id)sender {
    NSString *user_api_key = [self getAPIKey];
    NSString *event_detail = eventDetails.text;
    NSDate *myDate = datePicker.date;
    
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
    
    NSString *post = [NSString stringWithFormat:@"user_api_key=%@&day=%@&month=%@&year=%@&hour=%@&minute=%@&rotation=%@&event_detail=%@", user_api_key, day, month, year, hour, mins, rotation, event_detail];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Basically accumulate all of this data into a HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://appdev.brandonflude.xyz/api/events"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    // Assign the request to a session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Receive the data and do what I need to do with it, handle the login
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //NSString *responseType = dict[@"type"];
        NSString *responseMessage = dict[@"message"];
        
        // Dispatch an Async task to avoid the delay.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Print out the message from the server
            [self setAlertMessage:responseMessage];
        });
    }] resume];
}

- (NSString *) getAPIKey {
    NSString *user_api_key = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_api_key"];
    return user_api_key;
}

- (void) setAlertMessage:(NSString *)message {
    responseLabel.text = [NSString stringWithFormat:@"%@", message];
}

@end
