//
//  GPCMediaFilesMetaDataGalleryBelow8Model.h
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <AssetsLibrary/ALAssetsGroup.h>
#import "GPCMediaFilesMetaDataGalleryModel.h"

@interface GPCMediaFilesMetaDataGalleryBelow8Model : GPCMediaFilesMetaDataGalleryModel
@property(nonatomic,strong)NSArray<ALAssetsGroup*>* galleryGroup;
@property(nonatomic,strong)NSArray<NSArray<ALAsset*>*>* galleryOfAssets;
@property(nonatomic,strong)NSMutableDictionary<NSString*,ALAssetsGroup*>* galleryGroupDic;
@end
