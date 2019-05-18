//
//  EmotionEmoticons.m
//  FreeBird
//
//  Created by liepin on 15/12/24.
//  Copyright © 2015年 liepin. All rights reserved.
//

#import "HXEmojiEmoticons.h"
#import "HXConfigManager.h"

@implementation HXEmojiEmoticons : NSObject


+ (NSArray *)allEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    
    
    [array addObject:[HXEmoji emojiWithCode:0x1f604]];
    [array addObject:[HXEmoji emojiWithCode:0x1f603]];
    [array addObject:[HXEmoji emojiWithCode:0x1f60a]];
    [array addObject:[HXEmoji emojiWithCode:0x1f609]];
    [array addObject:[HXEmoji emojiWithCode:0x1f60d]];
    [array addObject:[HXEmoji emojiWithCode:0x1f618]];
    [array addObject:[HXEmoji emojiWithCode:0x1f61a]];
    [array addObject:[HXEmoji emojiWithCode:0x1f61c]];
    [array addObject:[HXEmoji emojiWithCode:0x1f61d]];
    [array addObject:[HXEmoji emojiWithCode:0x1f633]];
    [array addObject:[HXEmoji emojiWithCode:0x1f601]];
    [array addObject:[HXEmoji emojiWithCode:0x1f614]];
    [array addObject:[HXEmoji emojiWithCode:0x1f60c]];
    [array addObject:[HXEmoji emojiWithCode:0x1f612]];
    [array addObject:[HXEmoji emojiWithCode:0x1f61e]];
    [array addObject:[HXEmoji emojiWithCode:0x1f623]];
    [array addObject:[HXEmoji emojiWithCode:0x1f622]];
    [array addObject:[HXEmoji emojiWithCode:0x1f602]];
    [array addObject:[HXEmoji emojiWithCode:0x1f62d]];
    [array addObject:[HXEmoji emojiWithCode:0x1f62a]];
    [array addObject:[HXEmoji emojiWithCode:0x1f625]];
    [array addObject:[HXEmoji emojiWithCode:0x1f630]];
    [array addObject:[HXEmoji emojiWithCode:0x1f613]];
    [array addObject:[HXEmoji emojiWithCode:0x1f628]];
    [array addObject:[HXEmoji emojiWithCode:0x1f631]];
    [array addObject:[HXEmoji emojiWithCode:0x1f620]];
    [array addObject:[HXEmoji emojiWithCode:0x1f621]];
    [array addObject:[HXEmoji emojiWithCode:0x1f616]];
    [array addObject:[HXEmoji emojiWithCode:0x1f637]];
    [array addObject:[HXEmoji emojiWithCode:0x1f632]];
    [array addObject:[HXEmoji emojiWithCode:0x1f47f]];
    [array addObject:[HXEmoji emojiWithCode:0x1f60f]];
    [array addObject:[HXEmoji emojiWithCode:0x1f466]];
    [array addObject:[HXEmoji emojiWithCode:0x1f467]];
    [array addObject:[HXEmoji emojiWithCode:0x1f468]];
    [array addObject:[HXEmoji emojiWithCode:0x1f469]];
    [array addObject:[HXEmoji emojiWithCode:0x1f31f]];
    [array addObject:[HXEmoji emojiWithCode:0x1f444]];
    [array addObject:[HXEmoji emojiWithCode:0x1f44d]];
    [array addObject:[HXEmoji emojiWithCode:0x1f44e]];
    [array addObject:[HXEmoji emojiWithCode:0x1f44c]];
    [array addObject:[HXEmoji emojiWithCode:0x1f44a]];
    [array addObject:[HXEmoji emojiWithCode:0x1f446]];
    [array addObject:[HXEmoji emojiWithCode:0x1f447]];
    [array addObject:[HXEmoji emojiWithCode:0x1f449]];
    [array addObject:[HXEmoji emojiWithCode:0x1f448]];
    [array addObject:[HXEmoji emojiWithCode:0x1f64f]];
    [array addObject:[HXEmoji emojiWithCode:0x1f44f]];
    [array addObject:[HXEmoji emojiWithCode:0x1f4aa]];
    [array addObject:[HXEmoji emojiWithCode:0x1f457]];
    [array addObject:[HXEmoji emojiWithCode:0x1f380]];
    [array addObject:[HXEmoji emojiWithCode:0x1f494]];
    [array addObject:[HXEmoji emojiWithCode:0x1f48e]];
    [array addObject:[HXEmoji emojiWithCode:0x1f436]];
    [array addObject:[HXEmoji emojiWithCode:0x1f431]];
    [array addObject:[HXEmoji emojiWithCode:0x1f339]];
    //[array addObject:[Emoji emojiWithCode:0x1f33b]];
    [array addObject:[HXEmoji emojiWithCode:0x1f341]];
    [array addObject:[HXEmoji emojiWithCode:0x1f343]];
    [array addObject:[HXEmoji emojiWithCode:0x1f319]];
    [array addObject:[HXEmoji emojiWithCode:0x1f47b]];
    [array addObject:[HXEmoji emojiWithCode:0x1f385]];
    [array addObject:[HXEmoji emojiWithCode:0x1f381]];
    [array addObject:[HXEmoji emojiWithCode:0x1f4f1]];
    [array addObject:[HXEmoji emojiWithCode:0x1f50d]];
    [array addObject:[HXEmoji emojiWithCode:0x1f4a3]];
    [array addObject:[HXEmoji emojiWithCode:0x1f37a]];
    [array addObject:[HXEmoji emojiWithCode:0x1f382]];
    [array addObject:[HXEmoji emojiWithCode:0x1f3e0]];
    [array addObject:[HXEmoji emojiWithCode:0x1f697]];
    [array addObject:[HXEmoji emojiWithCode:0x1f559]];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSString *item in array) {
        [tmpArray addObject:[HXFaceItem faceItem:item imgName:@"" type:HXFaceType_systemEmoji]];
    }
    
    return tmpArray;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

