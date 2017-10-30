//
//  TWCPostItem.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCPostItem.h"

@implementation TWCPostItem

-(id) initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.identifier = dict[@"id"];
        self.text = dict[@"text"];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        //Wed, 27 Aug 2008 13:08:45 +00:00
        dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
        self.date = [dateFormatter dateFromString:dict[@"created_at"]];
        self.favouriteCount = [dict[@"favorited"] unsignedIntegerValue];
        
        NSDictionary *userDict = dict[@"user"];
        if ([userDict isKindOfClass:[NSDictionary class]])
        {
            self.authorName = userDict[@"name"];
            self.authorScreenName = userDict[@"screen_name"];
        }
    }
    return self;
}

@end
