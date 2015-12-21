
#import <UIKit/UIKit.h>
#import "MediaProcessing.h"
#import "EnumType.h"


@class DAViewController;

@protocol DAViewControllerDelegate

- (void)getDataFromDAView:(DAViewController*)requestor;

@end




@interface DAViewController : UIViewController

@property (nonatomic,retain) UIImage* myImage;
@property (nonatomic,assign) CGSize maxThumbnailSize;
@property (assign) BOOL needCropping;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (nonatomic, copy) NSString *dirName;
@property (nonatomic, assign) id<DAViewControllerDelegate> delegate;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, assign) MULTI_MEDIA_TYPE mmtType;

@end
