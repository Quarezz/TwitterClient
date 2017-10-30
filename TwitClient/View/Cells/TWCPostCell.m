//
//  TWCPostCell.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCPostCell.h"
#import "TWCPostItem.h"

@interface TWCPostCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *favCountLabel;

@end

@implementation TWCPostCell

-(void) setData:(TWCPostItem *)data
{
    self.nameLabel.text = data.authorName;
    self.nicknameLabel.text = [NSString stringWithFormat:@"@%@",data.authorScreenName];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd HH:mm";
    self.dateLabel.text = [formatter stringFromDate:data.date];
    
    self.contentLabel.text = data.text;
    self.favCountLabel.text = [NSString stringWithFormat:@"%ld",data.favouriteCount];
}

@end

