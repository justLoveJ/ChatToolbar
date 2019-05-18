//
//  HXTextView.m
//  Demo
//
//  Created by liepin on 2019/5/10.
//  Copyright © 2019年 Jinyw. All rights reserved.
//

#import "HXTextView.h"
#import "HXConstants.h"



@implementation HXRemindItem
@end

HXRemindItem * remindItem(NSString *text,NSString *identifier) {
    HXRemindItem *item = [HXRemindItem new];
    item.text = text;
    item.identifier = identifier;
    return item;
}

@implementation HXTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)deleteBackward {
    
    if (self.selectedRange.length == 0 && self.selectedRange.location > 0) {
        NSString *text = self.text;
        NSRange effectiveRange;
        
        HXRemindItem *item = [self.textStorage attribute:kHXRemindAttributeName atIndex:self.selectedRange.location - 1 longestEffectiveRange:&effectiveRange inRange:NSMakeRange(0, text.length)];
        // 如果被标记的文本有被编辑过，就不会被全部删除，参考微信
        if (item && effectiveRange.location != NSNotFound && [[text substringWithRange:effectiveRange] isEqualToString:item.text]) {
            if (self.selectedRange.location > effectiveRange.location) {
                NSRange range = NSMakeRange(effectiveRange.location, self.selectedRange.length + (self.selectedRange.location - effectiveRange.location));
                UITextPosition *start = [self positionFromPosition:self.beginningOfDocument offset:range.location];
                UITextPosition *end = [self positionFromPosition:start offset:range.length];
                UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];
                // 需要这样删除。如果不调用，会自动多删除一个空格。不知道为啥。关闭联想也会多删除
                [self replaceRange:textRange withText:@""];
                return;
            }
        }
    }

    [super deleteBackward];
    
}

- (void)addRemindWithText:(NSString *)text identifier:(NSString *)identifier {
    
    if (!text && text.length <= 0) return;
    if (!identifier && identifier.length <= 0) return;

    
    NSRange selectedRange = self.selectedRange;
    // 添加文本
    [self replaceRange:self.selectedTextRange withText:text];
    
    // 添加标记
    [self.textStorage addAttribute:kHXRemindAttributeName value:remindItem(text, identifier) range:NSMakeRange(selectedRange.location, text.length)];
    // 重新设置位置
    self.selectedRange = NSMakeRange(selectedRange.location + text.length, 0);
    if (self.isFirstResponder == NO) {
        [self becomeFirstResponder];
    }
}

#pragma mark - Getter

- (NSMutableArray<HXRemindItem *> *)remindList {
    __block NSMutableArray *tmpList = [NSMutableArray array];
    [self.textStorage enumerateAttribute:kHXRemindAttributeName inRange:NSMakeRange(0, self.text.length) options:0 usingBlock:^(HXRemindItem   * _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[HXRemindItem class]]) {
            if (self.text.length > (range.length + range.location) &&[[self.text substringWithRange:range] isEqualToString:value.text]) {
                [tmpList addObject:value];
            }
        }
    }];
    return tmpList;
}
@end
