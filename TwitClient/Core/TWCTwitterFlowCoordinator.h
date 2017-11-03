//
//  TWCTwitterFlowCoordinator.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TWCFeedTableViewController;

@interface TWCTwitterFlowCoordinator : NSObject

-(UIViewController *) initialViewController;

-(void) navigateToComposerWithUserId: (NSString *) userId;

@end
