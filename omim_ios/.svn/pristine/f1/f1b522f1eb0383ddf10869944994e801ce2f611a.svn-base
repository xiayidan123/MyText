#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
	DAScratchPadToolTypePaint = 0,
	DAScratchPadToolTypeAirBrush
} DAScratchPadToolType;

@interface DAScratchPadView : UIControl

@property (assign) DAScratchPadToolType toolType;
@property (strong,nonatomic) UIColor* drawColor;
@property (assign) CGFloat drawWidth;
@property (assign) CGFloat drawOpacity;
@property (assign) CGFloat airBrushFlow;

@property (retain,nonatomic) UIImage* mainImage;
@property (retain,nonatomic) UIImage* drawImage;



- (void) clearToColor:(UIColor*)color;

- (UIImage*) getSketch;
- (void) setSketch:(UIImage*)sketch;

@end
