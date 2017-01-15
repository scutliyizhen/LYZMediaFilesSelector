//
//  GPCMediaFilesSelectorActionCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCase.h"
#import "GPCMediaFilesSelectorActionViewState.h"

@class GPCMediaFilesSelectorActionCellView;
@class GPCMediaFilesSelectorCaseDataSource;

typedef NS_ENUM(NSUInteger,PICTURE_SELECTOR_TYPE)
{
    PICTURE_SELECTOR_TYPE_GALLERY,
    PICTURE_SELECTOR_TYPE_TAKING_PHOTO,
};

typedef void(^ActionViewClickBlock)();

@interface GPCMediaFilesSelectorActionCase : GPCMediaFilesSelectorCase

@property(nonatomic,strong,readonly)GPCMediaFilesSelectorActionViewState* viewState;
@property(nonatomic,strong,readonly)NSString* actionTitle;

@property(nonatomic,weak)GPCMediaFilesSelectorCaseDataSource* caseDataSource;
@property(nonatomic,weak)GPCMediaFilesSelectorActionCellView*  actionCellView;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithViewState:(GPCMediaFilesSelectorActionViewState*)viewState;
@end



