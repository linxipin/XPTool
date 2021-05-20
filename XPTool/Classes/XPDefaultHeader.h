//
//  XPDefaultHeader.h
//  XPTool
//
//  Created by LinXipin on 2021/5/20.
//

#ifndef XPDefaultHeader_h
#define XPDefaultHeader_h

#pragma mark - 代码缩写
//property属性快速声明
#define PropertyString(s) @property(nonatomic,copy) NSString * s
#define PropertyNSInteger(s) @property(nonatomic,assign) NSInteger s
#define PropertyFloat(s) @property(nonatomic,assign) float s
#define PropertyLongLong(s) @property(nonatomic,assign) long long  s
#define PropertyNSDictionary(s) @property(nonatomic,strong) NSDictionary * s
#define PropertyNSArray(s) @property(nonatomic,strong) NSArray * s
#define PropertyNSMutableArray(s) @property(nonatomic,strong) NSMutableArray * s
//系统代码的缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults      [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//先全局定义NSUserDefaults的宏定义缩写
#define LXPUserDefaultsGET(key) [[NSUserDefaults standardUserDefaults] objectForKey:key] // 取
#define LXPUserDefaultsSET(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]  // 写
#define LXPUserDefaultsSynchronize [[NSUserDefaults standardUserDefaults] synchronize] // 存
#define LXPUserDefaultsRemove(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]  // 删


#pragma mark - 图片相关
// 图片相关
#define IMAGE_NAMED(name)[UIImage imageNamed:name]

#pragma mark - 开发的时候打印，但是发布的时候不打印的NSLog
//开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

#pragma mark - 弱引用/强引用
//弱引用/强引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define LXP_WEAKSELF      __weak typeof(self) weakSelf = self;



#pragma mark - // NSObject

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#pragma mark - // UI

//View圆角和加边框
#define ViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角
#define ViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)[UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME,FONTSIZE)[UIFont fontWithName:(NAME)size:(FONTSIZE)]

//颜色
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成
#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//根据ip6的屏幕来拉伸
#define kRealValue(WIDTH)((WIDTH)*(SCREEN_WIDTH/375.0f))

//提示框 只有一个确定的系统提示框
#define  ALERT_MSG(TITLE,MESSAGE,CONTROLLER) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];\
[alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];\
[CONTROLLER presentViewController:alertController animated:YES completion:nil];

//SDWebImage
#define SD_CUSTOM_IMAGEVIEW(imageView, urlString, defaultImageName) [imageView sd_setShowActivityIndicatorView:YES]; [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray]; [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:defaultImageName] options:(SDWebImageRetryFailed|SDWebImageScaleDownLargeImages) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) { if (cacheType == 1 || cacheType == 2 || error != nil) {return;} imageView.alpha = 0; [UIView animateWithDuration:0.5 animations:^{ imageView.alpha = 1; }]; }]



 #pragma mark - //专门用来保存单例代码
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#endif /* XPDefaultHeader_h */
