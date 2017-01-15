//
//  GPCMediaFilesSelectorLocalBelow8PhotoCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import "GPCMediaFilesSelectorLocalPhotoCase.h"

@interface GPCMediaFilesSelectorLocalBelow8PhotoCase : GPCMediaFilesSelectorLocalPhotoCase
//如果从网路下载，该属性有值
@property(nonatomic,strong)NSString* thumbnailImageURL;
@property(nonatomic,strong)NSString* bigImageURL;
//如果从本地加载，下面两个属性有值
@property(nonatomic,strong)ALAsset* asset;
@property(nonatomic,strong)ALAssetsGroup* groupAsset;
@end
