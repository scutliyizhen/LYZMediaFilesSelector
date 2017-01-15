//
//  GPCMediaFilesMetaDataPhotoBelow8Model.h
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import "GPCMediaFilesMetaDataPhotoModel.h"

@interface GPCMediaFilesMetaDataPhotoBelow8Model : GPCMediaFilesMetaDataPhotoModel
@property(nonatomic,strong)NSArray<ALAsset*>* fetchAssets;
@property(nonatomic,strong)NSDictionary<NSString*,ALAssetsGroup*>* groupAssets;
@end
