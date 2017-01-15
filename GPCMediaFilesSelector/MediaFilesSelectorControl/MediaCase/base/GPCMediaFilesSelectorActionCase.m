//
//  GPCMediaFilesSelectorActionCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorCaseDataSource.h"
#import "GPCMediaFilesSelectorActionCellView.h"
#import "GPCMediaFilesSelectorBridge.h"

@interface GPCMediaFilesSelectorActionCase()
@property(nonatomic,strong,readwrite)NSString* actionTitle;
@property(nonatomic,strong,readwrite)GPCMediaFilesSelectorActionViewState* viewState;
@end

@implementation GPCMediaFilesSelectorActionCase
+ (GPCMediaFilesSelectorCellView*)createSelectorCaseCellView:(Class)bridgeClass
{
    GPCMediaFilesSelectorActionCellView* actionView = [bridgeClass getMediaFilesActionCellView];
    return actionView;
}

- (void)bindViewClickEvent:(UIView *)sender cellView:(GPCMediaFilesSelectorCellView *)cellView selectorCase:(GPCMediaFilesSelectorCase *)selectorCase
{
    [self.caseDataSource.bridge actionCaseBindViewClickEvent:sender cellView:self.actionCellView actionCase:self];
}

- (instancetype)initWithViewState:(GPCMediaFilesSelectorActionViewState*)viewState
{
    if(self = [super init])
    {
        self.viewState = viewState;
    }
    return self;
}

- (UIImage*)iconImage
{
    return self.viewState.actionICon;
}

- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete
{
	if(complete)
    {
        complete(self.iconImage,NO,self,nil);
    }
}
@end
