//
//  GPCMediaFilesSelectorWithTwoActionBridge.m
//  GPCProject
//
//  Created by 李义真 on 2016/12/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorWithTwoActionBridge.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorUtilityHelper.h"
#import "GPCMediaFilesSelectorPhotoCase.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"

@implementation GPCMediaFilesSelectorWithTwoActionBridge
- (NSUInteger)numOfSelectorCaseInPhotoCaseSource:(NSUInteger)countOfPhotoCasePhotoLibrary countOfTakingPhotoCase:(NSUInteger)countOfTakingPhotoCase
{
    //拍照+相册+拍摄的照片＋本地相册照片
    return 1 + 1 + countOfTakingPhotoCase + countOfPhotoCasePhotoLibrary;
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
        
        GPCMediaFilesSelectorActionCase* albumActionCase = [[GPCMediaFilesSelectorActionCase alloc] initWithViewState:viewState];
        albumActionCase.caseDataSource = photoCaseSource;
        return albumActionCase;
    }else if (index == 1)
    {
        GPCMediaFilesSelectorActionViewState* viewState = [self getSelectorActionCaseViewState:1];
        viewState.actionTitle = @"相册";
        viewState.actionICon = [UIImage imageNamed:@"gpc_pictureSelector_photo_album_icon.png"];
        viewState.actionType = ACTION_PICTURE_SELECTOR_TYPE_GALLERY;
        
        GPCMediaFilesSelectorActionCase* takingPhotoCase = [[GPCMediaFilesSelectorActionCase alloc] initWithViewState:viewState];
        takingPhotoCase.caseDataSource = photoCaseSource;
     
        return takingPhotoCase;
      
    }else
    {
        GPCMediaFilesSelectorPhotoCase* photoCase = nil;
        NSUInteger takingPhotoCount = photoCaseSource.takingPhotoCaseList.count;
        if(takingPhotoCount > 0)//如果有拍摄的照片
        {
            NSUInteger photoIndex = index - 1 - 1;//修正照片索引
            if(photoIndex < takingPhotoCount)
            {
                photoCase = photoCaseSource.takingPhotoCaseList[photoIndex];
            }else
            {
                photoIndex = photoIndex - takingPhotoCount;
                photoCase = photoCaseSourceBlcok(photoIndex);
                GPCMediaFilesSelectorPhotoCase* tmpCase = [self photoCaseExsitsInSelectedList:photoCaseSource.photoCaseListSelected photoCase:photoCase];
                if(tmpCase)
                {
                    photoCase = tmpCase;
                }
            }
        }else
        {
            NSUInteger photoIndex = index - 1 - 1;//修正照片索引
            photoCase = photoCaseSourceBlcok(photoIndex);
            GPCMediaFilesSelectorPhotoCase* tmpCase = [self photoCaseExsitsInSelectedList:photoCaseSource.photoCaseListSelected photoCase:photoCase];
            if(tmpCase)
            {
                photoCase = tmpCase;
            }
        }
        return photoCase;
    }
}

- (void)addedTakingPhotoIntoCaseSource:(GPCMediaFilesSelectorPhotoCase *)photoCase complete:(GPCAddTakingPhotoOperationBlock)complete
{
    [photoCase.photoDataSource addPhotoCaseSelected:photoCase completed:^(BOOL success, NSArray<GPCMediaFilesSelectorPhotoCase *> *photoCaseListSelected) {
        if(success)
        {
            //通知外面选中的数量发生变化
            [[NSNotificationCenter defaultCenter] postNotificationName:picSelectedNumNotification object:nil userInfo:@{selectedNumUpdateKey:@(photoCaseListSelected.count)}];
            //设置选中状态
            photoCase.viewState.isSelected = YES;
             photoCase.viewState.numOfSelectedHidden = NO;
            photoCase.viewState.indexOfSelected = photoCaseListSelected.count;
            //设置预览
            photoCase.viewState.isPreviewIng = YES;
            if(photoCase != photoCase.photoDataSource.currentPrevingPhotoCase)
            {
                //之前设置的预览取消
                GPCMediaFilesSelectorPhotoCase* lastPrevingPhotoCase = photoCase.photoDataSource.currentPrevingPhotoCase;
                lastPrevingPhotoCase.viewState.isPreviewIng = NO;
                [lastPrevingPhotoCase.photoCellView updateSelectorCellState];
                
                //设置本次预览
                photoCase.photoDataSource.currentPrevingPhotoCase = photoCase;
            }
            
            if(complete)
            {
                complete(YES);
            }
        }else
        {
            NSUInteger maxNumSelected = self.maxNumOfPicturesSeleted;
            [GPCMediaFilesSelectorUtilityHelper showTipsWithMessage:[NSString stringWithFormat:@"最多只能选%lu张图片",(unsigned long)maxNumSelected]];
            
            if(complete)
            {
                complete(NO);
            }
        }
    }];
}

- (GPCMediaFilesSelectorPhotoCase*)photoCaseExsitsInSelectedList:(NSArray<GPCMediaFilesSelectorPhotoCase*>*)photoListSelected
                                                    photoCase:(GPCMediaFilesSelectorPhotoCase*)photoCase
{
    __block GPCMediaFilesSelectorPhotoCase* tmpCase;
    [photoListSelected enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([photoCase.photoKey isEqualToString:obj.photoKey])
        {
            tmpCase = obj;
        }
    }];
    return tmpCase;
}

- (void)actionCaseBindViewClickEvent:(UIView*)sender
                            cellView:(GPCMediaFilesSelectorActionCellView*)cellView
                          actionCase:(GPCMediaFilesSelectorActionCase*)actionCase
{
    if(actionCase.viewState.actionType == ACTION_PICTURE_SELECTOR_TYPE_GALLERY)
    {
        if(self.galleryIconClickBlock)
        {
            self.galleryIconClickBlock();
        }
    }
    
    if(actionCase.viewState.actionType == ACTION_PICTURE_SELECTOR_TYPE_TAKING_PHOTO)
    {
        if([actionCase.caseDataSource isKindOfClass:[GPCMediaFilesSelectorPhotoCaseDataSource class]])
        {
            GPCMediaFilesSelectorPhotoCaseDataSource* photoCaseSource = (GPCMediaFilesSelectorPhotoCaseDataSource*)actionCase.caseDataSource;
            if(photoCaseSource.photoCaseListSelected.count >= self.maxNumOfPicturesSeleted)
            {
                NSUInteger maxNumSelected = self.maxNumOfPicturesSeleted;
                [GPCMediaFilesSelectorUtilityHelper showTipsWithMessage:[NSString stringWithFormat:@"最多只能选%lu张图片",(unsigned long)maxNumSelected]];
            }else
            {
                if(self.takingPhotoIConClickBlock)
                {
                    self.takingPhotoIConClickBlock();
                }
            }
        }else
        {
            if(self.takingPhotoIConClickBlock)
            {
                self.takingPhotoIConClickBlock();
            }
        }
    }
}
@end
