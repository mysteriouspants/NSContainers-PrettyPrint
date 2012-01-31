//
//  NSContainers+DebugPrint.h
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

// implement this in order to have your own objects print themselves in property-list like format
@protocol FSDescriptionDict <NSObject>
- (NSDictionary *)fs_descriptionDictionary;
@end

@interface NSObject (DebugPrint)
+ (BOOL)fs_swizzleContainerPrinters:(__autoreleasing NSError **)error;
@end

// @interface NSArray (DebugPrint)
// - (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
// @end

// @interface NSDictionary (DebugPrint)
// - (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
// @end
