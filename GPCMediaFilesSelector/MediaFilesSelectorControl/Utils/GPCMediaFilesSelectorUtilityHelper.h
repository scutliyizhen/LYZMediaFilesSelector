//
//  GPCMediaFilesSelectorUtilityHelper.h
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 16/8/24.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 用于将ui给的颜色转化为oc的颜色
 */

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))
#define RGBAColorC(c)        RGBAColor(((((int)c) >> 24) & 0xff),((((int)c) >> 16) & 0xff),((((int)c) >> 8) & 0xff),(((int)c) & 0xff)/255.0)

//ui布局比例
#define GPC_WIDTH_RATIO_6_plus   (750/720.0)
#define GPC_HEIGHT_RATIO_6_plus  (1334/1280.0)

#define GPC_WIDTH_RATIO_not_6_plus   (([[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale)/720.0)
#define GPC_HEIGHT_RATIO_not_6_plus  (([[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale)/1280.0)

#define GPC_WIDTH_RATIO (([[UIScreen mainScreen] bounds].size.width == 750) ? (GPC_WIDTH_RATIO_6_plus) : (GPC_WIDTH_RATIO_not_6_plus))
#define GPC_HEIGHT_RATIO (([[UIScreen mainScreen] bounds].size.width == 1334) ? (GPC_HEIGHT_RATIO_6_plus) : (GPC_HEIGHT_RATIO_not_6_plus))

//系统版本大大于8.0
#define GPC_IOS_SYSTEM_VERSION_GREATER_8_0 ([GPCMediaFilesSelectorUtilityHelper GetCurrentSystemVersion] >= 8.0)

typedef NS_ENUM(NSInteger, SYBIOSVersion) {
    SYB_iOS_5 = 5,
    SYB_iOS_6 = 6,
    SYB_iOS_7 = 7,
    SYB_iOS_8 = 8,
};

@interface GPCMediaFilesSelectorUtilityHelper : NSObject
+ (void)showTipsWithMessage:(NSString *)msg;
+ (double)GetCurrentSystemVersion;

+ (CGRect)getStatusBarFrame;
+ (CGRect)getMainScreenBounds;
+ (CGSize)getFontSizeByFont:(UIFont*)font text:(NSString*)text;
+ (CGSize)getMultilineFontSizeByFont:(UIFont *)font text:(NSString *)text maxWidth:(CGFloat)maxWidth;

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;

/**
 在特定操作系统版本下执行代码
 @param systemVersion iOS版本，将在这个版本或这个版本之上执行代码
 @param codeBlock 要执行的block代码
 */
+ (void)executeInIOS:(SYBIOSVersion)iosVersion withCode:(void(^)(void))codeBlock;
@end
