
//
//  GPCMediaFilesSelectorLocalPhotoCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorLocalPhotoCase.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"
#import <libkern/OSAtomic.h>



#import "GPCMediaFilesSelectorLocalAbove8PhotoCase.h"

typedef void(^SelectorCaseBlock)();

@implementation GPCLocalPhotoCaseDataModel
@end

@interface GPCMediaFilesSelectorLocalPhotoCase()
@property(nonatomic,strong)UIImage* fastImage;//滚动时缩略图scale=1.0
@property(nonatomic,strong)UIImage* fastImageAsyn;//快速滚动时，跟随scale变化的缩略图

@property(nonatomic,strong)UIImage* opportunisticImage;
@property(nonatomic,strong)UIImage* opportunisticImageAsyn;

@property(nonatomic,strong)NSMutableDictionary* photoCaseInfo;

@property(nonatomic,strong)NSBlockOperation* updateOPeration;
@property(nonatomic,copy)RequestUpdateIConImageInfoBlock updateIConImageBlock;

@property(nonatomic,assign,readwrite)NSUInteger exposureCount;
@property(nonatomic,assign,readwrite)BOOL isDisplayOnScreen;
@property(nonatomic,assign)BOOL willExposureStaying;
@property(nonatomic,assign)NSTimeInterval stayingStart;

@property(nonatomic,assign)BOOL isStartAsynRequesImage;
@end

@implementation GPCMediaFilesSelectorLocalPhotoCase
#pragma mark--曝光与停留在屏幕，以下三个操作在主线程中
- (void)startExposureOperation
{
    OSSpinLock exposureSpinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&exposureSpinLock);
    self.exposureCount ++;
    OSSpinLockUnlock(&exposureSpinLock);
    
    OSSpinLock displaySpinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&displaySpinLock);
    self.isDisplayOnScreen = YES;
    OSSpinLockUnlock(&displaySpinLock);
    
    if(self.addedCaseOnDisplayingBlock)
    {
        self.addedCaseOnDisplayingBlock(self);
    }
}

- (void)endExposureOperaion
{
    OSSpinLock displaySpinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&displaySpinLock);
    self.isDisplayOnScreen = NO;
    OSSpinLockUnlock(&displaySpinLock);
    
    //计算停留在屏幕到消失在屏幕的权值
    if(self.willExposureStaying == YES)
    {
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval deltaTime = nowTime - self.stayingStart;
        
        int32_t weight = ((int)deltaTime / 5);
        
        if(weight < 1)
        {
            weight = 3;
        }
        
        weight -= 1;
        
        NSInteger exposureCount = 0;
        OSSpinLock stayingSpinLock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&stayingSpinLock);
        self.exposureCount += weight;
        exposureCount = self.exposureCount;
        OSSpinLockUnlock(&stayingSpinLock);
        
        if(exposureCount > 0)
        {
            if(self.addedCaseOnDisplayingBlock)
            {
                self.addedCaseOnDisplayingBlock(self);
            }
        }
        if(exposureCount < 0)
        {
            if(self.deletedCaseOnDisplayingBlock)
            {
                self.deletedCaseOnDisplayingBlock(self);
            }
        }
        self.willExposureStaying = NO;
        self.stayingStart = [[NSDate date] timeIntervalSince1970];
    }else
    {
        NSInteger exposureCount = 0;
        OSSpinLock exposureSpinLock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&exposureSpinLock);
        self.exposureCount --;
        exposureCount = self.exposureCount;
        OSSpinLockUnlock(&exposureSpinLock);
        
        if(self.deletedCaseOnDisplayingBlock)
        {
            if(exposureCount < 1)
            {
                self.deletedCaseOnDisplayingBlock(self);
            }
        }
    }
}

- (void)stayingOnScreenOperation
{
    self.willExposureStaying = YES;
    self.stayingStart = [[NSDate date] timeIntervalSince1970];
    
    OSSpinLock displaySpinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&displaySpinLock);
    self.isDisplayOnScreen = YES;
    OSSpinLockUnlock(&displaySpinLock);
}

#pragma mark--将异步添加到队列
- (void)addOperation:(NSBlockOperation*)operation
{
    if(self.addedOperationBlock)
    {
        self.addedOperationBlock(operation);
    }
}

