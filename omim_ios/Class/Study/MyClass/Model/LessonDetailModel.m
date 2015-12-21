//
//  LessonDetailModel.m
//  dev01
//
//  Created by 杨彬 on 15/3/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LessonDetailModel.h"
#import "ClassRoomCamera.h"
#import "ClassRoom.h"
#import "OMBaseCellFrameModel.h"
#import "LessonPerformanceModel.h"
#import "ParentFeedbackModel.h"
#import "WTUserDefaults.h"
#import "NewhomeWorkModel.h"
@interface LessonDetailModel ()




@end

@implementation LessonDetailModel


-(void)dealloc{
    
    [_cameraArray release];
    
    [_roomArray release];
    
    [super dealloc];
}


+ (instancetype)LessonDetailModelWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super initWithDict:dic[@"lesson"]];
    if (self) {
        
        // camera
        id cameraObject = dic[@"camera"];
        [self loadCameraArrayWithDict:cameraObject];
        
        
        //room
        id roomObject = dic[@"room"];
        [self loadRoomArrayWithDict:roomObject];
        
        //performance
        id performanceObject = dic[@"performance"];
        [self loadPerformanceWithDict:performanceObject];
        
        id parent_feedback = dic[@"parent_feedback"];
        [self loadParentFeedbackWithDict:parent_feedback];
        
        //homework
        id homework_model = dic[@"homework"];
        [self loadHomeworkModelWithDict:homework_model];
    }
    return self;
}
- (void)loadHomeworkModelWithDict:(id)homework_model{
    NSMutableArray *homeworkModelObjArray = nil;
    if (homework_model == nil) {
        return;
    }
    if ([homework_model isKindOfClass:[NSArray class]]) {
        homeworkModelObjArray = [[NSMutableArray alloc] initWithArray:homework_model];
    }else{
        homeworkModelObjArray = [[NSMutableArray alloc] init];
        [homeworkModelObjArray addObject:homework_model];
    }
    NSMutableArray *homeworkModelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < homeworkModelObjArray.count; i++) {
        if ([homeworkModelObjArray[i] isKindOfClass:[NSDictionary class]]) {
            NewhomeWorkModel *homeModel = [NewhomeWorkModel NewhomeWorkModelWithDic:homeworkModelObjArray[i]];
            [homeworkModelArray addObject:homeModel];
        }
    }
    if (homeworkModelArray && homeworkModelArray.count != 0) {
        self.homeWorkArray = homeworkModelArray;
    }
    [homeworkModelArray release];
    [homeworkModelObjArray release];
    
}
- (void)loadParentFeedbackWithDict:(id)parentFeedbackObject{
    NSMutableArray *parentFeedbackObjArray = nil;
    if (parentFeedbackObject == nil) {
        return;
    }
    if ([parentFeedbackObject isKindOfClass:[NSArray class]]) {
        parentFeedbackObjArray = [[NSMutableArray alloc] initWithArray:parentFeedbackObject];
    }else{
        parentFeedbackObjArray = [[NSMutableArray alloc] init];
        [parentFeedbackObjArray addObject:parentFeedbackObject];
    }
    NSMutableArray *parentFeedbackArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < parentFeedbackObjArray.count; i++) {
        if ([parentFeedbackObjArray[i] isKindOfClass:[NSDictionary class]]) {
            ParentFeedbackModel *feedback = [ParentFeedbackModel ParentFeedbackWithDic:parentFeedbackObjArray[i]];
            [parentFeedbackArray addObject:feedback];
        }
    }
    if (parentFeedbackArray && parentFeedbackArray.count != 0) {
        self.parentFeedbackArray = parentFeedbackArray;
    }
    [parentFeedbackArray release];
    [parentFeedbackObjArray release];
}


- (void)loadPerformanceWithDict:(id)performanceObject{
    NSMutableArray *performanceObjArray = nil;
    if (performanceObject == nil) {
        return;
    }
    if ([performanceObject isKindOfClass:[NSArray class]]) {
        performanceObjArray = [[NSMutableArray alloc] initWithArray:performanceObject];
    }else{
        performanceObjArray = [[NSMutableArray alloc] init];
        [performanceObjArray addObject:performanceObject];
    }
    NSMutableArray *performanceArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < performanceObjArray.count; i++) {
        if ([performanceObjArray[i] isKindOfClass:[NSDictionary class]]) {
            LessonPerformanceModel *performance = [LessonPerformanceModel LessonPerformanceModelWithDic:performanceObjArray[i]];
            [performanceArray addObject:performance];
        }
    }
    if (performanceArray && performanceArray.count != 0) {
        self.performanceArray = performanceArray;
    }
    [performanceArray release];
    [performanceObjArray release];
    
}

