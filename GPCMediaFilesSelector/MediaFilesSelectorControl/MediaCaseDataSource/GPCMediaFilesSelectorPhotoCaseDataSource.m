//
//  GPCMediaFilesSelectorPhotoCaseDataSource.m
//  GameBible
//
//  Created by robertyzli on 16/7/22.
//  Copyright © 2016� Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorActionCase.h"
#import "GPCMediaFilesSelectorTakingPhotoCase.h"
#import "GPCMediaFilesSelectorBridge.h"

//--�颰�Item
@interface GPCMediaFilesSelectorVideoItem()
@property(nonatomic,strong,readwrite)AVPlayerItem* playerItem;
@property(nonatomic,strong,readwrite)NSDictionary* info;
@property(nonatomic,assign,readwrite)int32_t requestID;
@end

@implementation GPCMediaFilesSelectorVideoItem
- (instancetype)initWith:(int32_t)requestID playerItem:(AVPlayerItem*)playerItem info:(NSDictionary*)info
{
	if(self = [super init])
    {
        self.playerItem = playerItem;
        self.requestID = requestID;
        self.info = info;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"requesionID:%d \n playerItem:%@ \n info:%@ \n",self.requestID,self.playerItem,self.info];
}
@end

//LivePhoto Item
@interface GPCMediaFilesSelectorLivePhotoItem()
@property(nonatomic,strong,readwrite)PHLivePhoto* livePhoto;
@property(nonatomic,strong,readwrite)NSDictionary* info;
@end

@implementation GPCMediaFilesSelectorLivePhotoItem
- (instancetype)initWithLivePhoto:(PHLivePhoto*)livePhoto info:(NSDictionary*)info
{
    if(self = [super init])
    {
        self.livePhoto = livePhoto;
        self.info = info;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"LivePhoto:%@ \n info:%@",self.livePhoto,self.info];
}
@end

#pragma mark--���
@interface GPCMediaFilesSelectorPhotoCaseDataSource()
@property(nonatomic,assign)NSUInteger   maxNumOfPhotoSelected;
@end

@implementation GPCMediaFilesSelectorPhotoCaseDataSource
+ (NSArray<NSString*>*)gridCellIdentifiers
{
    NSMutableArray* tmp = [NSMutableArray new];
    [tmp addObject:NSStringFromClass([GPCMediaFilesSelectorPhotoCase class])];
    [tmp addObject:NSStringFromClass([GPCMediaFilesSelectorActionCase class])];
    return tmp;
}

+ (NSString*)getIdentifierByModel:(GPCMediaFilesSelectorCase *)model
{
    if([model isKindOfClass:[GPCMediaFilesSelectorPhotoCase class]])
    {
        return NSStringFromClass([GPCMediaFilesSelectorPhotoCase class]);
    }
    
    if([model isKindOfClass:[GPCMediaFilesSelectorActionCase class]])
    {
        return NSStringFromClass([GPCMediaFilesSelectorActionCase class]);
    }
    return nil;
}

- (instancetype)initWithMetaDataPhotoModel:(GPCMediaFilesMetaDataBaseModel *)metaDataModel
{
    if(self = [super initWithMetaDataPhotoModel:metaDataModel])
    {
        _photoCaseSelectedList = [NSMutableArray new];
        _takingPhotoList = [NSMutableArray new];
    }
    return self;
}

- (NSArray<GPCMediaFilesSelectorPhotoCase*>*)photoCaseListSelected
{
    return [_photoCaseSelectedList copy];
}

- (NSArray<GPCMediaFilesSelectorPhotoCase*>*)takingPhotoCaseList
{
    return [_takingPhotoList copy];
}

- (NSUInteger)maxNumOfPhotoSelected
{
    return self.bridge.maxNumOfPicturesSeleted;
}

