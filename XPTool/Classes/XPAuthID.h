//
//  XPAuthID.h
//  HSAApp-XinJiang
//
//  Created by LinXipin on 2020/10/30.
//  Copyright © 2020 James. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  TouchID/FaceID 状态
 */
typedef NS_ENUM(NSUInteger, XPAuthIDState){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    XPAuthIDStateNotSupport = 0,
    /**
     *  TouchID/FaceID 验证成功
     */
    XPAuthIDStateSuccess = 1,
    
    /**
     *  TouchID/FaceID 验证失败
     */
    XPAuthIDStateFail = 2,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    XPAuthIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    XPAuthIDStateInputPassword = 4,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    XPAuthIDStateSystemCancel = 5,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    XPAuthIDStatePasswordNotSet = 6,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID
     */
    XPAuthIDStateTouchIDNotSet = 7,
    /**
     *  TouchID/FaceID 无效
     */
    XPAuthIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    XPAuthIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    XPAuthIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    XPAuthIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    XPAuthIDStateVersionNotSupport = 12
};


@interface XPAuthID : LAContext

typedef void (^XPAuthIDStateBlock)(XPAuthIDState state, NSError *error);

/**
 * 启动TouchID/FaceID进行验证
 * @param describe TouchID/FaceID显示的描述
 * @param block 回调状态的block
 */
- (void)xp_showAuthIDWithDescribe:(nullable NSString *)describe block:(XPAuthIDStateBlock)block;

@end


NS_ASSUME_NONNULL_END
