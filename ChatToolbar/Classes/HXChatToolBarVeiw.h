//
//  HXChatToolBarVeiw.h
//  HXKitDemo
//
//  Created by jinyaowei on 2016/11/16.
//  Copyright © 2016年 liepin Organization name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConstants.h"
#import "HXFaceView.h"
#import "HXMoreView.h"
#import "HXConfigManager.h"
#import "HXTextView.h"

@protocol HXChatToolBarVeiwDelegate <NSObject>

- (void)chatToolBarFrameDidChange:(CGFloat)heigth;
- (void)sendMessageWithText:(NSString *)text remindList:(NSMutableArray *)remindList;
- (void)sendCustomFace:(HXFaceItem *)item;

/**
 *  标记人
 */
- (void)remindMember;
@end

@interface HXChatToolBarVeiw : UIView


- (instancetype)initWithShowType:(HXToolBarShowType)type;

@property (nonatomic,assign) id <HXChatToolBarVeiwDelegate>delegate;

@property (nonatomic, copy) NSString *text;
// 标记 比如：@
@property (nonatomic, copy) NSString *remind;
// 标记list
@property (nonatomic, copy, readonly) NSArray <HXRemindItem *>*remindList;

// 添加标记，如果非第一响应者，设置完，会自动设置为第一响应者
- (void)appendRemindWithText:(NSString *)text identifier:(NSString *)identifier;

// 更换输入框文本
- (void)replaceText:(NSString *)text;

/**
 *  结束输入状态
 */
- (void)endInputing;

/**
 *  进入输入状态
 */
- (void)beginInputing;

@end
