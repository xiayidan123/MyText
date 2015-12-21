//
//  SearchUserResultCell.m
//  dev01
//
//  Created by 杨彬 on 15/2/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SearchUserResultCell.h"

@interface SearchUserResultCell ()


@property (retain, nonatomic) IBOutlet UILabel *id_titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *id_contentLabel;

@property (retain, nonatomic) IBOutlet UILabel *nickName_titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *nickName_contentLabel;
@property (retain, nonatomic) IBOutlet UIButton *add_button;

- (IBAction)addAction:(id)sender;

@end


@implementation SearchUserResultCell

- (void)dealloc {
    [_headImageView release],_headImageView = nil;
    [_id_titleLabel release],_id_titleLabel = nil;
    [_id_contentLabel release],_id_contentLabel = nil;
    [_nickName_titleLabel release],_nickName_titleLabel = nil;
    [_nickName_contentLabel release],_nickName_contentLabel = nil;
    [_add_button release],_add_button = nil;
    [_buddy release],_buddy = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [self uifConfig];
}


- (void)uifConfig{
    _id_titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"帐号",nil)];
    _nickName_titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"Nickname",nil)];
    _add_button.layer.cornerRadius = 3;
    _add_button.layer.masksToBounds = YES;
    self.status = NOTADD;
    
    _searchLenght = self.inputSearchContent.length;
    
    [self MakeLabelTextHighlight];
    
    
}
- (void)setInputSearchContent:(NSString *)inputSearchContent
{
    _inputSearchContent = inputSearchContent;
    
}
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    NSInteger location = [_nickName_contentLabel.text rangeOfString:_inputSearchContent options:NSCaseInsensitiveSearch].location;
    NSInteger length = [_nickName_contentLabel.text rangeOfString:_inputSearchContent options:NSCaseInsensitiveSearch].length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_nickName_contentLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location,length)];
    if (self.selectedIndex) {
        _id_contentLabel.attributedText = str;
    }
    else
    {
        _nickName_contentLabel.attributedText = str;
    }
}
- (void)MakeLabelTextHighlight
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStatus:(SearchUserResultCellStatus)status{
    _status = status;
    switch (_status) {
        case NOTADD:{
            [_add_button setTitle:NSLocalizedString(@"Add",nil) forState:UIControlStateNormal];
            _add_button.backgroundColor = [UIColor colorWithRed:0.11 green:0.68 blue:0.98 alpha:1];
        }break;
        case ADDING:{
            [_add_button setTitle:NSLocalizedString(@"Adding",nil) forState:UIControlStateNormal];
            _add_button.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];
        }break;
        case DIDADD:{
            [_add_button setTitle:NSLocalizedString(@"Already Added",nil) forState:UIControlStateNormal];
            _add_button.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];
        }break;
        case ISSELF:{
            [_add_button setTitle:NSLocalizedString(@"Is Self",nil) forState:UIControlStateNormal];
            _add_button.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];
        }break;
        default:
            break;
    }
}

-(void)setBuddy:(Buddy *)buddy{
    [_buddy release],_buddy = nil;
    _buddy = [buddy retain];
    _id_contentLabel.text = _buddy.wowtalkID;
    _nickName_contentLabel.text = _buddy.nickName;

}




- (IBAction)addAction:(id)sender {
    if (_status == ADDING || _status == DIDADD) return;// 加过的和正在加的
    if (_status == ISSELF && [_delegate respondsToSelector:@selector(addMySelf)]){// 是自己
        [_delegate addMySelf];
        return;
    }
    if ([_delegate respondsToSelector:@selector(addFriendWithBuddy:)]){
        [_delegate addFriendWithBuddy:_buddy];
    }
}
@end