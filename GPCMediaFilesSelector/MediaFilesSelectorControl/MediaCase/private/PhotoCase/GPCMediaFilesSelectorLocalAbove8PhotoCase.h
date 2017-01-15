//
//  GPCMediaFilesSelectorLocalAbove8PhotoCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Photos/PHAsset.h>
#import "GPCMediaFilesSelectorLocalPhotoCase.h"

@interface GPCMediaFilesSelectorLocalAbove8PhotoCase : GPCMediaFilesSelectorLocalPhotoCase
//如果从网路下载，该属性有值
@property(nonatomic,strong)NSString* thumbnailImageURL;
@property(nonatomic,strong)NSString* bigImageURL;
//如果从本地加载，该属性有值
@property(nonatomic,strong)PHAsset* asset;
@end
