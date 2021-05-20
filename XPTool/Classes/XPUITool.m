//
//  XPUITool.m
//  XPTool
//
//  Created by LinXipin on 2021/5/20.
//

#import "XPUITool.h"

@implementation XPUITool

/// alert弹窗
/// @param controller 需要弹窗的控制器
/// @param alertControllerStyle 弹窗的类型
/// @param title title
/// @param message message
/// @param cancelTitleStr 退出的按钮文字
/// @param otherTitlesStr 其他按钮的title
/// @param cancelActionBlock 退出的回调
/// @param othersActionBlock 其他按钮的回调
+ (void)alertControllerTOOLWithController:(UIViewController *)controller alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle title:(NSString *)title message:(NSString *)message cancelTitleStr:(NSString *)cancelTitleStr otherTitlesStr:(NSArray <NSString *>*)otherTitlesStr cancelActionBlock:(void(^)(void))cancelActionBlock othersActionBlock:(void(^)(NSString *actionTitle))othersActionBlock {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(alertControllerStyle)];
    
    [otherTitlesStr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:obj style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) { othersActionBlock(obj); }]; [alertVC addAction:otherAction];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitleStr style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) { cancelActionBlock(); }]; [alertVC addAction:cancelAction];

    [controller presentViewController:alertVC animated:YES completion:^{
        
    }];
}

/// 设置灰度
/// @param originImage 图片
+ (UIImage *)unableImage:(UIImage*)originImage{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
//    // 修改亮度   -1---1   数越大越亮
    [lighten setValue:@(0) forKey:@"inputBrightness"];
    // 修改饱和度  0---2
    [lighten setValue:@(0) forKey:@"inputSaturation"];
//    // 修改对比度  0---4
    [lighten setValue:@(0.5) forKey:@"inputContrast"];
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    // 得到修改后的图片
    UIImage *newImage =  [UIImage imageWithCGImage:cgImage];
    // 释放对象
    CGImageRelease(cgImage);
    return newImage;
}

@end
