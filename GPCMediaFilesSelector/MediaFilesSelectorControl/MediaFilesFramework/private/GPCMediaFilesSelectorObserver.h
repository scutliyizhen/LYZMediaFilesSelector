//
//  GPCMediaFilesSelectorObserver.h
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCMediaFilesSelectorLocalPhotoCase.h"

typedef void(^RequestThumanailImageForIndexBlock)(GPCMediaFilesSelectorLocalPhotoCase* selectorCase,GPCLocalPhotoCaseDataModel* dataModel);
typedef void(^RequestPreviewImageForAssets)(BOOL finished,UIImage* previewImage,GPCMediaFilesSelectorLocalPhotoCase* photoModel);
typedef void(^RequestAlbumForIndexBlock)(UIImage* disPlayImg);


typedef enum{
    GPC_Photo_Request_type_All,
    GPC_Photo_Request_type_Special_Album,
    GPC_Photo_Request_type_AlbumList,
}GPC_Photo_Request_type;
//相册库发生改变回调block

typedef void(^updatePhotoDataSourceBlock)();

typedef GPC_Photo_Request_type(^PhotoRequestTypeBlock)();//指定当前的回调工作在哪种数据类型环境下
typedef void(^PhotoLibraryChangedReload)();//重新刷新照片显示UI
typedef void(^PhotoLibraryAlbumListReload)();//刷新相册列表UI
typedef NSUInteger(^PhotoAlbumIndexBlock)();//指定相册index，返回当前展示的照片属于哪个相册
typedef void(^PhotoLibraryPhotosChanged)(NSIndexSet* insertIndexs,
                                         NSIndexSet* removeIndexs,
                                         NSIndexSet* changedIndexs,
                                         GPC_Photo_Request_type type,
                                         updatePhotoDataSourceBlock update);
@interface GPCMediaFilesSelectorObserver : NSObject
@property(nonatomic,weak)id observer;
@property(nonatomic,strong)NSString* objName;
@property(nonatomic,copy)PhotoRequestTypeBlock photoRequestTypeHandler;
@property(nonatomic,copy)PhotoLibraryChangedReload photosReloadHandler;
@property(nonatomic,copy)PhotoLibraryAlbumListReload albumListReloadHandler;
@property(nonatomic,copy)PhotoAlbumIndexBlock photoAlbumIndexHandler;
@property(nonatomic,copy)PhotoLibraryPhotosChanged photosChangedHandler;
@end
