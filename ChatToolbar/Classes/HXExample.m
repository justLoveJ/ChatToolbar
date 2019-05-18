//
//  HXExample.m
//  ios-lebanban-app
//
//  Created by liepin on 2019/1/16.
//  Copyright © 2019年 liepin. All rights reserved.
//

#import "HXExample.h"
#import "HXConfigManager.h"
#import "HXEmoji.h"

@implementation HXExample

+ (void)load {
    [self setup];
}


+ (void)setup {
    [HXConfigManager sharedInstance].uiConfig.recordVoiceIcon_normal = @"chatToolBarRecordIcon";
    [HXConfigManager sharedInstance].uiConfig.recordVoiceIcon_highlighted = @"chatToolBarRecordIcon";
    [HXConfigManager sharedInstance].uiConfig.moreIcon_normal = @"chatToolBarMroeIcon";
    [HXConfigManager sharedInstance].uiConfig.moreIcon_highlighted = @"chatToolBarMroeIcon";
    [HXConfigManager sharedInstance].uiConfig.faceIcon_normal = @"courseVideoChatFaceIcon";
    [HXConfigManager sharedInstance].uiConfig.faceIcon_highlighted = @"courseVideoChatFaceIcon";
    [HXConfigManager sharedInstance].uiConfig.keyBoardIcon_normal = @"chatToolBarKeyBoardIcon";
    [HXConfigManager sharedInstance].uiConfig.keyBoardIcon_highlighted = @"chatToolBarKeyBoardIcon";
    [HXConfigManager sharedInstance].uiConfig.faceClearIcon_normal = @"chatClearFace";
    
    
    [HXConfigManager sharedInstance].uiConfig.sendButtonBgColor_normal = [self colorWithHexString:@"#ef8200" alpha:1.0];
    [HXConfigManager sharedInstance].uiConfig.sendButtonBgColor_disabled = [UIColor whiteColor];
    [HXConfigManager sharedInstance].uiConfig.sendButtonTextColor_normal = [UIColor whiteColor];
    [HXConfigManager sharedInstance].uiConfig.sendButtonTextColor_disabled = [self colorWithHexString:@"#333333" alpha:1.0];
    
    [HXConfigManager sharedInstance].uiConfig.toolbarBgColor = [self colorWithHexString:@"#F7F7F7" alpha:1.0];
    [HXConfigManager sharedInstance].uiConfig.inputTextColor = [UIColor blackColor];
    
    /*
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"expression_custom" ofType:@"plist"];
    NSArray *names = [NSArray arrayWithContentsOfFile:fielPath];


    NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *tempPic in names) {
        NSString *imageName = [tempPic stringByReplacingOccurrencesOfString:@"[" withString:@""];
        imageName = [imageName stringByReplacingOccurrencesOfString:@"]" withString:@""];
        [muArray addObject:imageName];
    }
    [muArray addObjectsFromArray:[HXEmojiEmoticons allEmoticons]];
    NSMutableArray *muNames = [NSMutableArray arrayWithCapacity:0];
    [muNames addObjectsFromArray:names];
    [muNames addObjectsFromArray:[HXEmojiEmoticons allEmoticons]];
    
    [HXConfigManager sharedInstance].customEmojiNames = muNames;
    [HXConfigManager sharedInstance].customEmojiPics = muArray;
     */
//    [HXConfigManager sharedInstance].emojiType = HXFaceType_systemEmoji;
    
    NSMutableArray *muNames = [NSMutableArray arrayWithCapacity:0];
    for (int idx = 0;idx < 16;idx ++) {
        [muNames addObject:[HXFaceItem faceItem:[NSString stringWithFormat:@"a%d",idx + 1] imgName:@"恭喜发财" type:HXFaceType_custom]];
    }
    
    HXFaceModule *module = [HXFaceModule faceModuleWithType:HXFaceType_custom logoImgName:@"chatToolBarMroeIcon" version:@"1.0" identifier:@"唯一标识符" faceSections:muNames];
    HXFaceModule *module2 = [HXFaceModule faceModuleWithType:HXFaceType_systemEmoji logoImgName:@"courseVideoChatFaceIcon" version:@"1.0" identifier:@"唯一标识符" faceSections:[HXEmoji allEmoji]];
    
    [HXConfigManager sharedInstance].faceSections =
  @[
  module2,
  module
  ];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if(hexString.length<6){
        return [UIColor blackColor];
    }
    
    unsigned int red = 0, green = 0, blue = 0;
    NSRange range = NSMakeRange(0, 2);
    if([hexString hasPrefix:@"#"]){
        range = NSMakeRange(1, 2);
    }
    else if([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]){
        range = NSMakeRange(2, 2);
    }
    
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = range.location + range.length;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = range.location + range.length;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
