//
//  Event.h
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *event_dt;
@property (nonatomic, strong) NSString *event_tm;
@property (nonatomic, strong) NSString *event_detail;
@property (nonatomic, strong) NSString *event_dt_default;

@end
