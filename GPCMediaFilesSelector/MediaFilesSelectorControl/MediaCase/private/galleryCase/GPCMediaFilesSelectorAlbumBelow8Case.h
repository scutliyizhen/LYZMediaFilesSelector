//
//  GPCMediaFilesSelectorAlbumBelow8Case.h
//  GameBible
//
//  Created by robertyzli on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <AssetsLibrary/ALAssetsGroup.h>
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesMetaDataPhotoBelow8Model.h"

@interface GPCMediaFilesSelectorAlbumBelow8Case : GPCMediaFilesSelectorAlbumCase
@property(nonatomic,strong)GPCMediaFilesMetaDataPhotoBelow8Model* metaData;
@property(nonatomic,strong)ALAssetsGroup* groupAsset;
@end
