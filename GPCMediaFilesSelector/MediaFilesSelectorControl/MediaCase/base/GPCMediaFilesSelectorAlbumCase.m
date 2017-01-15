//
//  GPCMediaFilesSelectorAlbumCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorAlbumCase.h"
#import "GPCMediaFilesSelectorFrameworkManager.h"
#import "GPCMediaFilesSelectorGalleryCaseDataSource.h"
#import "GPCMediaFilesSelectorGalleryCellView.h"
#import "GPCMediaFilesSelectorBridge.h"

@interface GPCMediaFilesSelectorAlbumCase()
@property(nonatomic,strong)UIImage* requestImage;
@property(nonatomic,strong,readwrite)GPCMediaFilesSelectorGalleryViewState* viewState;
@end

@implementation GPCMediaFilesSelectorAlbumCase
+ (GPCMediaFilesSelectorCellView*)createSelectorCaseCellView:(Class)bridgeClass
{
    GPCMediaFilesSelectorGalleryCellView* galleryView = [bridgeClass getMediaFilesGalleryCellView];
    return galleryView;
}

- (instancetype)initWithViewState:(GPCMediaFilesSelectorGalleryViewState *)viewState
{
    if(self = [super init])
    {
        self.viewState = viewState;
    }
    return self;
}

- (UIImage*)iconImage
{
    return self.requestImage;
}

- (void)startRequstIconImageToBindView:(GPCMediaFilesSelectorCellView *)cellView
{
    [[GPCMediaFilesSelectorFrameworkManager shareInstance] startCachingGalleryImage:self.galleryDataSource.targetSize galleryModel:self];
}

- (void)bindViewClickEvent:(UIView *)sender cellView:(GPCMediaFilesSelectorCellView *)cellView selectorCase:(GPCMediaFilesSelectorCase *)selectorCase
{
    [self.galleryDataSource.bridge galleryCaseBindViewClickEvent:sender cellView:self.galleryCellView albumCase:self];
}


- (void)requestUpdateIconImage:(RequestUpdateIConImageInfoBlock)complete
{
    if(self.iconImage)
    {
        if(complete)
        {
            complete(self.iconImage,NO,self,nil);
        }
    }else
    {
        __weak typeof (self) weakSelf = self;
        [[GPCMediaFilesSelectorFrameworkManager shareInstance] requestGalleryImage:self.galleryDataSource.targetSize galleryModel:self requestBlock:^(UIImage *disPlayImg) {
            weakSelf.requestImage = disPlayImg;
            if(complete)
            {
                complete(weakSelf.iconImage,NO,weakSelf,nil);
            }
        }];
    }
}

@end





