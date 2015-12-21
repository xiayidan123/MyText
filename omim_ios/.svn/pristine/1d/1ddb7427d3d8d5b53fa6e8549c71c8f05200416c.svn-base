//
//  Anonymous_Moment_Frame.m
//  dev01
//
//  Created by 杨彬 on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Anonymous_Moment_Frame.h"
#import "OMDateBase_MyClass.h"
#import "OMNetWork_MyClass.h"
#import "ClassBulletinCell.h"


@interface Anonymous_Moment_Frame ()



@end

@implementation Anonymous_Moment_Frame


-(void)dealloc{
    self.moment = nil;
    self.schoolMember = nil;
    [super dealloc];
}


-(void)setMoment:(Anonymous_Moment *)moment{
    
    [_moment release]; _moment = nil;
    _moment = [moment retain];

    SchoolMember *member = [OMDateBase_MyClass fetchClassMemberByClass_id:_moment.class_id andMember_id:_moment.anonymous_uid];
//    if (member == nil){
//        [OMNetWork_MyClass getClassTeachersWithClass_id:self.moment.class_id withCallback:@selector(didGetClassTeacherList:) withObserver:self];
//    }else{
        self.schoolMember = member;
//    }

    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
    
    CGSize text_size = [_moment.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    self.cellHeight =  text_size.height + 30 + 55;
}



//#pragma mark - NetWork CallBack
//- (void)didGetClassTeacherList:(NSNotification *)notif{
//    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
//    if (error.code == NO_ERROR) {
//        self.schoolMember = [OMDateBase_MyClass fetchClassMemberByClass_id:_moment.class_id andMember_id:_moment.anonymous_uid];
//    }
//}





@end
