//
//  XPUITool.h
//  XPTool
//
//  Created by LinXipin on 2021/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPUITool : NSObject

/// alert弹窗
/// @param controller 需要弹窗的控制器
/// @param alertControllerStyle 弹窗的类型
/// @param title title
/// @param message message
/// @param cancelTitleStr 退出的按钮文字
/// @param otherTitlesStr 其他按钮的title
/// @param cancelActionBlock 退出的回调
/// @param othersActionBlock 其他按钮的回调
+ (void)alertControllerTOOLWithController:(UIViewController *)controller alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle title:(NSString *)title message:(NSString *)message cancelTitleStr:(NSString *)cancelTitleStr otherTitlesStr:(NSArray <NSString *>*)otherTitlesStr cancelActionBlock:(void(^)(void))cancelActionBlock othersActionBlock:(void(^)(NSString *actionTitle))othersActionBlock;



/// 设置灰度
/// @param originImage 图片
+ (UIImage *)unableImage:(UIImage*)originImage;


@end

NS_ASSUME_NONNULL_END
