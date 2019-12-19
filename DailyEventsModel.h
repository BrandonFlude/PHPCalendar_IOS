//
//  DailyEventsModel.h
//  AppDev Calendar
//
//  Created by Brandon Lyes on 20/03/2017.
//  Copyright © 2017 Brandon Lyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DailyEventsModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface DailyEventsModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<DailyEventsModelProtocol> delegate;

- (void)downloadItems;

@end
