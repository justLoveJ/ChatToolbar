//
//  HXFaceView.h
//  HXKitDemo
//
//  Created by jinyaowei on 2016/12/2.
//  Copyright © 2016年 liepin Organization name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConfigManager.h"

@protocol HXFaceViewDelegate <NSObject>

- (void)faceViewSelectetItemForIconString:(HXFaceItem *)item;
- (void)faceViewDeleteButtonClick;
- (void)faceViewSendButtonClick;

@end

@interface HXFaceView : UIView
@property (nonatomic,assign) id <HXFaceViewDelegate> faceDelegate;

//可点击,和不可点击
@property (nonatomic,assign) BOOL setSendButtonState;

- (NSInteger)hasContainFace:(NSString *)text;

@end




