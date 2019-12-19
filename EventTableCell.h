//
//  FixtureTableCell.h
//  Your NFL
//
//  Created by Brandon Lyes on 10/12/2015.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *event_id;
@property (nonatomic, weak) IBOutlet UILabel *event_dt;
@property (nonatomic, weak) IBOutlet UILabel *event_tm;
@property (nonatomic, weak) IBOutlet UILabel *event_detail;

@end
