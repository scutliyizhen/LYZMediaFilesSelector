//
//  GPCMediaFilesSelectorPhotoCaseDataSource.h
//  GameBible
//
//  Created by robertyzli on 16/7/22.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCaseDataSource.h"
#import "GPCMediaFilesSelectorPhotoCase.h"

/**
 *  1.选中的照片数目更新通知，
 *  2.框架通知外面使用者选中数目的更新，由于事件触发的地方与外界层级比较远，降低耦合所以才用通知
 *  3. key:selectedNumUpdateKey   value:NSNumber
 */
static NSString*  selectedNumUpdateKey = @"selectedNumUpdateKey";
static NSString*  picSelectedNumNotification = @"__LYZPicSelectorSeletedNumUpdateNotification__";

//视频
@interface GPCMediaFilesSelectorVideoItem :NSObject
@property(nonatomic,strong,readonly)AVPlayerItem* playerItem;
@property(nonatomic,strong,readonly)NSDictionary* info;//底层框架返回的info，一般对于上层用处不大
@property(nonatomic,assign,readonly)int32_t requestID;//ios8以下该值不起作用，默认为0
- (instancetype)init NS_UNAVAILABLE;
@end

//LivePhoto(IOS9 以后)
PHOTOS_CLASS_AVAILABLE_IOS_TVOS(9_1, 10_0) @interface GPCMediaFilesSelectorLivePhotoItem:NSObject
@property(nonatomic,strong,readonly)PHLivePhoto* livePhoto;
@property(nonatomic,strong,readonly)NSDictionary* info;//底层框架返回的info，一般对于上层用处不大
- (instancetype)init NS_UNAVAILABLE;
@end


typedef void(^RequstVideosSelectedBlock)(NSArray<GPCMediaFilesSelectorVideoItem*>* videoList);
typedef void(^RequstPreiveImageSelectedBlock)(NSArray<UIImage*>* imageList);
typedef void(^RequestLivePhotosSelectedBlock)(NSArray<GPCMediaFilesSelectorLivePhotoItem*>* livePhotoList);

typedef void(^DeletePhotoCaseSelectedBlock)(BOOL success,NSArray<GPCMediaFilesSelectorPhotoCase*>* photoCaseListSelected);
typedef void(^AddPhotoCaseSelectedBlock)(BOOL success,NSArray<GPCMediaFilesSelectorPhotoCase*>* photoCaseListSelected);

@interface GPCMediaFilesSelectorPhotoCaseDataSource : GPCMediaFilesSelectorCaseDataSource
{
    NSMutableArray<GPCMediaFilesSelectorPhotoCase*>* _photoCaseSelectedList;
    NSMutableArray<GPCMediaFilesSelectorPhotoCase*>* _takingPhotoList;
    GPCMediaFilesSelectorPhotoCase*                  _isPreviewIngCase;
}
@property(nonatomic,strong)GPCMediaFilesSelectorPhotoCase* currentPrevingPhotoCase;
@property(nonatomic,strong,readonly)NSArray<GPCMediaFilesSelectorPhotoCase*>* photoCaseListSelected;
@property(nonatomic,strong,readonly)NSArray<GPCMediaFilesSelectorPhotoCase*>* takingPhotoCaseList;
- (void)deletePhotoCaseSelected:(GPCMediaFilesSelectorPhotoCase *)photoCase
                      completed:(DeletePhotoCaseSelectedBlock)complete;
- (void)addPhotoCaseSelected:(GPCMediaFilesSelectorPhotoCase *)photoCase
                      completed:(AddPhotoCaseSelectedBlock)complete;
//请求预览图
- (void)requestPicturesSelectedPreviewImages:(RequstPreiveImageSelectedBlock)complete;
//请求视频
- (void)requestVideoOperation:(RequstVideosSelectedBlock)complete;
//请求LivePhoto
- (void)requestLivePhotoOperation:(RequestLivePhotosSelectedBlock)complete PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0);
//添加拍摄的照片
- (void)addTakingPhoto:(UIImage*)takingPhoto;
@end