- (void)loadCameraArrayWithDict:(id)cameraObject{
    NSMutableArray *cameraObjArray = nil;
    if (cameraObject == nil)return;
    if ([cameraObject isKindOfClass:[NSArray class]]){
        cameraObjArray = [[NSMutableArray alloc]initWithArray:cameraObject];
    }else{
        cameraObjArray = [[NSMutableArray alloc]init];
        [cameraObjArray addObject:cameraObject];
    }

    NSMutableArray *cameraArray = [[NSMutableArray alloc]init];
    NSInteger count = cameraObjArray.count;
    for (int i=0; i<count; i++){
        if ([cameraObjArray[i] isKindOfClass:[NSDictionary class]]){
            ClassRoomCamera *camera = [ClassRoomCamera ClassRoomCameraWithDic:cameraObjArray[i]];
            [cameraArray addObject:camera];
        }
    }
    if (cameraArray && cameraArray.count != 0){
        self.cameraArray = cameraArray;
    }
    [cameraArray release];
    [cameraObjArray release];
}



-(void)setRoomArray:(NSMutableArray *)roomArray{
    [_roomArray removeAllObjects],[_roomArray release],_roomArray = nil;
    _roomArray = [roomArray retain];
}

-(void)setCameraArray:(NSMutableArray *)cameraArray{
    [_cameraArray removeAllObjects],[_cameraArray release],_cameraArray = nil;
    _cameraArray = [cameraArray retain];
}

- (void)setPerformanceArray:(NSMutableArray *)performanceArray{
    [_performanceArray removeAllObjects],[_performanceArray release],_performanceArray = nil;
    _performanceArray = [performanceArray retain];
}
- (void)setParentFeedbackArray:(NSMutableArray *)parentFeedbackArray{
    [_parentFeedbackArray removeAllObjects],[_parentFeedbackArray release],_parentFeedbackArray = nil;
    _parentFeedbackArray = [parentFeedbackArray retain];
}

- (void)loadRoomArrayWithDict:(id)roomObject{
    NSMutableArray *roomObjArray = nil;
    if (roomObject == nil) return;
    if ([roomObject isKindOfClass:[NSArray class]]){
        roomObjArray = [[NSMutableArray alloc]initWithArray:roomObject];
    }else{
        roomObjArray = [[NSMutableArray alloc]init];
        [roomObjArray addObject:roomObject];
    }
    
    NSMutableArray *roomArray = [[NSMutableArray alloc]init];
    NSInteger count = roomObjArray.count;
    for (int i=0; i<count; i++){
        if ([roomObjArray[i] isKindOfClass:[NSDictionary class]]){
            ClassRoom *room = [ClassRoom ClassRoomWithDic:roomObjArray[i]];
            [roomArray addObject:room];
        }
    }
    if (roomArray && roomArray.count != 0){
        self.roomArray = roomArray;
    }
    [roomArray release];
    [roomObjArray release];
}

