//
//  OMQRCodeScanView.h
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMQRCodeScanView : UIView

/**
 *  透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;




- (void)startScan;


- (void)stopScan;


@end