- (NSBlockOperation*)getFastUpdateBlockOperation:(CGFloat)thumbnailImageScale
                                    deliveryMode:(PhotoCaseRequestOptionDeliveryMode)deliveryMode
{
    
    self.isStartAsynRequesImage = YES;
    NSBlockOperation* operation = [[NSBlockOperation alloc] init];
    __weak typeof (self) weakSelf = self;
    [operation addExecutionBlock:^{
        
        GPCRequestImageOption* requestOption = [GPCRequestImageOption new];
        requestOption.thumbnailImageSizeScale = thumbnailImageScale;
        requestOption.isAsynchronous = YES;
        
        if(deliveryMode == PhotoCaseRequestOptionDeliveryModeFastMode)
        {
            requestOption.deliveryMode = RequestImageDeliveryMode_Fast;
        }else
        {
            requestOption.deliveryMode = RequestImageDeliveryMode_Opportunistic;
        }
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:weakSelf requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
                 if(dataModel)
                 {
                     //NSDictionary* info = [weakSelf getPhotoInfo];
//                     if (dataModel.imageType == LocalPhotoImageType_Opportunistic)
//                     {
//                         OSSpinLock spinLock = OS_SPINLOCK_INIT;
//                         OSSpinLockLock(&spinLock);
//                         weakSelf.opportunisticImage = dataModel.image;
//                         OSSpinLockUnlock(&spinLock);
//                     }
                     BOOL isFastImage = NO;
                     if(dataModel.imageType == LocalPhotoImageType_Opportunistic_Asyn)
                     {
                         isFastImage = NO;
                     }
                     
//                     if(dataModel.imageType == LocalPhotoImageType_Fast)
//                     {
//                         OSSpinLock spinLock = OS_SPINLOCK_INIT;
//                         OSSpinLockLock(&spinLock);
//                         weakSelf.fastImage = dataModel.image;
//                         OSSpinLockUnlock(&spinLock);
//                     }
                     
                     if(dataModel.imageType == LocalPhotoImageType_Fast_Asyn)
                     {
                          isFastImage = YES;
                     }
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         weakSelf.isStartAsynRequesImage = NO;
                         
                         if(weakSelf.updateIConImageBlock)
                         {
                             weakSelf.updateIConImageBlock(dataModel.image,isFastImage,weakSelf,nil);
                         }
                     });
                     
                     if(dataModel.imageType == LocalPhotoImageType_Opportunistic_Asyn)
                     {
                         OSSpinLock spinLock = OS_SPINLOCK_INIT;
                         OSSpinLockLock(&spinLock);
                         weakSelf.opportunisticImageAsyn = dataModel.image;
                         OSSpinLockUnlock(&spinLock);
                     }
                     
                     if(dataModel.imageType == LocalPhotoImageType_Fast_Asyn)
                     {
                         if(dataModel.thumbnailImageSizeScale >= 0.6)
                         {
                             OSSpinLock spinLock = OS_SPINLOCK_INIT;
                             OSSpinLockLock(&spinLock);
                             weakSelf.fastImageAsyn = dataModel.image;
                             OSSpinLockUnlock(&spinLock);
                         }
                     }
                 }
             }];
        }];
    return operation;
}

- (BOOL)operationCanAddedInQueue:(NSBlockOperation*)operation
{
    if(operation == nil) return NO;
    
    BOOL isExisted = NO;
    
    if(self.searchOperationBlock)
    {
        isExisted = self.searchOperationBlock(operation);
    }else
    {
        return NO;
    }
    
    if(isExisted)
    {
        return NO;
    }else
    {
        if(operation.isFinished == YES || operation.isCancelled == YES)
        {
            return NO;
        }else
        {
            return YES;
        }
    }
}

#pragma mark--照片信息
- (UIImage*)iconImage
{
    if(self.opportunisticImage)
    {
        return self.opportunisticImage;
    }else
    {
        OSSpinLock opportunisticSpinLock = OS_SPINLOCK_INIT;
        UIImage* opportunisticAsynImage = nil;
        OSSpinLockLock(&opportunisticSpinLock);
        opportunisticAsynImage = self.opportunisticImageAsyn;
        OSSpinLockUnlock(&opportunisticSpinLock);
        if(opportunisticAsynImage)
        {
            return opportunisticAsynImage;
        }else
        {
            if(self.fastImage)
            {
                return self.fastImage;
            }else
            {
                OSSpinLock fastAsynSpinLock = OS_SPINLOCK_INIT;
                UIImage* fastAsynImage = nil;
                OSSpinLockLock(&fastAsynSpinLock);
                fastAsynImage = self.fastImageAsyn;
                OSSpinLockUnlock(&fastAsynSpinLock);
                
                if(fastAsynImage)
                {
                    return fastAsynImage;
                }else
                {
                    return [super iconImage];
                }
            }
        }
    }
}

