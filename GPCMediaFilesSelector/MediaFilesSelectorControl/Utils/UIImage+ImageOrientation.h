//
//  UIImage+ImageOrientation.h
//  SybPlatform
//
//  Created by robertyzli on 15/6/25.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface UIImage(ImageOrientation)
- (UIImage *)fixOrientation;
@end
