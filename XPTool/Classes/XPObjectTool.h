//
//  XPObjectTool.h
//  XPTool
//
//  Created by LinXipin on 2021/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPObjectTool : NSObject

/// 字符串脱敏
/// @param string 需要脱敏的字符串
/// @param replaceStr 代替的字符串
/// @param location 位置
/// @param length 长度
+ (NSString *)stringRemoveSensitiveWithString:(NSString *)string toReplaceString:(NSString *)replaceStr location:(NSInteger)location length:(NSInteger)length;


/// 时间转换
/// @param timestamp 时间戳
/// @param format  e.g. @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)time_timestampToString:(NSInteger)timestamp format:(NSString *)format;
//获取指定过去或者将来时间的年月日
//e.g.:[XPObjectTool getYMDWithAfterYearNumber:-1 monthNumber:0 dayNumber:0] 上一年的这个时候
+ (NSString *)getYMDWithAfterYearNumber:(NSInteger)year monthNumber:(NSInteger)month dayNumber:(NSInteger)day;


/// 计算文字高度
/// @param str 字符串
/// @param font 字号
/// @param maxSize 最大宽度
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

/// label行间距
/// @param str string
/// @param lineSpacing 间距
+(NSMutableAttributedString *)lineSpacingWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing;

//根据身份证号获取生日
+(NSString *)getBirthdayStrFromIdentityCard:(NSString *)numberStr;
//根据身份证号性别
+(NSString *)getIdentityCardSex:(NSString *)numberStr;
//根据身份证获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr;


/// 排序字典
/// @param dict 要排序的字典
+ (void)sortedDictionary:(NSDictionary *)dict;


//判断版本号
+(BOOL)needUpdate:(NSString*)lastVersion oldVersion:(NSString*) oldVersion;

@end

NS_ASSUME_NONNULL_END
