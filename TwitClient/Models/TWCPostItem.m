//
//  TWCPostItem.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCPostItem.h"
#import "TWCPostStorageItem+CoreDataClass.h"

@implementation TWCPostItem

-(id) initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.identifier = [dict[@"id"] stringValue];
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

@implementation TWCPostItem(StorageConvenience)

+(TWCPostItem *) fromStorableData: (TWCPostStorageItem *) data
{
    TWCPostItem *post = [TWCPostItem new];
    post.identifier = data.identifier;
    post.text = data.text;
    post.date = data.date;
    post.favouriteCount = data.favouriteCount;
    post.authorName = data.authorName;
    post.authorScreenName = data.authorScreenName;
    return post;
}

@end
