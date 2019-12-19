//
//  RegisterViewController.m
//  Calendar
//
//  Created by Brandon Lyes on 19/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title for this page
    self.navigationItem.title = @"Register";
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButton:(id)sender {
    [self register];
}

- (void) register {
    // Generate string I will need with the data to post, in this case it's a username and password
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&confirm_password=%@", username.text, password.text, confirmPassword.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Basically accumulate all of this data into a HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://appdev.brandonflude.xyz/api/register"]];
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
        
        // Dispatch an Async task to avoid the delay.
        dispatch_async(dispatch_get_main_queue(), ^{
            if([responseType  isEqual: @"success"]) {
                // User successfully created, forward to the login view
                [self performSegueWithIdentifier:@"goBackToLogin" sender:nil];
            }
            
            // Print out the message from the server
            [self setAlertMessage:responseMessage];
        });
    }] resume];
}

- (void) setAlertMessage:(NSString *)message {
    responseLabel.text = [NSString stringWithFormat:@"%@", message];
}


@end
