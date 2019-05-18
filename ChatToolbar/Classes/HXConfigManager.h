//
//  HXLoginManager.h
//  HXKitDemo
//
//  Created by jinyaowei on 16/10/11.
//  Copyright © 2016年 liepin Organization name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXConstants.h"


@class HXUIConfig;
/*
 * 配置
 */
@interface HXConfigManager : NSObject 

+ (HXConfigManager*)sharedInstance;

@property (nonatomic,readonly) HXUIConfig *uiConfig;

// 表情组
@property (nonatomic,strong) NSArray *faceSections;
@end



@interface HXFaceModule: NSObject
// 表情类型
@property (nonatomic,assign) HXFaceType emojiType;
// 表情logo
@property (nonatomic,copy) NSString *logoImgName;
// 表情section
@property (nonatomic,strong) NSArray *faceSections;
// 表情版本号
@property (nonatomic,copy) NSString *version;
// 表情唯一标识符
@property (nonatomic,copy) NSString *identifier;

+ (HXFaceModule *)faceModuleWithType:(HXFaceType)type
                         logoImgName:(NSString *)logoImgName
                             version:(NSString *)version
                          identifier:(NSString *)identifier
                        faceSections:(NSArray *)faceSections;
@end


@interface HXFaceItem: NSObject
// 图片名称
@property (nonatomic,copy) NSString *imgIcon;
// 名称
@property (nonatomic,copy) NSString *imgName;
// 表情类型
@property (nonatomic,assign) HXFaceType emojiType;

+ (HXFaceItem *)faceItem:(NSString *)imgIcon
                 imgName:(NSString *)imgName
                    type:(HXFaceType)type;
@end


@interface HXUIConfig : NSObject
//录制声音按钮图片
@property (nonatomic,copy) NSString *recordVoiceIcon_normal;
@property (nonatomic,copy) NSString *recordVoiceIcon_highlighted;
//更多按钮图片
@property (nonatomic,copy) NSString *moreIcon_normal;
@property (nonatomic,copy) NSString *moreIcon_highlighted;
//表情按钮图片
@property (nonatomic,copy) NSString *faceIcon_normal;
@property (nonatomic,copy) NSString *faceIcon_highlighted;
//键盘按钮图片
@property (nonatomic,copy) NSString *keyBoardIcon_normal;
@property (nonatomic,copy) NSString *keyBoardIcon_highlighted;
//表情中清楚按钮
@property (nonatomic,copy) NSString *faceClearIcon_normal;
@property (nonatomic,copy) NSString *faceClearIcon_highlighted;
//发送消息失败标示符
@property (nonatomic,copy) NSString *sendMessageFailIcon_normal;
@property (nonatomic,copy) NSString *sendMessageFailIcon_highlighted;
@property (nonatomic,strong) UIColor *toolbarBgColor;
@property (nonatomic,strong) UIColor *inputTextColor;
//表情view中的发送按钮的背景颜色
@property (nonatomic,strong) UIColor *sendButtonBgColor_normal;
@property (nonatomic,strong) UIColor *sendButtonBgColor_disabled;
@property (nonatomic,strong) UIColor *sendButtonTextColor_normal;
@property (nonatomic,strong) UIColor *sendButtonTextColor_disabled;

@property (nonatomic,strong) UIColor *lineColor;
@end

