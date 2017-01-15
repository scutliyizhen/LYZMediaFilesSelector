//
//  GPCPhotoSelectorModel.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesSelectorCellView.h"
#import "GPCMediaFilesSelectorPhotoCase.h"

@implementation GPCMediaFilesSelectorCase
+ (GPCMediaFilesSelectorCellView*)createSelectorCaseCellView:(Class)bridgeClass
{
    return [GPCMediaFilesSelectorCellView new];
}

- (instancetype)init
{
    if(self = [super init])
    {
        _objectClass = [self class];
    }
    return self;
}

- (void)bindViewClickEvent:(UIView*)sender
                  cellView:(GPCMediaFilesSelectorCellView*)cellView
              selectorCase:(GPCMediaFilesSelectorCase*)selectorCase
{
    //
}

- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete
{

}

- (Class)getObjectClass
{
    return _objectClass;
}
@end
