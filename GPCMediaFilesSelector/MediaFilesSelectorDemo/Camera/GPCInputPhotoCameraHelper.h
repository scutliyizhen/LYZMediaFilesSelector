//
//  GPCInputPhotoCameraHelper.h
//  SybPlatform
//
//  Created by robertyzli on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^TakingPhotoFinishedBlock)(BOOL finished,UIImage* photo);

@interface GPCInputPhotoCameraHelper : NSObject
@property(nonatomic,copy)TakingPhotoFinishedBlock takingPhotoBlock;
+ (instancetype)shareInstance;
- (void)showPhotoCameraViewController:(UIViewController*)currentViewController;
@end
