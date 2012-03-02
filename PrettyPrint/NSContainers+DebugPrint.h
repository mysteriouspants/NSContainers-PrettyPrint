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

// ASCII property-list style escaping
@interface NSString (EscapeArtist)
- (NSString *)fs_stringByEscaping;
@end

// Helper when working with indents.
@interface NSString (FilledString)
+ (NSString *)fs_stringByFillingWithCharacter:(char)character repeated:(NSUInteger)times;
+ (NSString *)fs_stringByFillingWithString:(NSString *)string repeated:(NSUInteger)times;
@end

@interface NSMutableString (PrettyDict)
- (void)fs_appendDictionaryStartWithIndentString:(NSString *)indentString;
- (void)fs_appendDictionaryKey:(NSString *)key value:(id)value locale:(id)locale indentString:(NSString *)indentString indentLevel:(NSUInteger)level;
- (void)fs_appendDictionaryEndWithIndentString:(NSString *)indentString;
@end
