//
//  XPObjectTool.m
//  XPTool
//
//  Created by LinXipin on 2021/5/20.
//

#import "XPObjectTool.h"

@implementation XPObjectTool

/// 字符串脱敏
/// @param string 需要脱敏的字符串
/// @param replaceStr 代替的字符串
/// @param location 位置
/// @param length 长度
+ (NSString *)stringRemoveSensitiveWithString:(NSString *)string toReplaceString:(NSString *)replaceStr location:(NSInteger)location length:(NSInteger)length {
    NSString *returnStr = string;
    NSString *r_e_p_l_a_c_e = @"";
    if (length == 1) {
        r_e_p_l_a_c_e = replaceStr;
    }else {
        for (int i = 0; i < length; i++) {
            r_e_p_l_a_c_e = [r_e_p_l_a_c_e stringByAppendingString:replaceStr];
        }
    }

    if (returnStr && returnStr.length >= (location + length)) {
        returnStr = [returnStr stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:r_e_p_l_a_c_e];//防止号码有前缀所以使用倒数第8位开始替换
    }
    return returnStr;
}



///时间戳转化为字符转0000-00-00 00:00
/// e.g. @"yyyy-MM-dd HH:mm:ss"

+ (NSString *)time_timestampToString:(NSInteger)timestamp format:(NSString *)format{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

//获取指定过去或者将来时间的年月日
//e.g.:[XPObjectTool getYMDWithAfterYearNumber:-1 monthNumber:0 dayNumber:0] 上一年的这个时候
+ (NSString *)getYMDWithAfterYearNumber:(NSInteger)yearNum monthNumber:(NSInteger)monthNum dayNumber:(NSInteger)dayNum {
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
        
    NSInteger year = [dataCom year];
    NSInteger month = [dataCom month];
    NSInteger day = [dataCom day];
    
    NSString *yearStr = [NSString stringWithFormat:@"%ld",(year + yearNum)];
    NSString *monthStr = (month + monthNum)>9?[NSString stringWithFormat:@"%ld",(month + monthNum)]:[NSString stringWithFormat:@"0%ld",(month + monthNum)];
    NSString *dayStr = (day + dayNum)>9?[NSString stringWithFormat:@"%ld",(day + dayNum)]:[NSString stringWithFormat:@"0%ld",(day + dayNum)];
 
    return [NSString stringWithFormat:@"%@%@%@",yearStr,monthStr,dayStr];
}

/// 计算文字高度
/// @param str 字符串
/// @param font 字号
/// @param maxSize 最大宽度
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}
/// label行间距
/// @param str string
/// @param lineSpacing 间距
+(NSMutableAttributedString *)lineSpacingWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:lineSpacing];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}

//根据身份证号获取生日
+(NSString *)getBirthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;

    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14){
        return result;
    }
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];

    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9')){
            isAllNumber = NO;
        }
        p++;
    }
    if(!isAllNumber){
        return result;
    }

    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];

    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}
//根据身份证号性别
+(NSString *)getIdentityCardSex:(NSString *)numberStr {
    int sexInt=[[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
    if(sexInt%2 == 1){
        return @"男";
    } else {
        return @"女";
    }
}
//根据省份证号获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr {
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[self getBirthdayStrFromIdentityCard:numberStr]];
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    int age = trunc(dateDiff/(60*60*24))/365;
    return [NSString stringWithFormat:@"%d",abs(age)];
}



/**
 对字典(Key-Value)排序 区分大小写
 @param dict 要排序的字典
 */
+ (void)sortedDictionary:(NSDictionary *)dict{
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        /**
          In the compare: methods, the range argument specifies the
          subrange, rather than the whole, of the receiver to use in the
          comparison. The range is not applied to the search string.  For
          example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
          compares "A" to "ABC", not "A" to "A", and will return
          NSOrderedAscending. It is an error to specify a range that is
          outside of the receiver's bounds, and an exception may be raised.
         
        - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    NSLog(@"valueArray:%@",valueArray);
}



//判断版本号
+(BOOL)needUpdate:(NSString*)lastVersion oldVersion:(NSString*) oldVersion{
    NSArray *last = [lastVersion componentsSeparatedByString:@"."];
    NSArray *old = [oldVersion componentsSeparatedByString:@"."];
    long int count = MIN([last count], [old count]);
    for (int i=0; i<count; i++) {
       int lastInt= [[last objectAtIndex:i] intValue];
       int oldInt= [[old objectAtIndex:i] intValue];
        if (lastInt>oldInt) {
            return YES;
        }else if(oldInt>lastInt){
            return NO;
        }
    }
    return NO;
}

@end
