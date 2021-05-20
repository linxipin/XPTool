//
//  XPCollectionViewAlignLayout.m
//  XPCollectionViewAlignLayout
//
//  Created by lxp on 2017/12/28.
//  Copyright © 2017年 lxp. All rights reserved.
//

#import "XPCollectionViewAlignLayout.h"

@interface XPCollectionViewAlignLayout ()

@property (nonatomic, strong) NSMutableDictionary *cachedOrigin;

@end

@implementation XPCollectionViewAlignLayout (attributes)

- (CGFloat)jq_minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)jq_insetForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        return self.sectionInset;
    }
}

- (XPCollectionViewItemsHorizontalAlignment)jq_itemsHorizontalAlignmentForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:itemsHorizontalAlignmentInSection:)]) {
        id<XPCollectionViewAlignLayoutDelegate> delegate = (id<XPCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self itemsHorizontalAlignmentInSection:section];
    } else {
        return self.itemsHorizontalAlignment;
    }
}

- (XPCollectionViewItemsVerticalAlignment)jq_itemsVerticalAlignmentForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:itemsVerticalAlignmentInSection:)]) {
        id<XPCollectionViewAlignLayoutDelegate> delegate = (id<XPCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self itemsVerticalAlignmentInSection:section];
    } else {
        return self.itemsVerticalAlignment;
    }
}

- (XPCollectionViewItemsDirection)jq_itemsDirectionForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:itemsDirectionInSection:)]) {
        id<XPCollectionViewAlignLayoutDelegate> delegate = (id<XPCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self itemsDirectionInSection:section];
    } else {
        return self.itemsDirection;
    }
}

@end

@implementation XPCollectionViewAlignLayout (line)

- (BOOL)jq_isLineStartAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return YES;
    }
    NSIndexPath *currentIndexPath = indexPath;
    NSIndexPath *previousIndexPath = indexPath.item == 0 ? nil : [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];

    UICollectionViewLayoutAttributes *currentAttributes = [super layoutAttributesForItemAtIndexPath:currentIndexPath];
    UICollectionViewLayoutAttributes *previousAttributes = previousIndexPath ? [super layoutAttributesForItemAtIndexPath:previousIndexPath] : nil;
    CGRect currentFrame = currentAttributes.frame;
    CGRect previousFrame = previousAttributes ? previousAttributes.frame : CGRectZero;

    UIEdgeInsets insets = [self jq_insetForSectionAtIndex:currentIndexPath.section];
    CGRect currentLineFrame = CGRectMake(insets.left, currentFrame.origin.y, CGRectGetWidth(self.collectionView.frame), currentFrame.size.height);
    CGRect previousLineFrame = CGRectMake(insets.left, previousFrame.origin.y, CGRectGetWidth(self.collectionView.frame), previousFrame.size.height);

    return !CGRectIntersectsRect(currentLineFrame, previousLineFrame);
}

- (NSArray *)jq_lineAttributesArrayWithStartAttributes:(UICollectionViewLayoutAttributes *)startAttributes {
    NSMutableArray *lineAttributesArray = [[NSMutableArray alloc] init];
    [lineAttributesArray addObject:startAttributes];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:startAttributes.indexPath.section];
    UIEdgeInsets insets = [self jq_insetForSectionAtIndex:startAttributes.indexPath.section];
    NSInteger index = startAttributes.indexPath.item;
    BOOL isLineEnd = index == itemCount - 1;
    while (!isLineEnd) {
        index++;
        if (index == itemCount)
            break;
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index inSection:startAttributes.indexPath.section];
        UICollectionViewLayoutAttributes *nextAttributes = [super layoutAttributesForItemAtIndexPath:nextIndexPath];
        CGRect nextLineFrame = CGRectMake(insets.left, nextAttributes.frame.origin.y, CGRectGetWidth(self.collectionView.frame), nextAttributes.frame.size.height);
        isLineEnd = !CGRectIntersectsRect(startAttributes.frame, nextLineFrame);
        if (isLineEnd)
            break;
        [lineAttributesArray addObject:nextAttributes];
    }
    return lineAttributesArray;
}

@end

@implementation XPCollectionViewAlignLayout (alignment)

- (void)jq_cacheTheItemOrigin:(CGPoint)origin forIndexPath:(NSIndexPath *)indexPath {
    self.cachedOrigin[indexPath] = @(origin);
}

- (NSValue *)jq_cachedItemOriginAtIndexPath:(NSIndexPath *)indexPath {
    return self.cachedOrigin[indexPath];
}