- (void)deletePhotoCaseSelected:(GPCMediaFilesSelectorPhotoCase *)photoCase completed:(DeletePhotoCaseSelectedBlock)complete
{
    __block BOOL flag = NO;
    [_photoCaseSelectedList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([photoCase.photoKey isEqualToString:obj.photoKey])
        {
            flag = YES;
        }
    }];
    
    if(flag)
    {
        [_photoCaseSelectedList removeObject:photoCase];
        if(complete)
        {
            complete(YES,[_photoCaseSelectedList copy]);
        }
    }else
    {
        if(complete)
        {
            complete(NO,[_photoCaseSelectedList copy]);
        }
    }
}

- (void)addPhotoCaseSelected:(GPCMediaFilesSelectorPhotoCase *)photoCase completed:(AddPhotoCaseSelectedBlock)complete
{
    if(self.maxNumOfPhotoSelected <= _photoCaseSelectedList.count)
    {
        if(complete)
        {
            complete(NO,[_photoCaseSelectedList copy]);
        }
    }else
    {
        [_photoCaseSelectedList addObject:photoCase];
        if(complete)
        {
            complete(YES,[_photoCaseSelectedList copy]);
        }
    }

}

#pragma mark--�类��
- (NSUInteger)numberOfPicureModels
{
    return [self.bridge numOfSelectorCaseInPhotoCaseSource:[super numberOfPicureModels] countOfTakingPhotoCase:_takingPhotoList.count];
}

- (GPCMediaFilesSelectorPhotoCase*)getPhotoCaseByIndex:(NSUInteger)index
{
    GPCMediaFilesSelectorPhotoCase* photoCase = (GPCMediaFilesSelectorPhotoCase*)[super getPictureSelectorModelInPictureListByIndex:index];
    photoCase.photoDataSource = self;
    return photoCase;
}

- (GPCMediaFilesSelectorCase*)getPictureSelectorModelInPictureListByIndex:(NSUInteger)index
{
    __weak typeof (self) weakSelf = self;
   return [self.bridge getPictureSelectorCaseByIndex:index photoCaseSource:self photoCaseSourceBlcok:^GPCMediaFilesSelectorPhotoCase *(NSUInteger photoCaseIndex) {
        return [weakSelf getPhotoCaseByIndex:photoCaseIndex];
    }];
}

#pragma mark--请����
- (void)requestPicturesSelectedPreviewImages:(RequstPreiveImageSelectedBlock)complete
{
    NSMutableDictionary* tmpDic = [NSMutableDictionary new];
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    [_photoCaseSelectedList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* key = [NSString stringWithFormat:@"%p",obj];
        
        dispatch_group_enter(serviceGroup);
        [obj requestPreviewImageOperation:^(BOOL finished, UIImage *image,GPCMediaFilesSelectorCase* selectorCase) {
            
            if(key)
            {
                [tmpDic setObject:image forKey:key];
            }
            
            if (finished) {
                dispatch_group_leave(serviceGroup);
            }
        }];
    }];
    
    __weak typeof (_photoCaseSelectedList) weakList = _photoCaseSelectedList;
    RequstPreiveImageSelectedBlock finishBlock = [complete copy];//��block���
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        
        //����覨主线�丧�
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray* tmpBigPicList = [NSMutableArray new];
            
            //�步��大����顺�
            [weakList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString* key = [NSString stringWithFormat:@"%p",obj];
                
                UIImage* image = [tmpDic objectForKey:key];
                
                if(image)
                {
                    [tmpBigPicList addObject:image];
                }
            }];
            
            if(finishBlock)
            {
                finishBlock([tmpBigPicList copy]);
            }
        });
    });
}

