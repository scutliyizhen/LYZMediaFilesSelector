//
//  GPCMediaFilesMetaDataPhotoModel.h
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataBaseModel.h"
#import "GPCMediaFilesSelectorLocalPhotoCase.h"

@interface GPCMediaFilesMetaDataPhotoModel :GPCMediaFilesMetaDataBaseModel
@property(nonatomic,strong)NSMutableDictionary<NSNumber*,GPCMediaFilesSelectorLocalPhotoCase*>* caseDic;
@property(nonatomic,strong)NSMutableArray<GPCMediaFilesSelectorLocalPhotoCase*>* displayingCaseList;
@property(nonatomic,strong)NSOperationQueue* operationQueue;

@property(nonatomic,assign)BOOL isReleasingSelectorCase;

- (void)setConfigPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase*)photoCase;
- (void)asynReleaseSelectorCase;
@end
