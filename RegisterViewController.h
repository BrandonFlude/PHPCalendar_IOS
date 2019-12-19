//
//  RegisterViewController.h
//  Calendar
//
//  Created by Brandon Lyes on 19/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController {
    
    IBOutlet UILabel *usernameFieldLabel;
    IBOutlet UILabel *passwordFieldLabel;
    IBOutlet UILabel *confirmPasswordFieldLabel;
    IBOutlet UILabel *responseLabel;
    IBOutlet UIButton *registerButton;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPassword;
}

- (IBAction) registerButton:(id)sender;
- (void) register;

@end
