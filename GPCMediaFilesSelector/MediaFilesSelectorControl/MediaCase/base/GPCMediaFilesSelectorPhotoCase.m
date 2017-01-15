//
//  GPCMediaFilesSelectorPhotoCase.m
//  GameBible
//
//  Created by robertyzli on 16/7/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesSelectorPhotoCase.h"
#import "GPCMediaFilesSelectorPhotoCaseDataSource.h"
#import "GPCMediaFilesSelectorPhotoCellView.h"
#import "GPCMediaFilesSelectorBridge.h"

@implementation GPCMediaFilesSelectorPhotoCaseOption
- (instancetype)init
{
    if(self = [super init])
    {
        self.thumbnailImageScale = 1.0;
    }
    return self;
}
@end

@interface GPCMediaFilesSelectorPhotoCase()
@property(nonatomic,strong,readwrite)GPCMediaFilesSelectorPhotoCaseOption* options;
@property(nonatomic,strong,readwrite)GPCMediaFilesSelectorPhotoViewState* viewState;
@end

@implementation GPCMediaFilesSelectorPhotoCase
+ (GPCMediaFilesSelectorCellView*)createSelectorCaseCellView:(Class)bridgeClass
{
    GPCMediaFilesSelectorPhotoCellView* photoCellView = [bridgeClass getMediaFilesPhotoCellView];
    return photoCellView;
}

- (instancetype)initWithViewState:(GPCMediaFilesSelectorPhotoViewState *)viewState
{
    if(self = [super init])
    {
        self.viewState = viewState;
        self.options = [GPCMediaFilesSelectorPhotoCaseOption new];
    }
    return self;
}

- (NSString*)photoKey
{
    return [NSString stringWithFormat:@"%p",self];
}

- (void)startExposureOperation
{

}

- (void)endExposureOperaion
{

}

- (void)stayingOnScreenOperation
{

}

- (void)requestPreviewImageOperation:(RequestPreviewImageBlock)requestBlok
{
    
}

- (void)requestVideoOperation:(RequestVideoBlock)requestBlock
{

}

- (void)requestLivePhoto:(RequestLivePhotoBlock)requestBlock
{

}

- (void)bindViewClickEvent:(UIView*)sender
                  cellView:(GPCMediaFilesSelectorCellView*)cellView
              selectorCase:(GPCMediaFilesSelectorCase*)selectorCase
{
    [self.photoDataSource.bridge photoCaseBindViewClickEvent:sender cellView:self.photoCellView photoCase:self];
}
@end
