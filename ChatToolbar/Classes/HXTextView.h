//
//  HXTextView.h
//  Demo
//
//  Created by liepin on 2019/5/10.
//  Copyright © 2019年 Jinyw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HXRemindItem : NSObject
// 展示文本
@property (nonatomic, copy) NSString *text;
// 唯一标识符
@property (nonatomic, copy) NSString *identifier;
@end

@interface HXTextView : UITextView

@property (nonatomic, copy, readonly) NSMutableArray <HXRemindItem *>*remindList;


// 添加标记
- (void)addRemindWithText:(NSString *)text identifier:(NSString *)identifier;

@end


