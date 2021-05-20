//
//  UICollectionView+CollectionViewEmptyData.h
//  MoHRaSSObject
//
//  Created by LXP on 2018/5/18.
//  Copyright © 2018年 LXP All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CollectionViewEmptyData)

- (void)collectionDisplayWitMsg:(NSString *) message imageViewName:(NSString *)imageViewName ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
