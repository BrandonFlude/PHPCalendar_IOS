//
//  DailyEventsViewController.h
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyEventsModel.h"
#import "EventTableCell.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface DailyEventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DailyEventsModelProtocol>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
