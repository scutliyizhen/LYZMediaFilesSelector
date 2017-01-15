//
//  GPCMediaFilesMetaDataPhotoBelow8Model.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataPhotoBelow8Model.h"
#import "GPCMediaFilesSelectorLocalBelow8PhotoCase.h"

@implementation GPCMediaFilesMetaDataPhotoBelow8Model
- (NSUInteger)numbersOfPictureModel
{
    return self.fetchAssets.count;
}

- (GPCMediaFilesSelectorCase*)getPicureModelFromMetaDataByIndex:(NSUInteger)index
{
    GPCMediaFilesSelectorLocalPhotoCase* selectorCase = [self.caseDic objectForKey:@(index)];
    if((selectorCase != nil) && (![selectorCase isKindOfClass:[GPCMediaFilesSelectorLocalBelow8PhotoCase class]]))
    {
        return nil;
    }
    GPCMediaFilesSelectorLocalBelow8PhotoCase* model = (GPCMediaFilesSelectorLocalBelow8PhotoCase*)selectorCase;
    if(model == nil)
    {
        GPCMediaFilesSelectorPhotoViewState* viewState = [self.bridge getSelectorPhotoCaseViewState:index];
        model = [[GPCMediaFilesSelectorLocalBelow8PhotoCase alloc] initWithViewState:viewState];
        model.asset = self.fetchAssets[index];
        model.groupAsset = self.groupAssets[[NSString stringWithFormat:@"%p",model.asset]];
        model.index = index;
        [self setConfigPhotoCase:model];
    }
    [self asynReleaseSelectorCase];
    return model;
}
@end