- (void)jq_calculateAndCacheOriginForItemAttributesArray:(NSArray<UICollectionViewLayoutAttributes *> *)array {
    NSInteger section = [array firstObject].indexPath.section;

    //******************** layout infos ********************//
    XPCollectionViewItemsHorizontalAlignment horizontalAlignment = [self jq_itemsHorizontalAlignmentForSectionAtIndex:section];
    XPCollectionViewItemsVerticalAlignment verticalAlignment = [self jq_itemsVerticalAlignmentForSectionAtIndex:section];
    XPCollectionViewItemsDirection direction = [self jq_itemsDirectionForSectionAtIndex:section];
    BOOL isR2L = direction == XPCollectionViewItemsDirectionRTL;
    UIEdgeInsets sectionInsets = [self jq_insetForSectionAtIndex:section];
    CGFloat minimumInteritemSpacing = [self jq_minimumInteritemSpacingForSectionAtIndex:section];
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    
    //******************** temp origin.y ********************//
    CGFloat tempOriginY = 0.f;
    NSArray *frameValues = [array valueForKeyPath:@"frame"];
    if (verticalAlignment == XPCollectionViewItemsVerticalAlignmentTop) {
        tempOriginY = CGFLOAT_MAX;
        for (NSValue *frameValue in frameValues) {
            tempOriginY = MIN(tempOriginY, CGRectGetMinY(frameValue.CGRectValue));
        }
    } else if (verticalAlignment == XPCollectionViewItemsVerticalAlignmentBottom) {
        tempOriginY = CGFLOAT_MIN;
        for (NSValue *frameValue in frameValues) {
            tempOriginY = MAX(tempOriginY, CGRectGetMaxY(frameValue.CGRectValue));
        }
    }
    
    //******************** start and space ********************//
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attr in array) {
        [widthArray addObject:@(CGRectGetWidth(attr.frame))];
    }
    CGFloat totalWidth = [[widthArray valueForKeyPath:@"@sum.self"] floatValue];
    CGFloat start = 0.f, space = 0.f;
    NSInteger totalCount = array.count;
    switch (horizontalAlignment) {
        case XPCollectionViewItemsHorizontalAlignmentLeft: {
            start = isR2L ? (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - minimumInteritemSpacing * (totalCount - 1)) : sectionInsets.left;
            space = minimumInteritemSpacing;
        } break;

        case XPCollectionViewItemsHorizontalAlignmentCenter: {
            CGFloat rest = (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - sectionInsets.right - minimumInteritemSpacing * (totalCount - 1)) / 2.f;
            start = isR2L ? sectionInsets.right + rest : sectionInsets.left + rest;
            space = minimumInteritemSpacing;
        } break;

        case XPCollectionViewItemsHorizontalAlignmentRight: {
            start = isR2L ? sectionInsets.right : (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.right - minimumInteritemSpacing * (totalCount - 1));
            space = minimumInteritemSpacing;
        } break;

        case XPCollectionViewItemsHorizontalAlignmentFlow: {
            BOOL isEnd = array.lastObject.indexPath.item == [self.collectionView numberOfItemsInSection:section] - 1;
            start = isR2L ? sectionInsets.right : sectionInsets.left;
            space = isEnd ? minimumInteritemSpacing : (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - sectionInsets.right) / (totalCount - 1);
        } break;

        default:
            break;
    }
    
    //******************** calculate and cache origin ********************//
    CGFloat lastMaxX = 0.f;
    for (int i = 0; i < widthArray.count; i++) {
        UICollectionViewLayoutAttributes *attr = array[i];
        CGFloat width = [widthArray[i] floatValue];
        CGFloat originX = 0.f;
        if (isR2L) {
            originX = i == 0 ? collectionViewWidth - start - contentInsets.right - contentInsets.left - width : lastMaxX - space - width;
            lastMaxX = originX;
        } else {
            originX = i == 0 ? start : lastMaxX + space;
            lastMaxX = originX + width;
        }
        CGFloat originY;
        if (verticalAlignment == XPCollectionViewItemsVerticalAlignmentBottom) {
            originY = tempOriginY - CGRectGetHeight(attr.frame);
        } else if (verticalAlignment == XPCollectionViewItemsVerticalAlignmentCenter) {
            originY = attr.frame.origin.y;
        } else {
            originY = tempOriginY;
        }
        [self jq_cacheTheItemOrigin:CGPointMake(originX, originY) forIndexPath:attr.indexPath];
    }
}

@end

@implementation XPCollectionViewAlignLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.cachedOrigin = @{}.mutableCopy;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = originalAttributes.mutableCopy;
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind || attributes.representedElementCategory == UICollectionElementCategoryCell) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // This is likely occurring because the flow layout subclass XPCollectionViewAlignLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
    UICollectionViewLayoutAttributes *currentAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];

    // 获取缓存的当前 indexPath 的 item origin value
    NSValue *originValue = [self jq_cachedItemOriginAtIndexPath:indexPath];
    CGPoint origin;
    // 如果没有缓存的 item origin value，则计算并缓存然后获取
    if (!originValue) {
        // 判断是否为一行中的首个
        BOOL isLineStart = [self jq_isLineStartAtIndexPath:indexPath];
        // 如果是一行中的首个
        if (isLineStart) {
            // 获取当前行的所有 UICollectionViewLayoutAttributes
            NSArray *line = [self jq_lineAttributesArrayWithStartAttributes:currentAttributes];
            if (line.count) {
                // 计算并缓存当前行的所有 UICollectionViewLayoutAttributes origin
                [self jq_calculateAndCacheOriginForItemAttributesArray:line];
            }
        }
        // 获取位于当前 indexPath 的 item origin
        originValue = [self jq_cachedItemOriginAtIndexPath:indexPath];
    }
    if (originValue) {
        // 设置缓存的当前 indexPath 的 item origin
        origin = [originValue CGPointValue];
        CGRect currentFrame = currentAttributes.frame;
        // 获取当前 indexPath 的 item origin 后修改当前 layoutAttributes.frame.origin
        currentFrame.origin = origin;
        currentAttributes.frame = currentFrame;
    }
    
    return currentAttributes;
}

@end
