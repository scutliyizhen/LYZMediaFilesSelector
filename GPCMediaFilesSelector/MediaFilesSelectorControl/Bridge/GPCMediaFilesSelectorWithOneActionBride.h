//
//  GPCMediaFilesSelectorWithOneActionBride.h
//  GPCProject
//
//  Created by 李义真 on 2016/12/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorBridge.h"

typedef void(^GPCBindViewClickPreviewImageBlock)(UIImage* image);

@interface GPCMediaFilesSelectorWithOneActionBride : GPCMediaFilesSelectorBridge
@property(nonatomic,copy)GPCBindViewClickPreviewImageBlock previewBlock;
@end
