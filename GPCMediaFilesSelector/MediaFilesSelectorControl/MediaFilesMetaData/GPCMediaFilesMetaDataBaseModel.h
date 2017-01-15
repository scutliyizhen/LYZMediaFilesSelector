//
//  GPCMediaFilesMetaDataBaseModel.h
//  GameBible
//
//  Created by robertyzli on 16/7/17.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesSelectorBridge.h"

@interface GPCMediaFilesMetaDataBaseModel : NSObject
@property(nonatomic,strong)GPCMediaFilesSelectorBridge* bridge;
- (NSUInteger)numbersOfPictureModel;
- (GPCMediaFilesSelectorCase*)getPicureModelFromMetaDataByIndex:(NSUInteger)index;
@end
