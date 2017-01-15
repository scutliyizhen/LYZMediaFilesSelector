//
//  GPCMediaFilesMetaDataPhotoModel.m
//  GameBible
//
//  Created by robertyzli on 16/7/14.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "GPCMediaFilesMetaDataPhotoModel.h"
#import "GPCMediaFilesSelectorLocalPhotoCase.h"
#import <libkern/OSAtomic.h>

static int maxCaseCount = 800;
static int releaseCaseThreshold = 1000;

@implementation GPCMediaFilesMetaDataPhotoModel
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarnningNotificationResponse:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)setConfigPhotoCase:(GPCMediaFilesSelectorLocalPhotoCase *)photoCase
{
    __weak typeof (self) weakSelf = self;
    photoCase.addedOperationBlock = ^(NSOperation* operation)
    {
        if(operation)
        {
            [weakSelf.operationQueue addOperation:operation];
        }
    };
    
    photoCase.searchOperationBlock = ^BOOL(NSOperation* operation)
    {
        BOOL isExisted = [weakSelf searchOperationInQueue:operation];
        return isExisted;
    };
    
    photoCase.addedCaseOnDisplayingBlock = ^(GPCMediaFilesSelectorLocalPhotoCase* photoCase){
        if([photoCase isKindOfClass:[GPCMediaFilesSelectorLocalPhotoCase class]])
        {
            GPCMediaFilesSelectorLocalPhotoCase* selectorCase = (GPCMediaFilesSelectorLocalPhotoCase*)photoCase;
            
            if(![weakSelf.displayingCaseList containsObject:selectorCase])
            {
                [weakSelf.displayingCaseList addObject:selectorCase];
            }
        }
    };
    
    photoCase.deletedCaseOnDisplayingBlock = ^(GPCMediaFilesSelectorLocalPhotoCase* photoCase)
    {
        if([photoCase isKindOfClass:[GPCMediaFilesSelectorLocalPhotoCase class]])
        {
            GPCMediaFilesSelectorLocalPhotoCase* selectorCase = (GPCMediaFilesSelectorLocalPhotoCase*)photoCase;
            if([weakSelf.displayingCaseList containsObject:selectorCase])
            {
                [weakSelf.displayingCaseList removeObject:selectorCase];
            }
        }
    };
    [self.caseDic setObject:photoCase forKey:@(photoCase.index)];
}

- (NSOperationQueue*)operationQueue
{
    if(_operationQueue == nil)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;
    }
    return _operationQueue;
}

- (NSMutableArray<GPCMediaFilesSelectorLocalPhotoCase*>*)displayingCaseList
{
    if(_displayingCaseList == nil)
    {
        _displayingCaseList = [NSMutableArray new];
    }
    return _displayingCaseList;
}

- (void)memoryWarnningNotificationResponse:(NSNotification*)notification
{
    NSDictionary<NSNumber*,GPCMediaFilesSelectorLocalPhotoCase*>* tmpDic = [self.caseDic copy];
    NSArray<GPCMediaFilesSelectorLocalPhotoCase*>* tmpDisplayList = [self.displayingCaseList copy];
    
    //            double deviceMemory = [GPCSystemUtils availableMemory];
    //            double appUserMemory = [GPCSystemUtils usedMemory];
    //            NSLog(@"release before deviceMemory:%f appUserMemory:%f",deviceMemory,appUserMemory);
    __weak typeof (self)  weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary<NSNumber*,GPCMediaFilesSelectorLocalPhotoCase*>* tmpMutableDic = [tmpDic mutableCopy];
        NSMutableArray<GPCMediaFilesSelectorLocalPhotoCase*>* tmpMutablDisplay = [tmpDisplayList mutableCopy];
        [tmpDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, BOOL * _Nonnull stop) {
            if(obj.isDisplayOnScreen == NO)
            {
                [tmpMutableDic removeObjectForKey:key];
            }
        }];
        
        [tmpDisplayList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.isDisplayOnScreen == NO)
            {
                [tmpMutablDisplay removeObject:obj];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.caseDic = tmpMutableDic;
            weakSelf.displayingCaseList = tmpMutablDisplay;
            //                    double deviceMemory = [GPCSystemUtils availableMemory];
            //                    double appUserMemory = [GPCSystemUtils usedMemory];
            //                    NSLog(@"release after deviceMemory:%f appUserMemory:%f",deviceMemory,appUserMemory);
        });
    });
}