- (NSMutableDictionary*)photoCaseInfo
{
    @synchronized (_photoCaseInfo) {
        if(_photoCaseInfo == nil)
        {
            _photoCaseInfo = [NSMutableDictionary new];
        }
        return _photoCaseInfo;
    }
}

- (NSDictionary*)getPhotoInfo
{
    if(self.options.requestCreateTime)
    {
        NSDate* createDate = [self.photoCaseInfo objectForKey:@"createdate"];
        if(createDate == nil)
        {
            createDate = self.createDate;
            if(createDate)
            {
                [self.photoCaseInfo setObject:self.createDate forKey:@"createdate"];
            }
        }
    }
    
    if(self.options.requestGalleryTitle)
    {
        NSString* galleryTitle = [self.photoCaseInfo objectForKey:@"galleryname"];
        if(galleryTitle == nil)
        {
            galleryTitle = self.galleryTitle;
            if(galleryTitle)
            {
                [self.photoCaseInfo setObject:galleryTitle forKey:@"galleryname"];
            }
        }
    }
    
    if(self.options.requestPhotoName)
    {
        NSString* photoName = [self.photoCaseInfo objectForKey:@"filename"];
        if(photoName == nil)
        {
            photoName = self.photoTitle;
            if(photoName)
            {
                [self.photoCaseInfo setObject:photoName forKey:@"filename"];
            }
        }
    }
    
    if(self.photoCaseInfo.count == 0)
    {
        return nil;
    }else
    {
        return [self.photoCaseInfo copy];
    }
}

- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete
{
    self.updateIConImageBlock = complete;
    if(self.options.isAsynchronous)
    {
        UIImage* opportunisticAsynImage = nil;
       
        OSSpinLock opportunisticAsynSpinLock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&opportunisticAsynSpinLock);
        opportunisticAsynImage = self.opportunisticImageAsyn;
        OSSpinLockUnlock(&opportunisticAsynSpinLock);
        
        if(self.opportunisticImage == nil && self.fastImage == nil && opportunisticAsynImage == nil)
        {
            if(self.updateOPeration == nil)
            {
                self.updateOPeration = [self getFastUpdateBlockOperation:self.options.thumbnailImageScale deliveryMode:self.options.deliveryMode];
                [self addOperation:self.updateOPeration];
            }else
            {
                if(self.isStartAsynRequesImage == NO)
                {
                    self.updateOPeration = [self getFastUpdateBlockOperation:self.options.thumbnailImageScale deliveryMode:self.options.deliveryMode];
                    [self addOperation:self.updateOPeration];
                }
//                else
//                {
//                    [self addOperation:self.updateOPeration];
//                }
            }
        }else
        {
            if(complete)
            {
                complete(self.iconImage,NO,self,[self.photoCaseInfo copy]);
            }
        }
    }else
    {
        __weak typeof (self) weakSelf = self;
        if(self.options.deliveryMode == PhotoCaseRequestOptionDeliveryModeFastMode)
        {
            if(self.fastImage == nil)
            {
                GPCRequestImageOption* requestOption = [GPCRequestImageOption new];
                requestOption.thumbnailImageSizeScale = self.options.thumbnailImageScale;
                requestOption.isAsynchronous = NO;
                requestOption.deliveryMode = RequestImageDeliveryMode_Fast;
                
                if(self.options.isSpecialRunloopMode == YES)
                {
//                    NSMutableDictionary* dic = [NSMutableDictionary new];
//                    [dic setObject:@(PhotoCaseRequestOptionDeliveryModeFastMode) forKey:@"deliveryMode"];
//                    [dic setObject:requestOption forKey:@"questionOption"];
//                    if(complete)
//                    {
//                        [dic setObject:complete forKey:@"complete"];
//                    }
//                    
//                    [self performSelector:@selector(requestUpdateMainThread:) withObject:dic afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:self requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
                            if(dataModel)
                            {
                                NSDictionary* info = [weakSelf getPhotoInfo];
                                weakSelf.fastImage = dataModel.image;
                                if(complete)
                                {
                                    complete(dataModel.image,YES,weakSelf,info);
                                }
                            }
                        }];

                    });
                }else
                {
                    [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:self requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
                        if(dataModel)
                        {
                            NSDictionary* info = [weakSelf getPhotoInfo];
                            weakSelf.fastImage = dataModel.image;
                            if(complete)
                            {
                                complete(dataModel.image,YES,weakSelf,info);
                            }
                        }
                    }];
                }
            }else
            {
                if(complete)
                {
                    complete(self.fastImage,YES,self,[self.photoCaseInfo copy]);
                }
            }
        }else
        {
            if(self.opportunisticImage == nil)
            {
                GPCRequestImageOption* requestOption = [GPCRequestImageOption new];
                requestOption.thumbnailImageSizeScale = self.options.thumbnailImageScale;
                requestOption.isAsynchronous = NO;
                requestOption.deliveryMode = RequestImageDeliveryMode_Opportunistic;
                
                if(self.options.isSpecialRunloopMode == YES)
                {
//                    NSMutableDictionary* dic = [NSMutableDictionary new];
//                    [dic setObject:@(PhotoCaseRequestOptionDeliveryModeOpportunisticMode) forKey:@"deliveryMode"];
//                    [dic setObject:requestOption forKey:@"questionOption"];
//                    if(complete)
//                    {
//                        [dic setObject:complete forKey:@"complete"];
//                    }
//                    
//                    [self performSelector:@selector(requestUpdateMainThread:) withObject:dic afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:self requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
                            NSDictionary* info = [weakSelf getPhotoInfo];
                            weakSelf.opportunisticImage = dataModel.image;
                            if(complete)
                            {
                                complete(dataModel.image,NO,weakSelf,info);
                            }
                        }];

                    });
                }else
                {
                    [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:self requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
                        NSDictionary* info = [weakSelf getPhotoInfo];
                        weakSelf.opportunisticImage = dataModel.image;
                        if(complete)
                        {
                            complete(dataModel.image,NO,weakSelf,info);
                        }
                    }];
                }
            }else
            {
                if(complete)
                {
                    complete(self.opportunisticImage,NO,self,[self.photoCaseInfo copy]);
                }
            }
        }
    }
}

