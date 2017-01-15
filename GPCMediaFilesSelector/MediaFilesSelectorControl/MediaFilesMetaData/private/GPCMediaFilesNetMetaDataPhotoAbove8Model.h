//
//  GPCPictureNetMetaDataPhotoAbove8Model.h
//  GPCProject
//
//  Created by robertyzli on 2016/12/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataPhotoAbove8Model.h"

@interface GPCPictureNetMetaDataPhotoAbove8Model : GPCMediaFilesMetaDataPhotoAbove8Model
@property(nonatomic,strong)NSArray<NSString*>* bigImageURLs;
@property(nonatomic,strong)NSArray<NSString*>* thumbnailImageURLs;
@end
