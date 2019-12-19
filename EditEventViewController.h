//
//  EditEventViewController.h
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EditEventViewController : UIViewController {
    IBOutlet UIButton *updateEventButton;
}

@property (weak, nonatomic) IBOutlet UILabel *event_id;
@property (weak, nonatomic) IBOutlet UILabel *event_dt;
@property (weak, nonatomic) IBOutlet UILabel *event_detail;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UITextField *event_detail_field;
@property (weak, nonatomic) IBOutlet UIDatePicker *event_date_time_field;
@property (strong, nonatomic) Event *selectedEvent;

-(IBAction)updateEventButton:(id)sender;
-(IBAction)deleteEventButton:(id)sender;

@end
