//
//  HXLoginManager.m
//  HXKitDemo
//
//  Created by jinyaowei on 16/10/11.
//  Copyright © 2016年 liepin Organization name. All rights reserved.
//

#import "HXConfigManager.h"

@interface HXConfigManager ()

@property (nonatomic,strong) HXUIConfig *ui_Config;
@end

@implementation HXConfigManager

#pragma mark - 初始化

+ (HXConfigManager*)sharedInstance {
    static HXConfigManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[HXConfigManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ui_Config = [HXUIConfig new];
    }
    return self;
}

#pragma mark - Public Method

- (HXUIConfig *)uiConfig {
    return _ui_Config;
}

@end


@implementation HXUIConfig

@end

@implementation HXFaceItem

+ (HXFaceItem *)faceItem:(NSString *)imgIcon imgName:(NSString *)imgName type:(HXFaceType)type {
    HXFaceItem *item = [HXFaceItem new];
    item.imgIcon = imgIcon;
    item.imgName = imgName;
    item.emojiType = type;
    return item;
}

@end

@implementation HXFaceModule
+ (HXFaceModule *)faceModuleWithType:(HXFaceType)type
                         logoImgName:(NSString *)logoImgName
                             version:(NSString *)version
                          identifier:(NSString *)identifier
                        faceSections:(NSArray *)faceSections
{
    HXFaceModule *module = [HXFaceModule new];
    module.emojiType = type;
    module.logoImgName = logoImgName;
    module.version = version;
    module.identifier = identifier;
    module.faceSections = faceSections;
    return module;
}
@end














