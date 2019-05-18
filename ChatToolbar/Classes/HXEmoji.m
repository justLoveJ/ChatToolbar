//
//  FBEaseEmoji.m
//  FreeBird
//
//  Created by liepin on 15/12/24.
//  Copyright © 2015年 liepin. All rights reserved.
//

#import "HXEmoji.h"
#import "HXEmojiEmoticons.h"

@implementation HXEmoji
+ (NSString *)emojiWithCode:(int)code
{
    
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}

+ (NSArray *)allEmoji
{
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[HXEmojiEmoticons allEmoticons]];
    return array;
}
@end
