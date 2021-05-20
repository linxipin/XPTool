//
//  XPCollectionViewAlignLayout.h
//  XPCollectionViewAlignLayout
//
//  Created by lxp on 2017/12/28.
//  Copyright © 2017年 lxp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XPCollectionViewItemsHorizontalAlignment) {
    XPCollectionViewItemsHorizontalAlignmentFlow,   /**< 水平流式(水平方向效果与 UICollectionViewDelegateFlowLayout 一致) */
    XPCollectionViewItemsHorizontalAlignmentLeft,   /**< 水平居左 */
    XPCollectionViewItemsHorizontalAlignmentCenter, /**< 水平居中 */
    XPCollectionViewItemsHorizontalAlignmentRight   /**< 水平居右 */
};

typedef NS_ENUM(NSInteger, XPCollectionViewItemsVerticalAlignment) {
    XPCollectionViewItemsVerticalAlignmentCenter,   /**< 竖直方向居中 */
    XPCollectionViewItemsVerticalAlignmentTop,      /**< 竖直方向顶部对齐 */
    XPCollectionViewItemsVerticalAlignmentBottom    /**< 竖直方向底部对齐 */
};

typedef NS_ENUM(NSInteger, XPCollectionViewItemsDirection) {
    XPCollectionViewItemsDirectionLTR,              /**< 排布方向从左到右 */
    XPCollectionViewItemsDirectionRTL               /**< 排布方向从右到左 */
};

@class LXPCollectionViewAlignLayout;

/// 扩展 UICollectionViewDelegateFlowLayout 协议，添加设置水平竖直对齐方式及 items 排布方向协议方法
@protocol XPCollectionViewAlignLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

/// 设置不同 section items 水平方向的对齐方式
/// @param collectionView UICollectionView 对象
/// @param layout 布局对象
/// @param section section
- (XPCollectionViewItemsHorizontalAlignment)collectionView:(UICollectionView *)collectionView layout:(LXPCollectionViewAlignLayout *)layout itemsHorizontalAlignmentInSection:(NSInteger)section;

/// 设置不同 section items 竖直方向的对齐方式
/// @param collectionView UICollectionView 对象
/// @param layout 布局对象
/// @param section section
- (XPCollectionViewItemsVerticalAlignment)collectionView:(UICollectionView *)collectionView layout:(LXPCollectionViewAlignLayout *)layout itemsVerticalAlignmentInSection:(NSInteger)section;

/// 设置不同 section items 的排布方向
/// @param collectionView UICollectionView 对象
/// @param layout 布局对象
/// @param section section
- (XPCollectionViewItemsDirection)collectionView:(UICollectionView *)collectionView layout:(LXPCollectionViewAlignLayout *)layout itemsDirectionInSection:(NSInteger)section;

@end

/// 在 UICollectionViewFlowLayout 基础上，自定义 UICollectionView 对齐布局
///
/// 实现以下功能：
/// 1. 设置水平方向对齐方式：流式（默认）、居左、居中、居右、平铺；
/// 2. 设置竖直方向对齐方式：居中（默认）、置顶、置底；
/// 3. 设置显示条目排布方向：从左到右（默认）、从右到左。
@interface XPCollectionViewAlignLayout : UICollectionViewFlowLayout

/// 水平方向对齐方式，默认为流式 XPCollectionViewItemsHorizontalAlignmentFlow
@property (nonatomic) XPCollectionViewItemsHorizontalAlignment itemsHorizontalAlignment;
/// 竖直方向对齐方式，默认为居中 XPCollectionViewItemsVerticalAlignmentCenter
@property (nonatomic) XPCollectionViewItemsVerticalAlignment itemsVerticalAlignment;
/// items 排布方向，默认为从左到右 XPCollectionViewItemsDirectionLTR
@property (nonatomic) XPCollectionViewItemsDirection itemsDirection;

@end

@interface XPCollectionViewAlignLayout (unavailable)

// 禁用 setScrollDirection: 方法，不可设置滚动方向，默认为竖直滚动 UICollectionViewScrollDirectionVertical
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection NS_UNAVAILABLE;

@end
