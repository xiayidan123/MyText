#import "Buddy.h"
#import "GroupMember.h"

#import "WTUserDefaults.h"
@implementation Buddy

@synthesize userID ;
@synthesize phoneNumber;
@synthesize nickName ;
@synthesize status ;
@synthesize deviceNumber;
@synthesize appVer;
@synthesize userType;

@synthesize isFriend;
@synthesize isBlocked;
@synthesize sexFlag;

@synthesize insertTimeStamp;



@synthesize photoUploadedTimeStamp;
@synthesize needToDownloadThumbnail;
@synthesize needToDownloadPhoto;
@synthesize pathOfThumbNail;
@synthesize pathOfPhoto;
@synthesize mayNotExist;

@synthesize wowtalkID;
@synthesize lastLongitude;
@synthesize lastLatitude;
@synthesize lastLoginTimestamp;

@synthesize sectionNumber;

@synthesize addFriendRule;
@synthesize alias;

- (id) initWithUID:(NSString*)strUID andPhoneNumber:(NSString*)strPhoneNumber andNickname:(NSString*)strNick 
         andStatus:(NSString*)strStatus andDeviceNumber:(NSString*)strDeviceNum andAppVer:(NSString*)strAppVer andUserType:(NSString*)strUserType
        andBuddyFlag:(NSString*)budyflag andIsBlocked:(BOOL)blockFlag andSex:(NSString*)strSex andPhotoUploadTimeStamp:(NSString*)strTimestamp
andWowTalkID:(NSString*)strWowTalkID andLastLongitude:(NSString*)strLastLongitude andLastLatitude:(NSString*)strLastLatitude andLastLoginTimestamp:(NSString*)strLastLoginTimestamp withAddFriendRule:(int)rule andAlias:(NSString *)alian

{
    self = [super init];
	if (self == nil)
		return nil;
    self.userID=(strUID!=nil)?strUID:@"";
    self.phoneNumber=(strPhoneNumber!=nil)?strPhoneNumber:@"";
    
	self.nickName=(strNick!=nil)?strNick:@"";
	self.status=(strStatus!=nil)?strStatus:@"";
	self.deviceNumber=(strDeviceNum!=nil)?strDeviceNum:@"";
	self.appVer=(strAppVer!=nil)?strAppVer:@"";
    self.userType = (strUserType!=nil)?[strUserType intValue]:1;

    self.buddy_flag = budyflag !=nil? budyflag:@"";
    
    self.addFriendRule = rule;
    
    if ([budyflag isEqualToString:@"1"]) {
        self.isFriend = TRUE;
    }
    else
        self.isFriend = FALSE;

    self.isBlocked = blockFlag;
    self.sexFlag = (strSex!=nil)?[strSex intValue]:-1;
    
    self.photoUploadedTimeStamp = (strTimestamp!=nil)?[strTimestamp intValue]:-1;
    
    self.insertTimeStamp=-1;  // to be set after reading db
	self.pathOfPhoto =@"";  // to be set after reading db
    self.pathOfThumbNail=@""; // to be set after reading db
    self.needToDownloadPhoto = (self.photoUploadedTimeStamp!=-1);  // to be set after comparing photoUploadedTimeStamp
    self.needToDownloadThumbnail = (self.photoUploadedTimeStamp!=-1);// to be set after comparing photoUploadedTimeStamp
    self.mayNotExist = FALSE;
    
    
    self.wowtalkID = strWowTalkID;
    self.lastLongitude = (strLastLongitude!=nil)?[strLastLongitude floatValue]:-1;
    self.lastLatitude = (strLastLatitude!=nil)?[strLastLatitude floatValue]:-1;
    self.lastLoginTimestamp = (strLastLoginTimestamp!=nil)?[strLastLoginTimestamp intValue]:-1;
    self.alias = (!alian)?alian:nickName;
    
    return self;
    
}


-(void) setThumbnailPath:(NSString*)path{
    self.pathOfThumbNail = path;
    self.needToDownloadThumbnail  = FALSE;
}
-(void) setPhotoPath:(NSString*)path{
    self.pathOfPhoto = path;
    self.needToDownloadPhoto = FALSE;
}

- (id) copyWithZone:(NSZone *)zone {
	Buddy *buddy= [[Buddy alloc] init];
    buddy.userID=self.userID;
    buddy.phoneNumber=self.phoneNumber;
    
	buddy.nickName=self.nickName;
	buddy.status=self.status;
	buddy.deviceNumber=self.deviceNumber;
	buddy.appVer=self.appVer;
    buddy.userType=self.userType ;
    
    
    buddy.isFriend=self.isFriend ;
    buddy.isBlocked=self.isBlocked ;
    buddy.sexFlag=self.sexFlag ;
    
    
    
    buddy.photoUploadedTimeStamp=self.photoUploadedTimeStamp ;
    
    buddy.insertTimeStamp=self.insertTimeStamp;
	buddy.pathOfPhoto=self.pathOfPhoto;
    buddy.pathOfThumbNail=self.pathOfThumbNail;
    buddy.needToDownloadPhoto=self.needToDownloadPhoto;
    buddy.needToDownloadThumbnail=self.needToDownloadThumbnail;
    buddy.mayNotExist=self.mayNotExist;
    
    
    buddy.wowtalkID=self.wowtalkID;
    buddy.lastLongitude=self.lastLongitude ;
    buddy.lastLatitude=self.lastLatitude ;
    buddy.lastLoginTimestamp=self.lastLoginTimestamp ;

    buddy.sectionNumber = self.sectionNumber;
    buddy.alias = self.alias;
	return buddy;
}

+(Buddy*)buddyFromGroupMember:(GroupMember*)member
{
    Buddy* buddy = [[Buddy alloc] initWithUID:member.userID andPhoneNumber:member.phoneNumber andNickname:member.nickName andStatus:member.status andDeviceNumber:member.deviceNumber andAppVer:member.appVer andUserType:[NSString stringWithFormat:@"%zi",member.userType] andBuddyFlag:member.buddy_flag andIsBlocked:member.isBlocked andSex:[NSString stringWithFormat:@"%zi",member.sexFlag] andPhotoUploadTimeStamp:[NSString stringWithFormat:@"%zi",member.photoUploadedTimeStamp] andWowTalkID:member.wowtalkID andLastLongitude:[NSString stringWithFormat:@"%f", member.lastLongitude ]  andLastLatitude:[NSString stringWithFormat:@"%f",member.lastLatitude ] andLastLoginTimestamp:[NSString stringWithFormat:@"%zi",member.lastLoginTimestamp] withAddFriendRule:member.addFriendRule andAlias:member.alias];

    
    return [buddy autorelease];
}


-(void)dealloc
{
    self.section_name = nil;
    self.showName = nil;
    self.userID = nil;
    self.phoneNumber = nil;
    self.nickName = nil;
    self.status = nil;
    self.deviceNumber = nil;
    self.appVer = nil;
    self.pathOfThumbNail = nil;
    self.pathOfPhoto = nil;
    self.wowtalkID = nil;
    self.buddy_flag = nil;
    self.alias = nil;
    [_level release],_level = nil;
    [super dealloc];
}


-(Buddy_Relationship_Type)relationship_type{
    if (_relationship_type == Buddy_Relationship_type_ADDING){
        return _relationship_type;
    }
    
    if (self.isFriend){
        return Buddy_Relationship_type_ADDED;
    }
    
    if ([self.userID isEqual:[WTUserDefaults getUid]]){
        return Buddy_Relationship_type_ISSELF;
    }
    
    return Buddy_Relationship_Type_UNADD;
}



@end
