//
//  GPCMediaFilesMetaDataPhotoAbove8Model.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright Â© 2016å¹ Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataPhotoAbove8Model.h"
#import "GPCMediaFilesSelectorLocalAbove8PhotoCase.h"
#import "GPCSystemUtils.h"

@interface GPCMediaFilesMetaDataPhotoAbove8Model()
@end

@implementation GPCMediaFilesMetaDataPhotoAbove8Model

- (NSUInteger)numbersOfPictureModel
{
    return self.fetchPhotoAssets.count;
}

- (GPCMediaFilesSelectorCase*)getPicureModelFromMetaDataByIndex:(NSUInteger)index
{
    GPCMediaFilesSelectorLocalPhotoCase* selectorCase = [self.caseDic objectForKey:@(index)];
    if((selectorCase != nil) && (![selectorCase isKindOfClass:[GPCMediaFilesSelectorLocalAbove8PhotoCase class]]))
    {
        return nil;
    }
    GPCMediaFilesSelectorLocalAbove8PhotoCase* model = (GPCMediaFilesSelectorLocalAbove8PhotoCase*)selectorCase;
    if(model == nil)
    {
        GPCMediaFilesSelectorPhotoViewState* viewState = [self.bridge getSelectorPhotoCaseViewState:index];
        model = [[GPCMediaFilesSelectorLocalAbove8PhotoCase alloc] initWithViewState:viewState];
        model.asset = self.fetchPhotoAssets[index];
        model.index = index;
        [self setConfigPhotoCase:model];
    }
    [self asynReleaseSelectorCase];
    return model;
}
@end
