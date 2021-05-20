//
//  UICollectionView+CollectionViewEmptyData.m
//  MoHRaSSObject
//
//  Created by KKKKKKK on 2018/5/18.
//  Copyright © 2018年 KKKKKKK All rights reserved.
//

#import "UICollectionView+CollectionViewEmptyData.h"

@implementation UICollectionView (CollectionViewEmptyData)

-(void)collectionDisplayWitMsg:(NSString *)message imageViewName:(NSString *)imageViewName ifNecessaryForRowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        // Display a message when the collection is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *bgView = [UIView new];
        
        UIImageView *tmptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 160)];
        [tmptyImageView setImage:[UIImage imageNamed:imageViewName]];
        tmptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tmptyImageView.frame.origin.y + tmptyImageView.frame.size.height +5, [UIScreen mainScreen].bounds.size.width, 30)];
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        [messageLabel setFont:[UIFont systemFontOfSize:(12)]];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        //        [messageLabel sizeToFit];
        
        [bgView addSubview:tmptyImageView];
        [bgView addSubview:messageLabel];
        
        self.backgroundView = bgView;
    } else {
        self.backgroundView = nil;
    }
}

@end
