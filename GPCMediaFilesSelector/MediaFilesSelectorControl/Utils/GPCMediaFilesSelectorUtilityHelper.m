//
//  UtilityHelper.m
//  GPCMediaFilesSelector
//
//  Created by robertyzli on 16/8/24.
//  Copyright © 2016年 robertyzli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"

@implementation GPCMediaFilesSelectorUtilityHelper
+ (double)GetCurrentSystemVersion
{
    return [[UIDevice currentDevice].systemVersion doubleValue];
}

+ (CGRect)getStatusBarFrame
{
    return [UIApplication sharedApplication].statusBarFrame;
}

+ (CGRect)getMainScreenBounds
{
    return [UIScreen mainScreen].bounds;
}

+ (CGSize)getFontSizeByFont:(UIFont*)font text:(NSString*)text
{
    if(font == nil || text == nil)
    {
        return CGSizeZero;
    }
    
    CGSize lableSize = CGSizeZero;
    if([GPCMediaFilesSelectorUtilityHelper GetCurrentSystemVersion] >= 7.0)
    {
        lableSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    }else
    {
        lableSize = [text sizeWithFont:font];
    }
    return lableSize;
}

+ (CGSize)getMultilineFontSizeByFont:(UIFont *)font text:(NSString *)text maxWidth:(CGFloat)maxWidth
{
    CGSize textSize;
    if (text.length == 0)
    {
        textSize = CGSizeZero;
    } else
    {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        CGSize rectSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                             options:NSStringDrawingTruncatesLastVisibleLine|
                           NSStringDrawingUsesLineFragmentOrigin|
                           NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
        textSize = rectSize;
    }
    return textSize;
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [GPCMediaFilesSelectorUtilityHelper dataWithBase64EncodedString:string];
    if (data)
    {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
#if !__has_feature(objc_arc)
        [result autorelease];
#endif
        
        return result;
    }
    return nil;
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}


// 在特定操作系统版本下执行代码
+ (void)executeInIOS:(SYBIOSVersion)iosVersion withCode:(void(^)(void))codeBlock {
    if ([GPCMediaFilesSelectorUtilityHelper GetCurrentSystemVersion] >= iosVersion) {
        codeBlock();
    }
}

+ (void)showTipsWithMessage:(NSString *)msg
{
    [self showTips:msg inView:[UIApplication sharedApplication].keyWindow];
}

+(void)showTips:(NSString *)message inView:(UIView *)containView
{
    [self showTips:message inView:containView hideDelay:2];
}

+(void)showTips:(NSString *)message inView:(UIView *)containView hideDelay:(CGFloat) delay
{
    [self showTips:message inView:containView hideDelay:2 onFinished:nil];
}

+(void)showTips:(NSString *)message inView:(UIView *)containView hideDelay:(CGFloat) delay  onFinished:(void (^)(void))finishedCallback
{
    if (!containView) {
        return;
    }
    if (CGRectEqualToRect(containView.frame, CGRectZero)) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:containView animated:NO];
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:containView];
        [containView addSubview:progressHud];
        progressHud.removeFromSuperViewOnHide = YES;
        progressHud.userInteractionEnabled = NO;
        progressHud.mode = MBProgressHUDModeText;
        progressHud.animationType = MBProgressHUDAnimationZoomIn;
        progressHud.detailsLabelFont = [UIFont systemFontOfSize:13.0];
        progressHud.layer.cornerRadius = 5.0;
        progressHud.detailsLabelText = message;
        progressHud.completionBlock = finishedCallback;
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0
        //            &&
        //            GPC_SCREEN_HEIGHT < 570
        //            )
        {
            progressHud.yOffset = -50; //为了处理4s  iOS7在某些键盘上 提示被挡住的问题
        }
        [progressHud show:YES];
        [progressHud hide:YES afterDelay:delay];
    });
}
@end
