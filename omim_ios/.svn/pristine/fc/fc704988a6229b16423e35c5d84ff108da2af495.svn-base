//
//  EvaluateTableViewCell.m
//  dev01
//
//  Created by mac on 14/12/26.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "EvaluateTableViewCell.h"

@implementation EvaluateTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self createData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createData
{
  NSMutableArray * dataArray = [[NSMutableArray alloc] initWithObjects:@"精神状态",@"参与程度",@"参与效果",@"认真",@"自信",@"思维的条理性",@"思维的创造性",@"善于与人合作", nil];
   NSMutableArray * detailDataArray = [[NSMutableArray alloc] initWithObjects:@"Spirit",@"participate",@"Effect",@"Serious",@"Self Confidence",@"Organization",@"Creative ",@"Corporation", nil];
    for (int i = 0; i < dataArray.count; i++) {
        self.state.text = [dataArray objectAtIndex:i++];
    }
    for (int i = 0; i < detailDataArray.count; i++) {
        self.stateEnglish .text = [detailDataArray objectAtIndex:i];
    }

}

- (void)dealloc {
    [_state release];
    [_stateEnglish release];
    [_stateBtn release];
    [_goodbtn release];
    [_striveBtn release];
    [super dealloc];
}
- (IBAction)stateBtn:(id)sender {
    [self.stateBtn setImage:[UIImage imageNamed:@"share_vote_checked.png"] forState:UIControlStateNormal];
}

- (IBAction)goodbtn:(id)sender {
    [self.goodbtn setImage:[UIImage imageNamed:@"share_vote_checked.png"] forState:UIControlStateNormal];
}

- (IBAction)striveBtn:(id)sender {
    [self.striveBtn setImage:[UIImage imageNamed:@"share_vote_checked.png"] forState:UIControlStateNormal];
}
@end
