//
//  OnlineHomeViewController.m
//  dev01
//
//  Created by Huan on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OnlineHomeViewController.h"
#import "ContactListCell.h"
#import "Database.h"
#import "OMDateBase_MyClass.h"
#import "GroupChatRoom.h"
@interface OnlineHomeViewController ()

@end

@implementation OnlineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)fetchDataFromDB
{
    NSMutableArray *schoolArray = [Database fetchAllSchool];
    for (int i=0; i<schoolArray.count; i++){
        RADataObject *schollData = [RADataObject dataObjectWithName:[schoolArray[i] corp_name]
                                                           children:nil];
        schollData.raDataObjectType = RADataObjectTypeSchool;
        schollData.objectID = [schoolArray[i] corp_id];
        NSMutableArray *classArray = [OMDateBase_MyClass fetchClassWithSchoolID:[schoolArray[i] corp_id]];
        if (classArray.count == 0){
            [self.schoolMembersDataArray addObject:schollData];
            break;
        }
        NSMutableArray *classDataArray = [[NSMutableArray alloc]init];
        for (int j=0; j<classArray.count; j++){
            RADataObject *classData = [RADataObject dataObjectWithName:[classArray[j] groupNameOriginal]
                                                              children:nil];
            classData.objectID = [classArray[j] groupID];
            classData.raDataObjectType = RADataObjectTypeClass;
            
            NSMutableArray *memberArray = [Database fetchMembersWithClassID:[classArray[j] groupID]];
            NSMutableArray *memberDataArray = [[NSMutableArray alloc]init];
            for (int k=0; k<memberArray.count; k++) {
                if ([[memberArray[k] user_type] isEqualToString:@"2"])
                {
                RADataObject *memberData = [RADataObject dataObjectWithName:[memberArray[k] nickName]
                                                                   children:nil];
                memberData.raDataObjectType = RADataObjectMember;
                PersonModel *personModel = [[PersonModel alloc]init];
                personModel.upload_photo_timestamp = [memberArray[k] upload_photo_timestamp];
                personModel.uid = [memberArray[k] uid];
                personModel.nickName = [memberArray[k] nickName];
                personModel.user_type = [memberArray[k] user_type];
                personModel.alias = [memberArray[k] alias];
                memberData.person = personModel;
                [personModel release];
                [memberDataArray addObject:memberData];
                }
            }
            classData.children = memberDataArray;
            [memberDataArray release];
            
            [classDataArray addObject:classData];
        }
        schollData.children = classDataArray;
        [classDataArray release];
        [self.schoolMembersDataArray addObject:schollData];
    }
}
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    [treeView cellForItem:item];
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    if (((RADataObject *)item).raDataObjectType == RADataObjectMember){
        ContactListCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ContactListCell" owner:self options:nil] lastObject];
        //        cell.lab_name.text = ((RADataObject *)item).name;
        if (numberOfChildren != 0){
            cell.imageView_head.alpha = 0;
        }
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        if ([((RADataObject *)item).person.user_type isEqualToString:@"2"]) {
            cell.person = ((RADataObject *)item).person;
        }
        
        
        return cell;
    }else if (((RADataObject *)item).raDataObjectType == RADataObjectTypeClass){
        SchoolContractContentsCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SchoolContractContentsCell" owner:self options:nil] firstObject];
        cell.lab_title.text = ((RADataObject *)item).name;
        [cell setLevel: treeNodeInfo.treeDepthLevel];
        cell.raDataObject = ((RADataObject *)item);
        cell.delegate = self;
        cell.isClass = YES;
        cell.isHideGroupBtn = YES;
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }else{
        SchoolContractContentsCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SchoolContractContentsCell" owner:self options:nil] firstObject];
        cell.lab_title.text = ((RADataObject *)item).name;
        [cell setLevel: treeNodeInfo.treeDepthLevel];
        cell.raDataObject = ((RADataObject *)item);
        cell.delegate = self;
        cell.isClass = NO;
        cell.isHideGroupBtn = YES;
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
}
@end