+ (NSMutableArray *)parseLessonDetailModel:(LessonDetailModel *)lessonDetailModel isTeacher:(BOOL)isTeacher{
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *lessonItems = [[NSMutableArray alloc]init];
        
    // 知识点
    //NSMutableArray *knowledgeFrameModelArray = [[NSMutableArray alloc]init];
    NSDictionary *knowledgeDict = [[NSDictionary alloc] initWithObjects:@[@"教学大纲",@"",@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
    OMBaseCellFrameModel *knowledgeFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:knowledgeDict];
//    [knowledgeFrameModelArray addObject:knowledgeFrameMdoel];
//    [knowledgeDict release];
//    [itemsArray addObject:knowledgeFrameModelArray];
//    [knowledgeFrameModelArray release];
    [lessonItems addObject:knowledgeFrameMdoel];
    [knowledgeDict release];
    NSString *performanceCount = [[[NSString alloc] init] autorelease];
    NSString *comments = [[NSString alloc] init];
    if ([[WTUserDefaults getUsertype] isEqualToString:@"2"]) {
        performanceCount = [NSString stringWithFormat:@"%zi个学生已提交点评",lessonDetailModel.performanceArray.count / 9];
        comments = lessonDetailModel.performanceArray == nil ? @"未点评" : performanceCount;
    }else{
        comments = lessonDetailModel.performanceArray == nil ? @"未点评" : @"已点评";
    }
    
    //课堂点评
    NSDictionary *commentsDict = [[NSDictionary alloc] initWithObjects:@[@"课堂点评",comments,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
    OMBaseCellFrameModel *commentsFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:commentsDict];
    [lessonItems addObject:commentsFrameMdoel];
    [commentsDict release];

    
    
    
    //作业
    NSDictionary *homeWorkDict;
    NSString *comment = [[[NSString alloc] init] autorelease];
    comment = lessonDetailModel.homeWorkArray == nil ? @"未布置" : @"已布置";
    if(isTeacher)
    {
        homeWorkDict = [[NSDictionary alloc] initWithObjects:@[@"布置作业",comment,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
    }
    else{
        homeWorkDict = [[NSDictionary alloc] initWithObjects:@[@"作业",comment,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
    
    }
    OMBaseCellFrameModel *homeWorkFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:homeWorkDict];
    [lessonItems addObject:homeWorkFrameMdoel];
    [homeWorkDict release];
    
    
    //家长意见
    if (isTeacher) {
        NSString *opinionCount = [NSString stringWithFormat:@"%lu个家长已提交意见",(unsigned long)lessonDetailModel.parentFeedbackArray.count];
        //    NSMutableArray *opinionFrameModelArray = [[NSMutableArray alloc]init];
        NSDictionary *opinionDict = [[NSDictionary alloc] initWithObjects:@[@"家长意见",opinionCount,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
        OMBaseCellFrameModel *opinionFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:opinionDict];
        //    [opinionFrameModelArray addObject:opinionFrameMdoel];
        //    [opinionDict release];
        //    [itemsArray addObject:opinionFrameModelArray];
        //    [opinionFrameModelArray release];
        [lessonItems addObject:opinionFrameMdoel];
        [opinionDict release];
    }else{
        NSString *opinion = lessonDetailModel.parentFeedbackArray == nil?@"未评价":@"已评价";
        //    NSMutableArray *opinionFrameModelArray = [[NSMutableArray alloc]init];
        NSDictionary *opinionDict = [[NSDictionary alloc] initWithObjects:@[@"家长意见",opinion,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
        OMBaseCellFrameModel *opinionFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:opinionDict];
        //    [opinionFrameModelArray addObject:opinionFrameMdoel];
        //    [opinionDict release];
        //    [itemsArray addObject:opinionFrameModelArray];
        //    [opinionFrameModelArray release];
        [lessonItems addObject:opinionFrameMdoel];
        [opinionDict release];
    }
    
    
//    //答疑
//    NSDictionary *AQDict = [[NSDictionary alloc] initWithObjects:@[@"答疑",@"",@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
//    OMBaseCellFrameModel *AQFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:AQDict];
//    [lessonItems addObject:AQFrameMdoel];
//    [AQDict release];
//
        
    //考勤
    //    NSDictionary *attendanceDict = [[NSDictionary alloc] initWithObjects:@[@"考勤",@"",@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
    //    OMBaseCellFrameModel *attendanceFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:attendanceDict];
    //    [lessonItems addObject:attendanceFrameMdoel];
    //    [attendanceDict release];


        
    [itemsArray addObject:lessonItems];
    [lessonItems release];
    
    if (isTeacher)
    {
        
        
        //room
        NSMutableArray *roomFrameMdoelArray = [[NSMutableArray alloc]init];
        ClassRoom *room = [lessonDetailModel.roomArray firstObject];
        NSString *room_name = room.room_name == nil ? @"未设置" :[NSString stringWithFormat:@"%@ - %@",room.room_name,room.room_num];
        NSDictionary *roomDict = [[NSDictionary alloc] initWithObjects:@[@"教室",room_name,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
        OMBaseCellFrameModel *roomFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:roomDict];
        [roomFrameMdoelArray addObject:roomFrameMdoel];
        [roomDict release];
        [itemsArray addObject:roomFrameMdoelArray];
        [roomFrameMdoelArray release];
        
        // carmera
        NSMutableArray *cameraFrameModelArray = [[NSMutableArray alloc]init];
        NSArray *array = lessonDetailModel.cameraArray;
        NSInteger count = array.count;
        int onCount = 0;
        for (int i=0; i<count; i++){
            ClassRoomCamera *camera = array[i];
            if (camera.status){
                onCount++;
            }
        }
        NSString *str = (count ==0 || onCount ==0) ? @"" : [NSString stringWithFormat:@"打开%d/%zi",onCount,count] ;
        NSDictionary *cameraDict = [[NSDictionary alloc] initWithObjects:@[@"摄像头", str ,@(OMBaseCellModelTypeDefault)] forKeys:@[@"title", @"content", @"type"]];
        OMBaseCellFrameModel *cameraFrameMdoel = [OMBaseCellFrameModel OMBaseCellFrameModel:cameraDict];
        [cameraFrameModelArray addObject:cameraFrameMdoel];
        [cameraDict release];
        [itemsArray addObject:cameraFrameModelArray];
        [cameraFrameModelArray release];

    }
    

    return [itemsArray autorelease];
    
}


@end
