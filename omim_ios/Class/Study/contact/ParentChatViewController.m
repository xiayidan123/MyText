//
//  ParentChatViewController.m
//  dev01
//
//  Created by Huan on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ParentChatViewController.h"
#import "Database.h"
#import "OMDateBase_MyClass.h"
#import "GroupChatRoom.h"
@interface ParentChatViewController ()

@end

@implementation ParentChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchDataFromDB];
}
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    [treeView deselectRowForItem:item animated:NO];
    ((RADataObject *)item).isOpen = !((RADataObject *)item).isOpen;
    if (((RADataObject *)item).raDataObjectType ==  RADataObjectTypeClass){
        [super beginGroupChatWithRAObject:(RADataObject *)item];
        if ([self.sub_delegate respondsToSelector:@selector(didBeginChat:)]){
            [self.sub_delegate didBeginChat:self];
        }
    }
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
            [classDataArray addObject:classData];
        }
        schollData.children = classDataArray;
        [classDataArray release];
        [self.schoolMembersDataArray addObject:schollData];
    }

}
@end
