
@class GroupMember;

typedef NS_ENUM(NSInteger, Buddy_Relationship_Type) {
    Buddy_Relationship_Type_UNADD,
    Buddy_Relationship_type_ADDED,
    Buddy_Relationship_type_ADDING,
    Buddy_Relationship_type_ISSELF
};


@interface Buddy : NSObject {
	/**ユーザid **/
	NSString* userID ;
	
    /**ユーザ電話 **/
	NSString* phoneNumber ;
	
	/**設定されたニックネーム **/
	NSString* nickName ;
	
	/**最新ステータス/ひとこと **/
	NSString* status ;
	
    
	/** 機種型番 **/
	NSString* deviceNumber ;
	
	/** アプリバージョン **/
	NSString* appVer ;
	
    // 0表示官方，1表示学生，2是老师
    // type of user. Student, teacher etc
    NSInteger userType;
    
	/**
	 * TimeStamp when this user is inserted to local db :
	 *    use to compare and list up the newly inserted friend
	 **/
	NSInteger insertTimeStamp;
	
	/**
	 * Flag to judge whether this user is blocked by me
	 * ブロックしたかどうかの判断フラッグ
	 */
	BOOL isBlocked;
	
	/**
	 * Flag to judge when this is already my friend or just recommended by server
	 * 友達／知り合いかも　の判断フラッグ
	 */
	BOOL isFriend;
	
    /**
     *  Sex
     */
    NSInteger sexFlag;
    
    
    
    
    /**
	 * TimeStamp when this user photo is update:
	 *    use to compare and fetch the newly update profile thumbnail or photo
	 * サーバ側相手の画像が更新されたtimestamp
	 **/
	NSInteger photoUploadedTimeStamp;
    
    /**
	 * buddy has a new thumbnail photo
	 * 相手のThumbnail画像を表示には新たにダウンロードが必要
	 */
    BOOL needToDownloadThumbnail;
    
    /**
	 * buddy has a new profile photo
	 * 相手のThumbnail画像を表示には新たにダウンロードが必要
	 */
    BOOL needToDownloadPhoto;
    
    
	/**
	 * File path where the thumbnail photo is stored in local
	 * ローカルで相手のThumbnailが保存されたパス
	 */
	NSString* pathOfThumbNail;
	
    /**
	 * File path where the profile photo is stored in local
	 * ローカルで相手のProfile 画像が保存されたパス
	 */
	NSString* pathOfPhoto;
    
    /**
	 * すでに退会したや、友達や友達かもの関係がなくなった場合、当該ユーザの情報がまだ一部持っているってこと
	 */
    BOOL mayNotExist;
    
    
    
    NSString* wowtalkID;
    
    float lastLongitude;
    float lastLatitude;
    NSInteger lastLoginTimestamp;


	NSString *alias;
}


@property (copy) NSString *userID;
@property (copy) NSString *phoneNumber;
@property (copy) NSString *nickName;
@property (copy) NSString *status;
@property (copy) NSString *deviceNumber;
@property (copy) NSString *appVer;
@property (assign) NSInteger userType;   //0:official account; 1:student; 2 : teacher

@property (assign) BOOL isBlocked;
@property (assign) BOOL isFriend;

@property (copy) NSString* buddy_flag;  //1 : friend ;  0: possible friend from server ; -1: possible friend added by group member  2: added from contact, he is not a user yet.

@property (assign) NSInteger sexFlag; //0:male ; 1: female ; 2:unknown

@property (assign) NSInteger insertTimeStamp;

@property (assign) NSInteger photoUploadedTimeStamp;
@property (assign) BOOL needToDownloadThumbnail;
@property (assign) BOOL needToDownloadPhoto;
@property (copy) NSString* pathOfThumbNail;
@property (copy) NSString* pathOfPhoto;
@property (assign) BOOL mayNotExist;


@property(copy) NSString *wowtalkID;
@property(assign) float lastLongitude;
@property(assign) float lastLatitude;
@property(assign)NSInteger lastLoginTimestamp;

@property int addFriendRule;  // 0: no way  1: need a request 2: anybody

@property (copy) NSString *alias;
@property (copy, nonatomic) NSString *showName;
- (id) initWithUID:(NSString*)strUID andPhoneNumber:(NSString*)strPhoneNumber andNickname:(NSString*)strNick
         andStatus:(NSString*)strStatus andDeviceNumber:(NSString*)strDeviceNum andAppVer:(NSString*)strAppVer andUserType:(NSString*)strUserType
      andBuddyFlag:(NSString*)budyflag andIsBlocked:(BOOL)blockFlag andSex:(NSString*)strSex andPhotoUploadTimeStamp:(NSString*)strTimestamp
      andWowTalkID:(NSString*)strWowTalkID andLastLongitude:(NSString*)strLastLongitude andLastLatitude:(NSString*)strLastLatitude andLastLoginTimestamp:(NSString*)strLastLoginTimestamp withAddFriendRule:(int)rule andAlias:(NSString *)alias;

-(void) setThumbnailPath:(NSString*)path;
-(void) setPhotoPath:(NSString*)path;


+(Buddy*)buddyFromGroupMember:(GroupMember*)member;

// for sorting
@property NSInteger sectionNumber;

/** 分组名称（用于联系人列表分组） */
@property (copy, nonatomic) NSString * section_name;

/** 与本人关系 */
@property (assign, nonatomic) Buddy_Relationship_Type relationship_type;


// by yangbin to store level in group
@property (nonatomic,copy)NSString *level;


@end
