//
//  TWCPostItem.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWCPostStorageItem;

@interface TWCPostItem : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSUInteger favouriteCount;

@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorScreenName;

-(id) initWithDictionary: (NSDictionary *) dict;

@end

@interface TWCPostItem(StorageConvenience)

+(TWCPostItem *) fromStorableData: (TWCPostStorageItem *) data;

@end
