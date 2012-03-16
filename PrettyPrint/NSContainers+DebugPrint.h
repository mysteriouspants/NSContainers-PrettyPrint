//
//  NSContainers+DebugPrint.h
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Add the build flag -DDEBUGPRINT_ALL to get pretty-printed containers.
 * You can also use DEBUGPRINT_NSARRAY, DEBUGPRINT_NSDICTIONARY, and DEBUGPRINT_NSSET to get just that container if you so chose.
 */

// implement this in order to have your own objects print themselves in property-list like format
@protocol FSDescriptionDict <NSObject>
- (NSDictionary *)fs_descriptionDictionary;
@end

#if defined(DEBUGPRINT_NSARRAY) || defined(DEBUGPRINT_ALL)
@interface NSArray (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableArray (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSDICTIONARY) || defined(DEBUGPRINT_ALL)
@interface NSDictionary (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableDictionary (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSSET) || defined(DEBUGPRINT_ALL)
@interface NSSet (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableSet (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

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
