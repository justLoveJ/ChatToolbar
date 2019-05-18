//
//  FaceView.m
//  ios-lebanban-app
//
//  Created by liepin on 2019/4/25.
//  Copyright © 2019年 liepin. All rights reserved.
//

#import "FaceCollectionView.h"
#import "HXConstants.h"
#import "HXEmojiEmoticons.h"
#import "FaceCell.h"


// 单个cell
@interface FaceItemLayout : NSObject
@property (nonatomic, strong, nonnull) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) int line;
@property (nonatomic, assign) int column;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong, nullable) HXFaceItem *item;
@end

@implementation FaceItemLayout

@end

// 组
@interface FaceSectionLayout: NSObject
@property (nonatomic, strong) NSArray <FaceItemLayout *>*itemsLayout;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) CGRect sectionRect;
@end

@implementation FaceSectionLayout
@end



@interface CustomFaceFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *,FaceItemLayout *>*items;
@property (nonatomic, strong) NSMutableArray <FaceSectionLayout *>*layoutSections;
@property (nonatomic, assign) CGSize contentSize;

- (instancetype)initWithRect:(CGRect)rect;
@end

@interface FaceCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CustomFaceFlowLayout *layout;
@end


@implementation FaceCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height);
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - public

- (void)setSelectSection:(int)section {
    if (self.layout.layoutSections.count > section) {
        FaceSectionLayout *sectionLayout = self.layout.layoutSections[section];
        [self.collectionView setContentOffset:CGPointMake(CGRectGetMinX(sectionLayout.sectionRect), 0)];
        if ([self.delegate respondsToSelector:@selector(pageNumberUpdate:total:section:)]) [self.delegate pageNumberUpdate:0 total:sectionLayout.pageSize section:section];
    }
}