#pragma mark--请���
- (void)requestVideoOperation:(RequstVideosSelectedBlock)complete
{
    NSMutableDictionary* tmpDic = [NSMutableDictionary new];
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    [_photoCaseSelectedList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* key = [NSString stringWithFormat:@"%p",obj];
        
        dispatch_group_enter(serviceGroup);
        [obj requestVideoOperation:^(BOOL finished,int32_t requestId, AVPlayerItem *playerItem, NSDictionary *info) {
            GPCMediaFilesSelectorVideoItem* item = [[GPCMediaFilesSelectorVideoItem alloc] initWith:requestId playerItem:playerItem info:info];
            
            if(key)
            {
                [tmpDic setObject:item forKey:key];
            }
            
            if (finished)
            {
                dispatch_group_leave(serviceGroup);
            }
        }];
    }];
    
    __weak typeof (_photoCaseSelectedList) weakList = _photoCaseSelectedList;
    RequstVideosSelectedBlock finishBlock = [complete copy];//��block���
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        
        //����覨主线�丧�
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray* tmpBigPicList = [NSMutableArray new];
            
            //�步����覧��顺�
            [weakList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString* key = [NSString stringWithFormat:@"%p",obj];
                
                GPCMediaFilesSelectorVideoItem* item = [tmpDic objectForKey:key];
                
                if(item)
                {
                    [tmpBigPicList addObject:item];
                }
            }];
            
            if(finishBlock)
            {
                finishBlock([tmpBigPicList copy]);
            }
        });
    });
}

#pragma mark--请�LivePhoto
- (void)requestLivePhotoOperation:(RequestLivePhotosSelectedBlock)complete
{
    NSMutableDictionary* tmpDic = [NSMutableDictionary new];
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    [_photoCaseSelectedList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* key = [NSString stringWithFormat:@"%p",obj];
        
        dispatch_group_enter(serviceGroup);
        [obj requestLivePhoto:^(BOOL finished, PHLivePhoto *livePhoto, NSDictionary *info) {
            GPCMediaFilesSelectorLivePhotoItem* item = [[GPCMediaFilesSelectorLivePhotoItem alloc] initWithLivePhoto:livePhoto info:info];
            if(key)
            {
                [tmpDic setObject:item forKey:key];
            }
            
            if (finished)
            {
                dispatch_group_leave(serviceGroup);
            }
        }];
    }];
    
    __weak typeof (_photoCaseSelectedList) weakList = _photoCaseSelectedList;
    RequestLivePhotosSelectedBlock finishBlock = [complete copy];//��block���
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        
        //����覨主线�丧�
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray* tmpBigPicList = [NSMutableArray new];
            
            //�步����覧��顺�
            [weakList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString* key = [NSString stringWithFormat:@"%p",obj];
                GPCMediaFilesSelectorLivePhotoItem* item = [tmpDic objectForKey:key];
                if(item)
                {
                    [tmpBigPicList addObject:item];
                }
            }];
            
            if(finishBlock)
            {
                finishBlock([tmpBigPicList copy]);
            }
        });
    });
}

#pragma mark--添��
- (BOOL)insertTakingPhotoCaseByIndex:(GPCMediaFilesSelectorPhotoCase *)takingPhotoCase index:(NSUInteger)index
{
    if(takingPhotoCase == nil) return NO;
    if(index > _takingPhotoList.count) return NO;
    
    [_takingPhotoList insertObject:takingPhotoCase atIndex:index];
    return YES;
    
}

- (void)addTakingPhoto:(UIImage *)takingPhoto
{
    if(takingPhoto == nil) return;
    GPCMediaFilesSelectorPhotoViewState* viewSate = [self.bridge getSelectorPhotoCaseViewState:0];
    GPCMediaFilesSelectorTakingPhotoCase* takingPhotoCase = [[GPCMediaFilesSelectorTakingPhotoCase alloc] initWithViewState:viewSate];
    takingPhotoCase.takingImage = takingPhoto;
    takingPhotoCase.photoDataSource = self;
    __weak typeof (self) weakSelf = self;
    [self.bridge addedTakingPhotoIntoCaseSource:takingPhotoCase complete:^(BOOL success) {
        if(success)
        {
            [weakSelf insertTakingPhotoCaseByIndex:takingPhotoCase index:0];
        }
    }];
}
@end









