//
//  GPCPictureNetMetaDataPhotoBelow8Model.h
//  GPCProject
//
//  Created by robertyzli on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataPhotoBelow8Model.h"

@interface GPCPictureNetMetaDataPhotoBelow8Model : GPCMediaFilesMetaDataPhotoBelow8Model
@property(nonatomic,strong)NSArray<NSString*>* bigImageURLs;
@property(nonatomic,strong)NSArray<NSString*>* thumbnailImageURLs;
@end
