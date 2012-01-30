//
//  NSContainers+DebugPrint.h
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

// implement this in order to have your own objects print themselves in property-list like format
@protocol DescriptionDict <NSObject>
- (NSDictionary *)fs_descriptionDictionary;
@end

@interface NSArray (DebugPrint)
- (NSString *)fs_description;
@end

@interface NSDictionary (DebugPrint)
- (NSString *)fs_description;
@end