- (void)requestUpdateMainThread:(NSDictionary*)dicInfo
{
    PhotoCaseRequestOptionDeliveryMode deliveryMode = [[dicInfo objectForKey:@"deliveryMode"] intValue];
    GPCRequestImageOption* requestOption = [dicInfo objectForKey:@"questionOption"];
    RequestUpdateIConImageInfoBlock complete = [dicInfo objectForKey:@"complete"];
    __weak typeof (self) weakSelf = self;
    if(deliveryMode == PhotoCaseRequestOptionDeliveryModeOpportunisticMode)
    {
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:self requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
            NSDictionary* info = [weakSelf getPhotoInfo];
            weakSelf.opportunisticImage = dataModel.image;
            if(complete)
            {
                complete(dataModel.image,NO,weakSelf,info);
            }
        }];
    }
    
    if(deliveryMode == PhotoCaseRequestOptionDeliveryModeFastMode)
    {
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestThumbnailImage:requestOption selectorCase:self requestBlock:^(GPCMediaFilesSelectorLocalPhotoCase *selectorCase, GPCLocalPhotoCaseDataModel *dataModel) {
            if(dataModel)
            {
                NSDictionary* info = [weakSelf getPhotoInfo];
                weakSelf.fastImage = dataModel.image;
                if(complete)
                {
                    complete(dataModel.image,YES,weakSelf,info);
                }
            }
        }];
    }
}

- (void)requestPreviewImageOperation:(RequestPreviewImageBlock)requestBlok
{
    CGSize sizeFor6Plus = CGSizeMake(414, 736);//逻辑尺寸
    [[GPCMediaFilesSelectorFrameworkManager shareInstance] startCachingPreviewImage:sizeFor6Plus
                                                                      photoModel:self];
    __weak typeof (self) weakSelf = self;
    [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestPreviewImage:sizeFor6Plus photoModel:self requestBlock:^(BOOL finished, UIImage *previewImage, GPCMediaFilesSelectorLocalPhotoCase *photoModel) {
        if(weakSelf == photoModel)
        {
            if(requestBlok)
            {
                requestBlok(finished,previewImage,weakSelf);
            }
        }
    }];
}

- (void)requestVideoOperation:(RequestVideoBlock)requestBlock
{
    [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestVideoWithLocalPhotoCase:self complete:requestBlock];
}
@end
