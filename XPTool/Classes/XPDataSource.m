//
//  XPDataSource.m
//  LMShopCart
//
//  Created by linxipin on 2018/3/29.
//  Copyright © 2018年 linxipin. All rights reserved.
//

#import "XPDataSource.h"

@interface XPDataSource ()

//sb
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

@property (nonatomic, copy) CellConfigureBefore cellConfigureBefore;

@end

@implementation XPDataSource

- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before  selectBlock:(SelectCell)selectBlock {
    if(self = [super init]) {
        _cellIdentifier = identifier;
        _cellConfigureBefore = [before copy];
        _selectBlock = [selectBlock copy];
    }
    return self;
}


- (void)addDataArray:(NSArray *)datas{
    if(!datas) return;
    
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:datas];
    
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray.count > indexPath.row ? self.dataArray[indexPath.row] : nil;
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !self.dataArray ? 0: self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    if(self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model,indexPath);
    }
    return cell;
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return !self.dataArray ? 0 : self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    
    if(self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model,indexPath);
    }

    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 将点击事件通过block的方式传递出去
    self.selectBlock(indexPath);
}

#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 将点击事件通过block的方式传递出去
    self.selectBlock(indexPath);
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
    
}

//是否编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableViewCanEdit;
}

//编辑侧滑的按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableViewRowActionArray;
}


//// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//    }
//}
//
//// 修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

@end

