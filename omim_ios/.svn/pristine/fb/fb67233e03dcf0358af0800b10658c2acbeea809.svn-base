//
//  Communicator_GetSchoolMembers.m
//  dev01
//
//  Created by 杨彬 on 14-12-1.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetSchoolMembers.h"
#import "OMDateBase_MyClass.h"
#import "PersonModel.h"

@implementation Communicator_GetSchoolMembers

-(void)dealloc{
    self.class_id = nil;
    [super dealloc];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    NSMutableDictionary *infoDic = nil;
    NSString *class_id = nil;
    if (errNo == NO_ERROR)
    {
        if (self.member_type == 0){
            [Database deleteMySchoolMembers];
        }else{
            [OMDateBase_MyClass deleteCLassMembersWithClass_id:self.class_id withMember_type:self.member_type];
        }
        
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_school_members"];
        
        if ([[infoDic objectForKey:@"school"] isKindOfClass:[NSMutableArray class]]) {
            NSArray *schoolArray = infoDic[@"school"];
            for (int i=0; i<schoolArray.count; i++){
                id classroom = [schoolArray[i] objectForKey:@"classroom"];
                if ([classroom isKindOfClass:[NSArray class]]){

                    for (int j=0; j< ((NSArray *)classroom).count; j++){
                        class_id = classroom[j][@"group_id"];
                        id members = [((NSArray *)classroom)[j] objectForKey:@"member"];
                        if ([members isKindOfClass:[NSArray class]]){
                            for (int k=0; k< ((NSArray *)members).count; k++){
                                PersonModel *personModel = [[PersonModel alloc]init];
                                personModel.uid = ((NSArray *)members)[k][@"uid"];
                                personModel.nickName = ((NSArray *)members)[k][@"nickname"];
                                personModel.upload_photo_timestamp = ((NSArray *)members)[k][@"upload_photo_timestamp"];
                                personModel.user_type = ((NSArray *)members)[k][@"user_type"];
                                personModel.alias = ((NSArray *)members)[k][@"alias"];
                                personModel.class_id = class_id;
                                [Database storeSchoolMember:personModel];
                                [personModel release];
                            }
                        }else if ([members isKindOfClass:[NSDictionary class]]){
                            PersonModel *personModel = [[PersonModel alloc]init];
                            personModel.uid = ((NSDictionary *)members)[@"uid"];
                            personModel.nickName = ((NSDictionary *)members)[@"nickname"];
                            personModel.upload_photo_timestamp = ((NSDictionary *)members)[@"upload_photo_timestamp"];
                            personModel.user_type = ((NSDictionary *)members)[@"user_type"];
                            personModel.alias = ((NSDictionary *)members)[@"alias"];
                            personModel.class_id = class_id;
                            [Database storeSchoolMember:personModel];
                            [personModel release];
                        }
                    }
                }else if ([classroom isKindOfClass:[NSDictionary class]]){
                    class_id = classroom[@"group_id"];
                    id members = [((NSDictionary *)classroom) objectForKey:@"member"];
                    if ([members isKindOfClass:[NSArray class]]){
                        for (int k=0; k< ((NSArray *)members).count; k++){
                            PersonModel *personModel = [[PersonModel alloc]init];
                            personModel.uid = ((NSArray *)members)[k][@"uid"];
                            personModel.nickName = ((NSArray *)members)[k][@"nickname"];
                            personModel.upload_photo_timestamp = ((NSArray *)members)[k][@"upload_photo_timestamp"];
                            personModel.user_type = ((NSArray *)members)[k][@"user_type"];
                            personModel.alias = ((NSArray *)members)[k][@"alias"];
                            personModel.class_id = class_id;
                            [Database storeSchoolMember:personModel];
                            [personModel release];
                        }
                    }else if ([members isKindOfClass:[NSDictionary class]]){
                        PersonModel *personModel = [[PersonModel alloc]init];
                        personModel.uid = ((NSDictionary *)members)[@"uid"];
                        personModel.nickName = ((NSDictionary *)members)[@"nickname"];
                        personModel.upload_photo_timestamp = ((NSDictionary *)members)[@"upload_photo_timestamp"];
                        personModel.user_type = ((NSDictionary *)members)[@"user_type"];
                        personModel.alias = ((NSDictionary *)members)[@"alias"];
                        personModel.class_id = class_id;
                        [Database storeSchoolMember:personModel];
                        [personModel release];
                    }
                }
            }
            
        } else if ([[infoDic objectForKey:@"school"] isKindOfClass:[NSMutableDictionary class]]) {
            if ([[infoDic[@"school"] objectForKey:@"classroom"] isKindOfClass:[NSMutableArray class]]){
                for (NSDictionary *dic in [infoDic[@"school"] objectForKey:@"classroom"]){
                    class_id = dic[@"group_id"];
                    if ([dic[@"member"] isKindOfClass:[NSMutableArray class]]){
                        for (NSDictionary *diction in dic[@"member"]){
                            PersonModel *personModel = [[PersonModel alloc]init];
                            personModel.uid = diction[@"uid"];
                            personModel.nickName = diction[@"nickname"];
                            personModel.upload_photo_timestamp = diction[@"upload_photo_timestamp"];
                            personModel.user_type = diction[@"user_type"];
                            personModel.alias = diction[@"alias"];
                            personModel.class_id = class_id;
                            [Database storeSchoolMember:personModel];
                            [personModel release];
                            
                        }
                    }else if ([dic[@"member"] isKindOfClass:[NSMutableDictionary class]]){
                        NSDictionary *diction = dic[@"member"];
                        PersonModel *personModel = [[PersonModel alloc]init];
                        personModel.uid = diction[@"uid"];
                        personModel.nickName = diction[@"nickname"];
                        personModel.upload_photo_timestamp = diction[@"upload_photo_timestamp"];
                        personModel.user_type = diction[@"user_type"];
                        personModel.alias = diction[@"alias"];
                        personModel.class_id = class_id;
                        [Database storeSchoolMember:personModel];
                        [personModel release];
                    }
                }
            }else if ([[infoDic[@"school"] objectForKey:@"classroom"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *dic = [infoDic[@"school"] objectForKey:@"classroom"];
                class_id = dic[@"group_id"];
                if ([dic[@"member"] isKindOfClass:[NSMutableArray class]]){
                    for (NSDictionary *diction in dic[@"member"]){
                        PersonModel *personModel = [[PersonModel alloc]init];
                        personModel.uid = diction[@"uid"];
                        personModel.nickName = diction[@"nickname"];
                        personModel.upload_photo_timestamp = diction[@"upload_photo_timestamp"];
                        personModel.user_type = diction[@"user_type"];
                        personModel.alias = diction[@"alias"];
                        personModel.class_id = class_id;
                        [Database storeSchoolMember:personModel];
                        [personModel release];
                        
                    }
                }else if ([dic[@"member"] isKindOfClass:[NSDictionary class]]){
                    NSDictionary *diction = dic[@"member"];
                    PersonModel *personModel = [[PersonModel alloc]init];
                    personModel.uid = diction[@"uid"];
                    personModel.nickName = diction[@"nickname"];
                    personModel.upload_photo_timestamp = diction[@"upload_photo_timestamp"];
                    personModel.user_type = diction[@"user_type"];
                    personModel.alias = diction[@"alias"];
                    personModel.class_id = class_id;
                    [Database storeSchoolMember:personModel];
                    [personModel release];
                }
            }
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}



@end
