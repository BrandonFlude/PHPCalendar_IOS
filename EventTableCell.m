//
//  EventTableCell.m
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import "EventTableCell.h"

@implementation EventTableCell
@synthesize event_id = _event_id;
@synthesize event_dt = _event_dt;
@synthesize event_tm = _event_tm;


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
