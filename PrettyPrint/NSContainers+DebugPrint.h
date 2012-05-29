//
//  NSContainers+DebugPrint.h
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Add the build flag -DDEBUGPRINT_ALL to get pretty-printed containers.
 * You can also use DEBUGPRINT_NSARRAY, DEBUGPRINT_NSDICTIONARY, DEBUGPRINT_NSSET, and DEBUGPRINT_NSORDEREDSET to get just that container if you so chose.
 * You can also use -DDEBUGPRINT_SWIZZLE to use a swizzling technique, if you have a situation where you want the swizzled output only part of the time.
 *
 * There's also a whitespace cleaning tool, which is turned on by default, which tries to grab the whitespace in front of descriptions. For example,
 *
 *      {
 *          foo =     (
 *              bar
 *          );
 *      }
 *
 *  Would become:
 *
 *      {
 *          foo = (
 *              bar
 *          );
 *      }
 *
 * These can be disabled with the following:
 *
 *      DEBUGPRINT_NO_SUPPRESS_WHITESPACE_ALL
 *      DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSARRAY
 *      DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSDICTIONARY
 *      DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSSET
 *      DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSORDEREDSET
 *      DEBUGPRINT_NO_SUPPRESS_WHITESPACE_OBJECT
 *
 * Additionally, there's a runtime function for this, fspp_setSuppressWhitespace and the getter variant, fspp_suppressWhitespace, which allows you to control whether whitespace trimming is enabled.
 *
 * There is not automatic whitespace trimming for custom objects. You should use fspp_suppressWhitespace(fspp_object) to determine what kind of whitespace trimming behaviors your objects should have.
 *
 * Every object needs to whitespace trim its own ivars, not trim itself of whitespace before returning the description string. If you don't understand, try doing it the wrong way and print out a few nested NSArrays.
 */

#ifdef DEBUGPRINT_SWIZZLE
bool fspp_swizzleContainerPrinters(NSError **);
bool fspp_on(void); // whether or not the debug print implementations are active
#endif

#if defined (DEBUGPRINT_NSARRAY) || defined (DEBUGPRINT_NSDICTIONARY) || defined (DEBUGPRINT_NSSET) || defined (DEBUGPRINT_NSORDEREDSET) || defined (DEBUGPRINT_ALL) || defined (DEBUGPRINT_SWIZZLE)
#define DEBUGPRINT_ANY
#endif

#if defined (DEBUGPRINT_NO_SUPPRESS_WHITESPACE_ALL) || defined (DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSARRAY) || defined (DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSDICTIONARY) || defined (DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSSET) || defined (DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSORDEREDSET)
#define DEBUGPRINT_NO_SUPPRESS_WHITESPACE_ANY
#endif

#ifdef DEBUGPRINT_ANY
enum __fspp_type {
    fspp_all,
    fspp_array,
    fspp_dictionary,
    fspp_set,
    fspp_orderedSet,
    fspp_object
};
bool fspp_suppressWhitespace(enum __fspp_type t);
void fspp_setSuppressesWhitespace(enum __fspp_type t, bool shouldSuppress);
#endif

#ifdef DEBUGPRINT_ANY
extern NSUInteger fspp_spacesPerIndent;
#endif

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

#if defined(DEBUGPRINT_NSORDEREDSET) || defined(DEBUGPRINT_ALL)
@interface NSOrderedSet (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableOrderedSet (DebugPrint)
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
- (void)fs_appendDictionaryStartWithIndentString:(NSString *)indentString caller:(id)caller;
- (void)fs_appendDictionaryKey:(NSString *)key value:(id)value locale:(id)locale indentString:(NSString *)indentString indentLevel:(NSUInteger)level;
- (void)fs_appendDictionaryKey:(NSString *)key value:(id)value locale:(id)locale indentString:(NSString *)indentString indentLevel:(NSUInteger)level whitespaceSuppression:(bool)suppress;
- (void)fs_appendDictionaryEndWithIndentString:(NSString *)indentString;
@end
