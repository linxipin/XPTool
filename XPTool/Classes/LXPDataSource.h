//
//  LXPDataSource.h
//  LMShopCart
//
//  Created by linxipin on 2018/3/29.
//  Copyright © 2018年 linxipin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
///配置cell的block
typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);
///
///选择cell的block
///
typedef void (^SelectCell) (NSIndexPath *indexPath);
///
///刷新tableView
///
typedef void (^ReloadData) (NSMutableArray *array);

@interface LXPDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource,UITableViewDelegate,UICollectionViewDelegate>

@property (nonatomic, strong)  NSMutableArray *dataArray;

@property (nonatomic, copy) SelectCell selectBlock;

@property (nonatomic, copy) ReloadData reloadData;
///
///初始化
///
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before selectBlock:(SelectCell)selectBlock;
///
///tableView/collectionView的数据
///
- (void)addDataArray:(NSArray *)datas;
///
/// tableView 是否允许编辑
///
@property (assign, nonatomic) BOOL tableViewCanEdit;
///
///tableViewRowActionArray
///
@property (strong, nonatomic) NSArray<UITableViewRowAction *> *tableViewRowActionArray;
///
///
///
- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;


@end
