//
//  OfficialCell.m
//  dev01
//
//  Created by jianxd on 14-12-19.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "OfficialCell.h"

@implementation OfficialCell

@synthesize thumbImageView = _thumbImageView;
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.thumbImageView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        _thumbImageView.frame = CGRectMake(8, 5, 40, 40);
        _nameLabel.frame = CGRectMake(56, 15, 250, 21);
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_thumbImageView];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_thumbImageView release];
    [_nameLabel release];
    [super dealloc];
}

@end