EMOJI_METHOD(grinningFace,1F600);
EMOJI_METHOD(grinningFaceWithSmilingEyes,1F601);
EMOJI_METHOD(faceWithTearsOfJoy,1F602);
EMOJI_METHOD(smilingFaceWithOpenMouth,1F603);
EMOJI_METHOD(smilingFaceWithOpenMouthAndSmilingEyes,1F604);
EMOJI_METHOD(smilingFaceWithOpenMouthAndColdSweat,1F605);
EMOJI_METHOD(smilingFaceWithOpenMouthAndTightlyClosedEyes,1F606);
EMOJI_METHOD(smilingFaceWithHalo,1F607);
EMOJI_METHOD(smilingFaceWithHorns,1F608);
EMOJI_METHOD(winkingFace,1F609);
EMOJI_METHOD(smilingFaceWithSmilingEyes,1F60A);
EMOJI_METHOD(faceSavouringDeliciousFood,1F60B);
EMOJI_METHOD(relievedFace,1F60C);
EMOJI_METHOD(smilingFaceWithHeartShapedEyes,1F60D);
EMOJI_METHOD(smilingFaceWithSunglasses,1F60E);
EMOJI_METHOD(smirkingFace,1F60F);
EMOJI_METHOD(neutralFace,1F610);
EMOJI_METHOD(expressionlessFace,1F611);
EMOJI_METHOD(unamusedFace,1F612);
EMOJI_METHOD(faceWithColdSweat,1F613);
EMOJI_METHOD(pensiveFace,1F614);
EMOJI_METHOD(confusedFace,1F615);
EMOJI_METHOD(confoundedFace,1F616);
EMOJI_METHOD(kissingFace,1F617);
EMOJI_METHOD(faceThrowingAKiss,1F618);
EMOJI_METHOD(kissingFaceWithSmilingEyes,1F619);
EMOJI_METHOD(kissingFaceWithClosedEyes,1F61A);
EMOJI_METHOD(faceWithStuckOutTongue,1F61B);
EMOJI_METHOD(faceWithStuckOutTongueAndWinkingEye,1F61C);
EMOJI_METHOD(faceWithStuckOutTongueAndTightlyClosedEyes,1F61D);
EMOJI_METHOD(disappointedFace,1F61E);
EMOJI_METHOD(worriedFace,1F61F);
EMOJI_METHOD(angryFace,1F620);
EMOJI_METHOD(poutingFace,1F621);
EMOJI_METHOD(cryingFace,1F622);
EMOJI_METHOD(perseveringFace,1F623);
EMOJI_METHOD(faceWithLookOfTriumph,1F624);
EMOJI_METHOD(disappointedButRelievedFace,1F625);
EMOJI_METHOD(frowningFaceWithOpenMouth,1F626);
EMOJI_METHOD(anguishedFace,1F627);
EMOJI_METHOD(fearfulFace,1F628);
EMOJI_METHOD(wearyFace,1F629);
EMOJI_METHOD(sleepyFace,1F62A);
EMOJI_METHOD(tiredFace,1F62B);
EMOJI_METHOD(grimacingFace,1F62C);
EMOJI_METHOD(loudlyCryingFace,1F62D);
EMOJI_METHOD(faceWithOpenMouth,1F62E);
EMOJI_METHOD(hushedFace,1F62F);
EMOJI_METHOD(faceWithOpenMouthAndColdSweat,1F630);
EMOJI_METHOD(faceScreamingInFear,1F631);
EMOJI_METHOD(astonishedFace,1F632);
EMOJI_METHOD(flushedFace,1F633);
EMOJI_METHOD(sleepingFace,1F634);
EMOJI_METHOD(dizzyFace,1F635);
EMOJI_METHOD(faceWithoutMouth,1F636);
EMOJI_METHOD(faceWithMedicalMask,1F637);
EMOJI_METHOD(grinningCatFaceWithSmilingEyes,1F638);
EMOJI_METHOD(catFaceWithTearsOfJoy,1F639);
EMOJI_METHOD(smilingCatFaceWithOpenMouth,1F63A);
EMOJI_METHOD(smilingCatFaceWithHeartShapedEyes,1F63B);
EMOJI_METHOD(catFaceWithWrySmile,1F63C);
EMOJI_METHOD(kissingCatFaceWithClosedEyes,1F63D);
EMOJI_METHOD(poutingCatFace,1F63E);
EMOJI_METHOD(cryingCatFace,1F63F);
EMOJI_METHOD(wearyCatFace,1F640);
EMOJI_METHOD(faceWithNoGoodGesture,1F645);
EMOJI_METHOD(faceWithOkGesture,1F646);
EMOJI_METHOD(personBowingDeeply,1F647);
EMOJI_METHOD(seeNoEvilMonkey,1F648);
EMOJI_METHOD(hearNoEvilMonkey,1F649);
EMOJI_METHOD(speakNoEvilMonkey,1F64A);
EMOJI_METHOD(happyPersonRaisingOneHand,1F64B);
EMOJI_METHOD(personRaisingBothHandsInCelebration,1F64C);
EMOJI_METHOD(personFrowning,1F64D);
EMOJI_METHOD(personWithPoutingFace,1F64E);
EMOJI_METHOD(personWithFoldedHands,1F64F);

@end
