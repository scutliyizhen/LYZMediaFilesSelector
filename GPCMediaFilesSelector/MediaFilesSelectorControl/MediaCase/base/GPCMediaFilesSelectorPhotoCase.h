//
//  GPCMediaFilesSelectorPhotoCase.h
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorCase.h"
#import <AVFoundation/AVPlayerItem.h>
#import <Photos/PHLivePhoto.h>

//#define GPC_SELECTOR_CASE_TEST 1

@class GPCMediaFilesSelectorPhotoCaseDataSource;
@class GPCMediaFilesSelectorPhotoCase;
@class GPCMediaFilesSelectorPhotoCellView;
@class GPCMediaFilesSelectorPhotoViewState;

typedef void(^RequestPreviewImageBlock)(BOOL finished,
                                        UIImage* image,
                                        GPCMediaFilesSelectorPhotoCase* selectorCase);

typedef void(^RequestVideoBlock)(BOOL finished,
                                 int32_t requestId,
                                 AVPlayerItem *playerItem,
                                 NSDictionary *info);

typedef void(^RequestLivePhotoBlock)(BOOL finished,PHLivePhoto* livePhoto,NSDictionary* info);

typedef NS_ENUM(NSInteger,PhotoCaseRequestOptionDeliveryMode)
{
    PhotoCaseRequestOptionDeliveryModeOpportunisticMode,
    PhotoCaseRequestOptionDeliveryModeFastMode
};

@interface GPCMediaFilesSelectorPhotoCaseOption : NSObject
@property(nonatomic,assign)BOOL isAsynchronous;
@property(nonatomic,assign)BOOL isSpecialRunloopMode;//仅在主线程队列起作用

//PhotoCaseRequestOptionDeliveryModeFastMode模式下使用
@property(nonatomic,assign)CGFloat thumbnailImageScale;
@property(nonatomic,assign)PhotoCaseRequestOptionDeliveryMode deliveryMode;

@property(nonatomic,assign)BOOL requestGalleryTitle;
@property(nonatomic,assign)BOOL requestCreateTime;
@property(nonatomic,assign)BOOL requestPhotoName;
@end

@interface GPCMediaFilesSelectorPhotoCase : GPCMediaFilesSelectorCase
@property (nonatomic,strong,readonly)GPCMediaFilesSelectorPhotoCaseOption* options;
@property (nonatomic,strong,readonly)NSString* photoKey;
@property (nonatomic,strong,readonly)GPCMediaFilesSelectorPhotoViewState* viewState;
//这个地方一定不能强引用，否则会出现引用环
@property(nonatomic,weak)GPCMediaFilesSelectorPhotoCaseDataSource* photoDataSource;
@property(nonatomic,weak)GPCMediaFilesSelectorPhotoCellView* photoCellView;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithViewState:(GPCMediaFilesSelectorPhotoViewState*)viewState;

//loadAllPhotos loadAlbumList时起作用
- (void)requestPreviewImageOperation:(RequestPreviewImageBlock)requestBlok;
//loadAllVideo loadVideoList时起作用
- (void)requestVideoOperation:(RequestVideoBlock)requestBlock;
//loadAllLivePhoto时起作用
- (void)requestLivePhoto:(RequestLivePhotoBlock)requestBlock;

//开始曝光
- (void)startExposureOperation;
//结束曝光
- (void)endExposureOperaion;
//屏幕逗留
- (void)stayingOnScreenOperation;
@end

