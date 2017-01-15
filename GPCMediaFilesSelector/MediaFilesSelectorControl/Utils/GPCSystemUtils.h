//
//  GPCSystemUtils.h
//  GPCProject
//
//  Created by 李义真 on 2017/1/1.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCSystemUtils : NSObject
+ (double)availableMemory;// 获取当前设备可用内存(单位：MB）
+ (double)usedMemory;// 获取当前任务所占用的内存（单位：MB）
@end
