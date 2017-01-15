//
//  GPCMediaFilesSelectorAlbumAbove8Case.h
//  GameBible
//
//  Created by robertyzli on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <photos/PHCollection.h>
#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesMetaDataPhotoAbove8Model.h"

@interface GPCMediaFilesSelectorAlbumAbove8Case : GPCMediaFilesSelectorAlbumCase
@property(nonatomic,strong)GPCMediaFilesMetaDataPhotoAbove8Model* metaData;
@property(nonatomic,strong)PHCollection* phCollection;
@end
