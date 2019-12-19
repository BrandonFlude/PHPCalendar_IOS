//
//  AddEventViewController.h
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventViewController : UIViewController {
    IBOutlet UILabel *eventNameFieldLabel;
    IBOutlet UILabel *dateTimeFieldLabel;
    IBOutlet UILabel *responseLabel;
    IBOutlet UIButton *addEventButton;
    IBOutlet UITextField *eventDetails;
    IBOutlet UIDatePicker *datePicker;
}

- (IBAction)addEventButton:(id)sender;

@end
