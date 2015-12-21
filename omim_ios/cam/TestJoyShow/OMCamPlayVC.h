#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface OMCamPlayVC : RootViewController

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *deviceID;
@property (copy, nonatomic) NSString *describe;
@property (copy, nonatomic) NSString *shareID;
@property (copy, nonatomic) NSString *uk;
@property (copy, nonatomic) NSString *url;
//@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) int sourceIndex;//0为广场；1为收藏；2为我的；3为录像

@end
