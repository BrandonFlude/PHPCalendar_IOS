//
//  DailyEventsModel.m
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "DailyEventsModel.h"
#import "Event.h"

@interface DailyEventsModel() {
    NSMutableData *_downloadedData;
}
@end

@implementation DailyEventsModel

- (void)downloadItems {
    // Fetch date in view and api_key
    NSString *user_api_key = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_api_key"];
    NSString *date_selected = [[NSUserDefaults standardUserDefaults] stringForKey:@"date_selected"];
    
    // Split the dateString up so we can reformat it to query the database with a GET request
    NSArray *date = [date_selected componentsSeparatedByString:@"/"];
    NSString *year = date[0];
    NSString *month = date[1];
    NSString *day = date[2];
    
    NSString *date_dt = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];

    NSString *url = [NSString stringWithFormat:@"http://appdev.brandonflude.xyz/api/events-by-date/%@/%@", user_api_key, date_dt];
        
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Create an array to store the locations
    NSMutableArray *_Events = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingMutableLeaves error:nil];;
    
    NSString *count = jsonArray[@"count"];
    NSInteger countOfEvents = [count intValue];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 1; i <= countOfEvents; i++)
    {
        
        // Create a new location object and set its props to JsonElement properties
        Event *newEvent = [[Event alloc] init];
        
        // Append i to the data
        NSString *event_idPull = [NSString stringWithFormat:@"event_id%d", i];
        NSString *event_tmPull = [NSString stringWithFormat:@"time_of_event%d", i];
        NSString *event_detailPull = [NSString stringWithFormat:@"event_detail%d", i];
        NSString *event_datePull = [NSString stringWithFormat:@"event_dt%d", i];
        
        newEvent.event_id = jsonArray[event_idPull];
        newEvent.event_dt = jsonArray[@"event_dt_parsed"];
        newEvent.event_tm = jsonArray[event_tmPull];
        newEvent.event_detail = jsonArray[event_detailPull];
        newEvent.event_dt_default = jsonArray[event_datePull];
    
        // Add this question to the locations array
        [_Events addObject:newEvent];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate) {
        [self.delegate itemsDownloaded:_Events];
    }
}

@end