- (HXFaceType)sectionTypeForSection:(int)section {
    if (self.layout.layoutSections.count > section) {
        return self.layout.layoutSections[section].itemsLayout.firstObject.item.emojiType;
    }
    return HXFaceType_custom;
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.layout.layoutSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.layout.layoutSections.count > section) {
        return self.layout.layoutSections[section].itemsLayout.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.layout.layoutSections.count < indexPath.section) {
        return UICollectionViewCell.new;
    }
    FaceSectionLayout *itemSction = self.layout.layoutSections[indexPath.section];
    if (itemSction.itemsLayout.count < indexPath.item) {
        return UICollectionViewCell.new;
    }
    FaceItemLayout *itemLayout = itemSction.itemsLayout[indexPath.item];
    
    __weak typeof(self)weakSelf = self;
    if (itemLayout.item) {
        if (itemLayout.item.emojiType == HXFaceType_customEmoji || itemLayout.item.emojiType == HXFaceType_systemEmoji) {
            
            EmojiCollectionCell *cell = (EmojiCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCollectionCell" forIndexPath:indexPath];
            cell.clickBlock = ^(HXFaceItem *item) {
                if ([weakSelf.delegate respondsToSelector:@selector(selectFaceItem:)]) [weakSelf.delegate selectFaceItem:item];
            };
            
            cell.item = itemLayout.item;
            return cell;
        }else {
            CustomFaceCollectionCell *cell = (CustomFaceCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomFaceCollectionCell" forIndexPath:indexPath];
            cell.item = itemLayout.item;
            cell.clickBlock = ^(HXFaceItem *item) {
                if ([weakSelf.delegate respondsToSelector:@selector(selectFaceItem:)]) [weakSelf.delegate selectFaceItem:item];
            };
            return cell;
        }
    }else {
        // 清除按钮
        ClearEmojiCollectionCell *cell = (ClearEmojiCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ClearEmojiCollectionCell" forIndexPath:indexPath];
        cell.clickBlock = ^{
          // 清楚
            if ([weakSelf.delegate respondsToSelector:@selector(clear)]) [weakSelf.delegate clear];
        };
        return cell;
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int page = round(scrollView.contentOffset.x / scrollView.frame.size.width) + 1;
    for (FaceSectionLayout *layout in self.layout.layoutSections) {
        if (layout.pageSize >= page) {
            if ([self.delegate respondsToSelector:@selector(pageNumberUpdate:total:section:)]) [self.delegate pageNumberUpdate:(page) total:layout.pageSize section:(int)layout.itemsLayout.firstObject.indexPath.section];
            break;
        }else {
            page -= layout.pageSize;
        }
    }
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = true;
        [_collectionView registerClass:[ClearEmojiCollectionCell class] forCellWithReuseIdentifier:@"ClearEmojiCollectionCell"];
        [_collectionView registerClass:[CustomFaceCollectionCell class] forCellWithReuseIdentifier:@"CustomFaceCollectionCell"];
        [_collectionView registerClass:[EmojiCollectionCell class] forCellWithReuseIdentifier:@"EmojiCollectionCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (CustomFaceFlowLayout *)layout {
    if (!_layout) {
        _layout = [[CustomFaceFlowLayout alloc] initWithRect:self.bounds];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

@end

struct faceFrame {
    int maxColumn;
    int maxLine;
    UIEdgeInsets sectionInsets;
    CGFloat itemWidth;
    CGFloat itemHeight;
};


struct faceFrame faceFrameWithType(HXFaceType type) {
    struct faceFrame frame = {};
    
    CGFloat collectionViewHeight = kHXChatBarFaceCollectionHeight;
    
    if (type == HXFaceType_systemEmoji || type == HXFaceType_customEmoji) {
        frame.maxColumn = [UIScreen mainScreen].bounds.size.width > 320 ? 8 :7;
        frame.maxLine = 3;
        // sectioninset底部距离顶部减去(kHXChatBarPageControlViewHeight - 4)/2，因为有底部pagecontrol
        frame.sectionInsets = UIEdgeInsetsMake(20, 20, 20 - (kHXChatBarPageControlViewHeight - 4)/2, 20);
    }else {
        frame.maxColumn = 4;
        frame.maxLine = 2;
        frame.sectionInsets = UIEdgeInsetsMake(10, 20, 10-(kHXChatBarPageControlViewHeight - 4)/2, 20);
    }
    frame.itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - (frame.sectionInsets.left + frame.sectionInsets.right))/frame.maxColumn;
    frame.itemHeight = (collectionViewHeight - (frame.sectionInsets.top + frame.sectionInsets.bottom))/frame.maxLine;
    return frame;
}

Boolean faceFrameIsEmpt(struct faceFrame frame) {
    return frame.itemWidth == 0;
}

@implementation CustomFaceFlowLayout


- (instancetype)initWithRect:(CGRect)rect {
    if (self = [super init]) {
        _items = [NSMutableDictionary dictionary];
        _layoutSections = [NSMutableArray array];
        
        NSArray *faces = [HXConfigManager sharedInstance].faceSections;
        FaceItemLayout *lastLayout = nil;
        struct faceFrame lastFrame = {};
        for (int section = 0; section < faces.count; section++) {
            HXFaceModule *module = faces[section];
            FaceSectionLayout *sectionLayout = [FaceSectionLayout new];
            sectionLayout.sectionRect = CGRectMake(0, 0, 0, rect.size.height);
            NSMutableArray *faceSectionList = [NSMutableArray array];
            struct faceFrame frame = faceFrameWithType(module.emojiType);
            if (section == 0) {
                lastFrame = frame;
            }
            
            for (int row = 0; row < module.faceSections.count; row++) {
                FaceItemLayout *itemLayout = [FaceItemLayout new];
                itemLayout.item = module.faceSections[row];
                
                if (row == 0) {// 新的section
                    itemLayout.indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    if (!lastLayout) {
                        // 第一个
                        itemLayout.rect = CGRectMake(frame.sectionInsets.left, frame.sectionInsets.top, frame.itemWidth, frame.itemHeight);
                        itemLayout.column = 0;
                        itemLayout.line = 0;
                    }else {
                        // 新的一组
                        CGFloat left = (CGRectGetMinX(lastLayout.rect) - lastLayout.column * CGRectGetWidth(lastLayout.rect) - lastFrame.sectionInsets.left) + CGRectGetWidth([UIScreen mainScreen].bounds);
                        itemLayout.rect = CGRectMake(left + frame.sectionInsets.left, frame.sectionInsets.top, frame.itemWidth, frame.itemHeight);
                        itemLayout.column = 0;
                        itemLayout.line = 0;
                    }
                    
                    // 记录section所处位置
                    sectionLayout.sectionRect = CGRectMake(CGRectGetMinX(itemLayout.rect) - frame.sectionInsets.left, 0, 0, rect.size.height);
                    
                    // 记录页码
                    sectionLayout.pageSize = 1;
                    
                    // 既然已经是一个section了，那么下一个的frame就是一致的，在这里重新赋值
                    lastFrame = frame;
                }else {
                    itemLayout.indexPath = [NSIndexPath indexPathForItem:lastLayout.indexPath.item + 1 inSection:section];
                    if (lastLayout.column == (frame.maxColumn - 1)) {
                        // 需要换页
                        if ((lastLayout.line + 1) == frame.maxLine) {
                            itemLayout.rect = CGRectMake(CGRectGetMaxX(lastLayout.rect) + frame.sectionInsets.left + frame.sectionInsets.right, frame.sectionInsets.top, frame.itemWidth, frame.itemHeight);
                            itemLayout.column = 0;
                            itemLayout.line = 0;
                            
                            // 页面➕1
                            sectionLayout.pageSize += 1;
                        }else {
                            // 需要换行
                            itemLayout.column = 0;
                            itemLayout.line = lastLayout.line + 1;
                            itemLayout.rect = CGRectMake(CGRectGetMinX(lastLayout.rect) - lastLayout.column * lastFrame.itemWidth, CGRectGetMaxY(lastLayout.rect), frame.itemWidth, frame.itemHeight);
                        }
                    }else {// 向后拼接
                        itemLayout.column = lastLayout.column + 1;
                        itemLayout.line = lastLayout.line;
                        itemLayout.rect = CGRectMake(CGRectGetMaxX(lastLayout.rect), CGRectGetMinY(lastLayout.rect), frame.itemWidth, frame.itemHeight);
                    }
                }
                
                // 当前item所处位置
                itemLayout.currentPage = sectionLayout.pageSize;
                // 记录当前item
                lastLayout = itemLayout;
                [faceSectionList addObject:itemLayout];
                [_items setObject:itemLayout forKey:itemLayout.indexPath];
                
                BOOL isLastForSection = (row == module.faceSections.count - 1);
                if (isLastForSection) {
                    // 记录section终点所处位置
                    CGFloat width = (CGRectGetMinX(lastLayout.rect) - lastLayout.column * CGRectGetWidth(lastLayout.rect) - lastFrame.sectionInsets.left) + CGRectGetWidth([UIScreen mainScreen].bounds);
                    sectionLayout.sectionRect = CGRectMake(CGRectGetMinX(sectionLayout.sectionRect), 0, width, rect.size.height);
                }
                
                // 是否emoji表情
                BOOL isEmojiFace = (module.emojiType == HXFaceType_customEmoji || module.emojiType == HXFaceType_systemEmoji);
                if (isEmojiFace) {
                    // 最有一个显示清除按钮
                    BOOL isLastForPage = (itemLayout.line == (frame.maxLine -1) && (itemLayout.column + 1)==(frame.maxColumn -1));
                    
                    if ((isLastForPage || isLastForSection)) {
                        // 手动添加一个
                        FaceItemLayout *clearItemLayout = [FaceItemLayout new];
                        clearItemLayout.indexPath = [NSIndexPath indexPathForItem:itemLayout.indexPath.item + 1 inSection:section];
                        // 设置最大
                        clearItemLayout.line = (frame.maxLine - 1);
                        clearItemLayout.column = frame.maxColumn - 1;
                        CGFloat left = ((CGRectGetMinX(itemLayout.rect) - itemLayout.column * frame.itemWidth) + frame.maxColumn * frame.itemWidth - frame.itemWidth);
                        CGFloat top = (CGRectGetMinY(itemLayout.rect) - itemLayout.line * frame.itemHeight) + frame.maxLine * frame.itemHeight - frame.itemHeight;
                        clearItemLayout.rect = CGRectMake(left, top, frame.itemWidth, frame.itemHeight);
                        lastLayout = clearItemLayout;
                        // 当前item所处位置
                        clearItemLayout.currentPage = sectionLayout.pageSize;
                        [faceSectionList addObject:clearItemLayout];
                        [_items setObject:clearItemLayout forKey:clearItemLayout.indexPath];
                    }
                }
            }
            
            if (faceSectionList.count > 0) {
                sectionLayout.itemsLayout = faceSectionList;
                [_layoutSections addObject:sectionLayout];
            }
        }
        
    }
    
    // 既然已经算出conetnesize了，就用到的时候直接返回
    if (_layoutSections.count > 0) {
        FaceItemLayout *lastItem = _layoutSections.lastObject.itemsLayout.lastObject;
        struct faceFrame frame = faceFrameWithType(lastItem.item.emojiType);
        self.contentSize = CGSizeMake((CGRectGetMinX(lastItem.rect) - lastItem.column * CGRectGetWidth(lastItem.rect)) - frame.sectionInsets.left + CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    }else {
        self.contentSize = CGSizeZero;
    }
    
    return self;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

// 便利当前位置的cell
- (NSArray *)indexPathWithRect:(CGRect)rect {
    NSMutableArray *list = [NSMutableArray array];
    for (int section = 0; section < _layoutSections.count; section++) {
        FaceSectionLayout *layoutSections = _layoutSections[section];
        for (int item = 0; item < layoutSections.itemsLayout.count; item++) {
            FaceItemLayout *layout = layoutSections.itemsLayout[item];
            if (CGRectIntersectsRect(rect, layout.rect)) {
                UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:layout.indexPath];
                att.frame = layout.rect;
                [list addObject:att];
            }
        }
    }
    return list;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 计算交叉面积
    rect = CGRectIntersection(rect, CGRectMake(0, 0, self.contentSize.width, self.contentSize.height));
    if (rect.size.width == 0) {
        NSLog(@"22222222");
        return nil;
    }
    rect.size.height = kHXChatBarFaceCollectionHeight;
    return [self indexPathWithRect:rect];
}
@end