- (void)asynReleaseSelectorCase
{
    if(self.isReleasingSelectorCase == YES) return;
    if(self.caseDic.count > releaseCaseThreshold)
    {
        self.isReleasingSelectorCase = YES;
        
        NSDictionary<NSNumber*,GPCMediaFilesSelectorLocalPhotoCase*>* tmpDic = [self.caseDic copy];
        NSArray<GPCMediaFilesSelectorLocalPhotoCase*>* tmpDisplayList = [self.displayingCaseList copy];
        
        //        double deviceMemory = [GPCSystemUtils availableMemory];
        //        double appUserMemory = [GPCSystemUtils usedMemory];
        //        NSLog(@"release before deviceMemory:%f appUserMemory:%f",deviceMemory,appUserMemory);
        //NSLog(@"release before \n tmpDic:%@ \n tmpDisplayingList:%@",tmpDic,tmpDisplayList);
        
        __weak typeof (self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary<NSNumber*,GPCMediaFilesSelectorLocalPhotoCase*>* tmpMutableDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
            
            if(tmpDic.count > tmpDisplayList.count)
            {
                [tmpDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, BOOL * _Nonnull stop) {
                    if(![tmpDisplayList containsObject:obj])
                    {
                        [tmpMutableDic removeObjectForKey:key];
                    }
                }];
                
                if(tmpMutableDic.count > maxCaseCount)
                {
                    NSArray<GPCMediaFilesSelectorLocalPhotoCase*>* sortedList = [weakSelf sortDisplayingList:tmpDisplayList];
                    
                    NSMutableArray<GPCMediaFilesSelectorLocalPhotoCase*>* sortedMutableList = [sortedList mutableCopy];
                    
                    [sortedList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(tmpMutableDic.count < maxCaseCount)
                        {
                            *stop = YES;
                        }else
                        {
                            [sortedMutableList removeObject:obj];
                            [tmpMutableDic removeObjectForKey:@(obj.index)];
                        }
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.caseDic = tmpMutableDic;
                        weakSelf.displayingCaseList = sortedMutableList;
                        weakSelf.isReleasingSelectorCase = NO;
                        
                        //                         NSLog(@"release after \n tmpMutableDic:%@ \n sortedMutableList:%@",tmpMutableDic,sortedMutableList);
                        //                        double deviceMemory = [GPCSystemUtils availableMemory];
                        //                        double appUserMemory = [GPCSystemUtils usedMemory];
                        //                        NSLog(@"release after deviceMemory:%f appUserMemory:%f",deviceMemory,appUserMemory);
                    });
                    
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.caseDic = tmpMutableDic;
                        weakSelf.isReleasingSelectorCase = NO;
                        
                        //                         NSLog(@"release after \n tmpMutableDic:%@ \n tmpDisplayingList:%@",tmpMutableDic,tmpDisplayList);
                        //                        double deviceMemory = [GPCSystemUtils availableMemory];
                        //                        double appUserMemory = [GPCSystemUtils usedMemory];
                        //                        NSLog(@"release after deviceMemory:%f appUserMemory:%f",deviceMemory,appUserMemory);
                    });
                }
            }else
            {
                NSArray<GPCMediaFilesSelectorLocalPhotoCase*>* sortedList = [weakSelf sortDisplayingList:tmpDisplayList];
                
                NSMutableArray<GPCMediaFilesSelectorLocalPhotoCase*>* sortedMutableList = [sortedList mutableCopy];
                
                [sortedList enumerateObjectsUsingBlock:^(GPCMediaFilesSelectorLocalPhotoCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(tmpMutableDic.count < maxCaseCount)
                    {
                        *stop = YES;
                    }else
                    {
                        [sortedMutableList removeObject:obj];
                        [tmpMutableDic removeObjectForKey:@(obj.index)];
                    }
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.caseDic = tmpMutableDic;
                    weakSelf.displayingCaseList = sortedMutableList;
                    weakSelf.isReleasingSelectorCase = NO;
                    
                    //                    NSLog(@"release after \n tmpMutableDic:%@ \n sortedMutableList:%@",tmpMutableDic,sortedMutableList);
                    //                    double deviceMemory = [GPCSystemUtils availableMemory];
                    //                    double appUserMemory = [GPCSystemUtils usedMemory];
                    //                    NSLog(@"release after deviceMemory:%f appUserMemory:%f",deviceMemory,appUserMemory);
                });
            }
        });
    }
}

- (NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)sortDisplayingList:(NSArray<GPCMediaFilesSelectorLocalPhotoCase*>*)displayingList
{
    if(displayingList.count == 0) return nil;
    
    NSArray<GPCMediaFilesSelectorLocalPhotoCase*>* tmpList = [displayingList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        GPCMediaFilesSelectorLocalPhotoCase* selectorCase1 = (GPCMediaFilesSelectorLocalPhotoCase*)obj1;
        GPCMediaFilesSelectorLocalPhotoCase* selectorCase2 = (GPCMediaFilesSelectorLocalPhotoCase*)obj2;
        
        NSUInteger case_1_exposureCount = 0;
        OSSpinLock case1SpinLock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&case1SpinLock);
        case_1_exposureCount = selectorCase1.exposureCount;
        OSSpinLockUnlock(&case1SpinLock);
        
        NSUInteger case_2_exposureCount = 0;
        OSSpinLock case2SpinLock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&case2SpinLock);
        case_2_exposureCount = selectorCase2.exposureCount;
        OSSpinLockUnlock(&case2SpinLock);
        
        if(case_1_exposureCount > case_2_exposureCount)
        {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
    }];
    return tmpList;
}

- (BOOL)searchOperationInQueue:(NSOperation*)operation
{
    __block BOOL isExisted = NO;
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj == operation)
        {
            isExisted = YES;
            *stop = YES;
        }
    }];
    return isExisted;
}

- (NSMutableDictionary<NSNumber*,GPCMediaFilesSelectorLocalPhotoCase*>*)caseDic
{
    if(_caseDic == nil)
    {
        _caseDic = [NSMutableDictionary new];
    }
    return _caseDic;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
