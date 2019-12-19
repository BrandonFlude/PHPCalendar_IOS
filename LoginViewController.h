//
//  LoginViewController.h
//  Calendar
//
//  Created by Brandon Lyes on 19/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    IBOutlet UILabel *usernameFieldLabel;
    IBOutlet UILabel *passwordFieldLabel;
    IBOutlet UILabel *responseLabel;
    IBOutlet UIButton *loginButton;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}


- (IBAction) loginButton : (id) sender;
- (void) login;
- (BOOL) isLoggedIn;
- (void) setAPIKey: (NSString *) user_api_key;

@end

