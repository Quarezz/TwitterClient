//
//  TWCPostCell.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWCPostItem;

@interface TWCPostCell : UITableViewCell

-(void) setData: (TWCPostItem *) data;

@end
