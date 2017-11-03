//
//  NSError+Convenience.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "NSError+Convenience.h"

@implementation NSError (Convenience)

+(id) errorWithString:(NSString *)string
{
    return [NSError errorWithDomain:@"twitclient.convenience" code:0 userInfo:@{NSLocalizedDescriptionKey: string}];
}

@end
