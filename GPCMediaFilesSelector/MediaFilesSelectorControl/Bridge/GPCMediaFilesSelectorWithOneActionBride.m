//
//  GPCMediaFilesSelectorWithOneActionBride.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorWithOneActionBride.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"

@implementation GPCMediaFilesSelectorWithOneActionBride
- (NSUInteger)numOfSelectorCaseInPhotoCaseSource:(NSUInteger)countOfPhotoCasePhotoLibrary countOfTakingPhotoCase:(NSUInteger)countOfTakingPhotoCase
{
    //拍照+拍摄的照片＋本地相册照片
    return 1 + countOfTakingPhotoCase + countOfPhotoCasePhotoLibrary;
}

- (GPCMediaFilesSelectorCase*)getPictureSelectorCaseByIndex:(NSUInteger)index
                                         photoCaseSource:(GPCMediaFilesSelectorPhotoCaseDataSource*)photoCaseSource
                                    photoCaseSourceBlcok:(GPCPhotoCaseByIndexInPhotoCaseSourceBlcok)photoCaseSourceBlcok
{
    if(index == 0)
    {
        GPCMediaFilesSelectorActionViewState* viewState = [self getSelectorActionCaseViewState:0];
        viewState.actionTitle = @"拍照";
        viewState.actionICon = [UIImage imageNamed:@"gpc_pictureSelector_photo_taking_icon.png"];
        viewState.actionType = ACTION_PICTURE_SELECTOR_TYPE_TAKING_PHOTO;
        
        GPCMediaFilesSelectorActionCase* takingPhotoActionCase = [[GPCMediaFilesSelectorActionCase alloc] initWithViewState:viewState];
        takingPhotoActionCase.caseDataSource = photoCaseSource;
        return takingPhotoActionCase;
    }else
    {
        GPCMediaFilesSelectorPhotoCase* photoCase = nil;
        NSUInteger takingPhotoCount = photoCaseSource.takingPhotoCaseList.count;
        if(takingPhotoCount > 0)//如果有拍摄的照片
        {
            NSUInteger photoIndex = index - 1;//修正照片索引
            if(photoIndex < takingPhotoCount)
            {
                photoCase = photoCaseSource.takingPhotoCaseList[photoIndex];
            }else
            {
                photoIndex = photoIndex - takingPhotoCount;
                photoCase = photoCaseSourceBlcok(photoIndex);
                photoCase.viewState.selectIconHidden = YES;
                photoCase.viewState.numOfSelectedHidden = YES;
                GPCMediaFilesSelectorPhotoCase* tmpCase = photoCase.photoDataSource.currentPrevingPhotoCase;
                if([tmpCase.photoKey isEqualToString:photoCase.photoKey])
                {
                    photoCase = tmpCase;
                }
            }
        }else
        {
            NSUInteger photoIndex = index - 1;//修正照片索引
            photoCase = photoCaseSourceBlcok(photoIndex);
            photoCase.viewState.selectIconHidden = YES;
            photoCase.viewState.numOfSelectedHidden = YES;
            //检查是否该照片被预览
            GPCMediaFilesSelectorPhotoCase* tmpCase = photoCase.photoDataSource.currentPrevingPhotoCase;
            if([tmpCase.photoKey isEqualToString:photoCase.photoKey])
            {
                photoCase = tmpCase;
            }
            
            if(photoIndex == 0 && tmpCase == nil)
            {
                photoCase.viewState.isPreviewIng = YES;
                photoCase.photoDataSource.currentPrevingPhotoCase = photoCase;
                if(self.previewBlock)
                {
                    __weak typeof (self) weakSelf = self;
                    [photoCase requestPreviewImageOperation:^(BOOL finished,UIImage *image,GPCMediaFilesSelectorCase* selectorCase) {
                        weakSelf.previewBlock(image);
                    }];
                }
            }
        }
        return photoCase;
    }
}

- (void)photoCaseBindViewClickEvent:(UIView*)sender
                           cellView:(GPCMediaFilesSelectorPhotoCellView*)cellView
                          photoCase:(GPCMediaFilesSelectorPhotoCase*)photoCase
{
    if([cellView isKindOfClass:[GPCMediaFilesSelectorPhotoCellView class]])
    {
        photoCase.viewState.isPreviewIng = YES;
        [cellView updateSelectorCellState];
        if(photoCase != photoCase.photoDataSource.currentPrevingPhotoCase)
        {
            //之前设置的预览取消
            GPCMediaFilesSelectorPhotoCase* lastPrevingPhotoCase = photoCase.photoDataSource.currentPrevingPhotoCase;
            lastPrevingPhotoCase.viewState.isPreviewIng = NO;
            [lastPrevingPhotoCase.photoCellView updateSelectorCellState];
            
            //设置本次预览
            photoCase.photoDataSource.currentPrevingPhotoCase = photoCase;
        }
        
        if(self.previewBlock)
        {
            __weak typeof (self) weakSelf = self;
            __weak GPCMediaFilesSelectorPhotoCase* weakCase = photoCase;
            [photoCase requestPreviewImageOperation:^(BOOL finished, UIImage *image,GPCMediaFilesSelectorCase* selectorCase) {
                if([weakCase.photoDataSource.currentPrevingPhotoCase isEqual:selectorCase])
                {
                    weakSelf.previewBlock(image);
                }
            }];
        }
    }
}
    
- (void)addedTakingPhotoIntoCaseSource:(GPCMediaFilesSelectorPhotoCase *)photoCase
                              complete:(GPCAddTakingPhotoOperationBlock)complete
{
    //设置预览
    photoCase.viewState.isPreviewIng = YES;
    photoCase.viewState.selectIconHidden = YES;
    photoCase.viewState.numOfSelectedHidden = YES;
    if(photoCase != photoCase.photoDataSource.currentPrevingPhotoCase)
    {
        //之前设置的预览取消
        GPCMediaFilesSelectorPhotoCase* lastPrevingPhotoCase = photoCase.photoDataSource.currentPrevingPhotoCase;
        lastPrevingPhotoCase.viewState.isPreviewIng = NO;
        [lastPrevingPhotoCase.photoCellView updateSelectorCellState];
        
        //设置本次预览
        photoCase.photoDataSource.currentPrevingPhotoCase = photoCase;
    }
    if(self.previewBlock)
    {
        __weak typeof (self) weakSelf = self;
         __weak GPCMediaFilesSelectorPhotoCase* weakCase = photoCase;
        [photoCase.photoDataSource.currentPrevingPhotoCase requestPreviewImageOperation:^(BOOL finished, UIImage *image,GPCMediaFilesSelectorCase* selectorCase) {
            if([weakCase isEqual:selectorCase])
            {
                 weakSelf.previewBlock(image);
            }
        }];
    }
    
    if(complete)
    {
        complete(YES);
    }
}

- (void)actionCaseBindViewClickEvent:(UIView*)sender
                            cellView:(GPCMediaFilesSelectorActionCellView*)cellView
                          actionCase:(GPCMediaFilesSelectorActionCase*)actionCase
{
    if(actionCase.viewState.actionType == ACTION_PICTURE_SELECTOR_TYPE_TAKING_PHOTO)
    {
        if(self.takingPhotoIConClickBlock)
        {
            self.takingPhotoIConClickBlock();
        }
    }
}
@end
