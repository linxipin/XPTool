//
//  UITableView+TableViewEmptyData.h
//  FaceToFaceObject
//
//  Created by KKKKKKK on 2017/7/22.
//  Copyright © 2017年 KKKKKKK All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TableViewEmptyData)

- (void)tableViewDisplayWitMsg:(NSString *) message imageViewName:(NSString *)imageViewName ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
