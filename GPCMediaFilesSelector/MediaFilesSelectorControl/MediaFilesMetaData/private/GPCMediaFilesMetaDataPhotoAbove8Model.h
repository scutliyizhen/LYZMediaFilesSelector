//
//  GPCMediaFilesMetaDataPhotoAbove8Model.h
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Photos/PHFetchResult.h>
#import <Photos/PHAsset.h>
#import "GPCMediaFilesMetaDataPhotoModel.h"

@interface GPCMediaFilesMetaDataPhotoAbove8Model : GPCMediaFilesMetaDataPhotoModel
@property(nonatomic,strong)NSArray<PHAsset*>* fetchPhotoAssets;
@end
