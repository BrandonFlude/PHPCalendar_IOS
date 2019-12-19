//
//  LoginViewController.m
//  Calendar
//
//  Created by Brandon Lyes on 19/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title for this page
    self.navigationItem.title = @"Login";
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    //BOOL isLoggedIn = [self isLoggedIn];
}

- (IBAction)loginButton:(id)sender {
    [self login];
}

- (BOOL) isLoggedIn {
    NSString *user_api_key = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_api_key"];
    
    if(user_api_key == nil) {
        return false;
    } else {
        return true;
    }
}

- (void) login {
    // Generate string I will need with the data to post, in this case it's a username and password
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", username.text, password.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Basically accumulate all of this data into a HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://appdev.brandonflude.xyz/api/login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    // Assign the request to a session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Receive the data and do what I need to do with it, handle the login
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *responseType = dict[@"type"];
        NSString *responseMessage = dict[@"message"];
        NSString *responseAPIKey = dict[@"user_api_key"];
        
        // Dispatch an Async task to avoid the delay.
        dispatch_async(dispatch_get_main_queue(), ^{
            if([responseType  isEqual: @"success"]) {
                // Set their API Key and save it to the device
                [self setAPIKey:responseAPIKey];
                
                // Forward to the calendar view
                [self performSegueWithIdentifier:@"goToCalendarView" sender:nil];
            }
            
            // Print out the message from the server
            [self setAlertMessage:responseMessage];
        });
    }] resume];
}

- (void) setAPIKey:(NSString *)responseAPIKey {
    [[NSUserDefaults standardUserDefaults] setObject:responseAPIKey forKey:@"user_api_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getAPIKey {
    NSString *user_api_key = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_api_key"];
    return user_api_key;
}

- (void) setAlertMessage:(NSString *)message {
    responseLabel.text = [NSString stringWithFormat:@"%@", message];
}

@end
