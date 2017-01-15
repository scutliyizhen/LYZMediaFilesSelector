//
//  GPCMediaFilesMetaDataGalleryAbove8Model.h
//  GameBible
//
//  Created by robertyzli on 16/7/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataGalleryModel.h"
#import <Photos/PHFetchResult.h>
#import <photos/PHCollection.h>
#import <Photos/PHAsset.h>

@interface GPCMediaFilesMetaDataGalleryAbove8Model : GPCMediaFilesMetaDataGalleryModel
@property(nonatomic,strong)NSArray<PHCollection*>* galleryConllections;
@property(nonatomic,strong)NSArray<NSArray<PHAsset*>*>* galleryFetchAssets;
@end
