//
//  NSContainers+DebugPrint.m
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import "NSContainers+DebugPrint.h"
#import <objc/runtime.h>

#ifdef DEBUGPRINT_NO_SUPPRESS_WHITESPACE_ALL
bool __fspp_suppressWhitespaceAll = false;
#else
bool __fspp_suppressWhitespaceAll = true;
#endif

#ifdef DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSARRAY
bool __fspp_suppressWhitespaceArray = false;
#else
bool __fspp_suppressWhitespaceArray = true;
#endif

#ifdef DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSDICTIONARY
bool __fspp_suppressWhitespaceDictionary = false;
#else
bool __fspp_suppressWhitespaceDictionary = true;
#endif

#ifdef DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSSET
bool __fspp_suppressWhitespaceSet = false;
#else
bool __fspp_suppressWhitespaceSet = true;
#endif

#ifdef DEBUGPRINT_NO_SUPPRESS_WHITESPACE_NSORDEREDSET
bool __fspp_suppressWhitespaceOrderedSet = false;
#else
bool __fspp_suppressWhitespaceOrderedSet = true;
#endif

#ifdef DEBUGPRINT_NO_SUPPRESS_WHITESPACE_OBJECT
bool __fspp_suppressWhitespaceObject = false;
#else
bool __fspp_suppressWhitespaceObject = true;
#endif

bool fspp_suppressWhitespace(enum __fspp_type t)
{
    if (__fspp_suppressWhitespaceAll) return true;
    switch (t) {
        case fspp_all:
            return __fspp_suppressWhitespaceAll;
            break;
        case fspp_array:
            return __fspp_suppressWhitespaceArray;
            break;
        case fspp_dictionary:
            return __fspp_suppressWhitespaceDictionary;
            break;
        case fspp_set:
            return __fspp_suppressWhitespaceSet;
            break;
        case fspp_orderedSet:
            return __fspp_suppressWhitespaceOrderedSet;
            break;
        case fspp_object:
            return __fspp_suppressWhitespaceObject;
            break;
            
        default:
            NSCAssert(true==false, @"Not a valid");
            break;
    }
    
    return false;
}

void fspp_setSuppressesWhitespace(enum __fspp_type t, bool shouldSuppress)
{
    switch (t) {
        case fspp_all:
            __fspp_suppressWhitespaceAll = shouldSuppress;
            break;
        case fspp_array:
            __fspp_suppressWhitespaceArray = shouldSuppress;
            break;
        case fspp_dictionary:
            __fspp_suppressWhitespaceDictionary = shouldSuppress;
            break;
        case fspp_set:
            __fspp_suppressWhitespaceSet = shouldSuppress;
            break;
        case fspp_orderedSet:
            __fspp_suppressWhitespaceOrderedSet = shouldSuppress;
            break;
        case fspp_object:
            __fspp_suppressWhitespaceObject = shouldSuppress;
            break;
            
        default:
            NSCAssert(true==false, @"Not a valid");
            break;
    }
}

struct __fspp_classes fspp_implementationClasses()
{
    struct __fspp_classes c;
    @autoreleasepool {
        c._NSArray = [[NSArray array] class];
        c._NSMutableArray = [[NSMutableArray array] class];
        c._NSDictionary = [[NSDictionary dictionary] class];
        c._NSMutableDictionary = [[NSMutableDictionary dictionary] class];
        c._NSSet = [[NSSet set] class];
        c._NSMutableSet = [[NSMutableSet set] class];
        c._NSOrderedSet = [[NSOrderedSet orderedSet] class];
        c._NSMutableOrderedSet = [[NSMutableOrderedSet orderedSet] class];
    }
    return c;
}

struct __fspp_methods fspp_snapshotMethodStates(const struct __fspp_classes * c)
{
    struct __fspp_methods m;
    
    m._NSArray.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSArray, @selector(descriptionWithLocale:indent:));
    m._NSMutableArray.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableArray, @selector(descriptionWithLocale:indent:));
    m._NSDictionary.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSDictionary, @selector(descriptionWithLocale:indent:));
    m._NSMutableDictionary.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableDictionary, @selector(descriptionWithLocale:indent:));
    m._NSSet.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSSet, @selector(descriptionWithLocale:indent:));
    m._NSMutableSet.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableSet, @selector(descriptionWithLocale:indent:));
    m._NSOrderedSet.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSOrderedSet, @selector(descriptionWithLocale:indent:));
    m._NSMutableOrderedSet.descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableOrderedSet, @selector(descriptionWithLocale:indent:));
    
#ifdef DEBUGPRINT_SWIZZLE
    m._NSArray.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSArray, @selector(fs_descriptionWithLocale:indent:));
    m._NSMutableArray.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableArray, @selector(fs_descriptionWithLocale:indent:));
    m._NSDictionary.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSDictionary, @selector(fs_descriptionWithLocale:indent:));
    m._NSMutableDictionary.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableDictionary, @selector(fs_descriptionWithLocale:indent:));
    m._NSSet.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSSet, @selector(fs_descriptionWithLocale:indent:));
    m._NSMutableSet.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableSet, @selector(fs_descriptionWithLocale:indent:));
    m._NSOrderedSet.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSOrderedSet, @selector(fs_descriptionWithLocale:indent:));
    m._NSMutableOrderedSet.fs_descriptionWithLocale_indent = class_getInstanceMethod(c->_NSMutableOrderedSet, @selector(fs_descriptionWithLocale:indent:));
#endif
    
    return m;
}

NSString * fspp_NSStringFromClasses(const struct __fspp_classes * c)
{
    NSMutableString * str = [[NSMutableString alloc] init];
    
    [str appendFormat:@"  Visible Class       Implementation Class\n"];
    [str appendFormat:@"NSArray             : %@\n", NSStringFromClass(c->_NSArray)];
    [str appendFormat:@"NSMutableArray      : %@\n", NSStringFromClass(c->_NSMutableArray)];
    [str appendFormat:@"NSDictionary        : %@\n", NSStringFromClass(c->_NSDictionary)];
    [str appendFormat:@"NSMutableDictionary : %@\n", NSStringFromClass(c->_NSMutableDictionary)];
    [str appendFormat:@"NSSet               : %@\n", NSStringFromClass(c->_NSSet)];
    [str appendFormat:@"NSMutableSet        : %@\n", NSStringFromClass(c->_NSMutableSet)];
    [str appendFormat:@"NSOrderedSet        : %@\n", NSStringFromClass(c->_NSOrderedSet)];
    [str appendFormat:@"NSMutableOrderedSet : %@\n", NSStringFromClass(c->_NSMutableOrderedSet)];
    
    return str;
}

const char * __fspp_methodToString(Method m) { return sel_getName(method_getName(m)); }
void __fspp_doStuffToNSMStringForMethods(NSMutableString * str, NSString * container, struct __fspp_methods_pair p)
{
    [str appendFormat:@"%@\n", container];
    [str appendFormat:@"    descriptionWithLocale:indent:       %p      %s\n", p.descriptionWithLocale_indent, __fspp_methodToString(p.descriptionWithLocale_indent)];
#ifdef DEBUGPRINT_SWIZZLE
    [str appendFormat:@"    fs_descriptionWithLocale:indent:    %p      %s\n", p.fs_descriptionWithLocale_indent, __fspp_methodToString(p.fs_descriptionWithLocale_indent)];
#endif
}
NSString * fspp_NSStringFromMethods(const struct __fspp_methods * m) {
    NSMutableString * str = [[NSMutableString alloc] init];
    
    __fspp_doStuffToNSMStringForMethods(str, @"NSArray", m->_NSArray);
    __fspp_doStuffToNSMStringForMethods(str, @"NSMutableArray", m->_NSMutableArray);
    __fspp_doStuffToNSMStringForMethods(str, @"NSDictionary", m->_NSDictionary);
    __fspp_doStuffToNSMStringForMethods(str, @"NSMutableDictionary", m->_NSMutableDictionary);
    __fspp_doStuffToNSMStringForMethods(str, @"NSSet", m->_NSSet);
    __fspp_doStuffToNSMStringForMethods(str, @"NSMutableSet", m->_NSMutableSet);
    __fspp_doStuffToNSMStringForMethods(str, @"NSOrderedSet", m->_NSOrderedSet);
    __fspp_doStuffToNSMStringForMethods(str, @"NSMutableOrderedSet", m->_NSMutableOrderedSet);
    
    return str;
}

#ifdef DEBUGPRINT_SWIZZLE
#import "JRSwizzle.h"
static bool __fspp_swizzled=false;

bool fspp_swizzleContainerPrinters(NSError ** error)
{
    struct __fspp_classes c = fspp_implementationClasses();

    [c._NSArray jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
    if (*error) return false;
    if (c._NSArray != c._NSMutableArray) {
        [c._NSMutableArray jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
        if (*error) return false;
    }
    
    [c._NSDictionary jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
    if (*error) return false;
    if (c._NSDictionary != c._NSMutableDictionary) {
        [c._NSMutableDictionary jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
        if (*error) return false;
    }
    
    [c._NSSet jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
    if (*error) return false;
    if (c._NSSet != c._NSMutableSet) {
        [c._NSMutableSet jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
        if (*error) return false;
    }
    
    [c._NSOrderedSet jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
    if (*error) return false;
    if (c._NSOrderedSet != c._NSMutableOrderedSet) {
        [c._NSMutableOrderedSet jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:error];
        if (*error) return false;
    }
    __fspp_swizzled = !__fspp_swizzled;
    return true;
}
bool fspp_on(void)
{
  return __fspp_swizzled;
}
#endif

#ifdef DEBUGPRINT_SPACES_PER_INDENT
NSUInteger fspp_spacesPerIndent = DEBUGPRINT_SPACES_PER_INDENT;
#else
NSUInteger fspp_spacesPerIndent = 4;
#endif

#if defined(DEBUGPRINT_NSARRAY) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@interface NSArray (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableArray (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSDICTIONARY) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@interface NSDictionary (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableDictionary (__DebugPrint__)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSSET) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@interface NSSet (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableSet (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSORDEREDSET) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@interface NSOrderedSet (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableOrderedSet (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSARRAY) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@implementation NSArray (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    Class __strClass = [NSString class];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent*level];
    NSString * sub_indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent];
    __block NSString * tmpString;

    [str appendFormat:@"%@(\n", indent];

    NSUInteger lastObjectIndex = [self count]-1;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:__strClass])
            tmpString = [obj fs_stringByEscaping];
        else if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)])
            tmpString = [obj descriptionWithLocale:locale indent:level+1];
        else if ([obj respondsToSelector:@selector(descriptionWithLocale:)])
            tmpString = [[obj descriptionWithLocale:locale] fs_stringByEscaping];
        else if ([obj conformsToProtocol:@protocol(FSDescriptionDict)])
            tmpString = [[obj fs_descriptionDictionary] descriptionWithLocale:locale indent:level+1];
        else
            tmpString = [[obj description] fs_stringByEscaping];
        
        if (fspp_suppressWhitespace(fspp_array))
            tmpString = [tmpString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        [str appendFormat:@"%@%@%@%@\n", indent, sub_indent, tmpString, (idx==lastObjectIndex)?@"":@","];
    }];

    [str appendFormat:@"%@)", indent];

    return str;
}
@end
@implementation NSMutableArray (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end
#endif

#if defined(DEBUGPRINT_NSDICTIONARY) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@implementation NSDictionary (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent*level];

    [str fs_appendDictionaryStartWithIndentString:indent];

    [self enumerateKeysAndObjectsUsingBlock:^(id _key, id _value, BOOL *stop) {
        [str fs_appendDictionaryKey:_key value:_value locale:locale indentString:indent indentLevel:level+1 whitespaceSuppression:fspp_suppressWhitespace(fspp_dictionary)];
    }];

    [str fs_appendDictionaryEndWithIndentString:indent];

    return str;
}
@end
@implementation NSMutableDictionary (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end
#endif

#if defined(DEBUGPRINT_NSSET) || defined(DEBUGPRINT_ALL) || defined (DEBUGPRINT_SWIZZLE)
@implementation NSSet (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent*level];
    NSString * sub_indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent];
    
    Class __strClass = [NSString class];
    __block NSString * tmpString;
    NSUInteger count = [self count];
    __block NSUInteger idx = 0;
    
    [str appendFormat:@"%@{(\n", indent];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:__strClass])
            tmpString = [obj fs_stringByEscaping];
        else if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)])
            tmpString = [obj descriptionWithLocale:locale indent:level+1];
        else if ([obj respondsToSelector:@selector(descriptionWithLocale:)])
            tmpString = [[obj descriptionWithLocale:locale] fs_stringByEscaping];
        else if ([obj conformsToProtocol:@protocol(FSDescriptionDict)])
            tmpString = [[obj fs_descriptionDictionary] descriptionWithLocale:locale indent:level+1];
        else
            tmpString = [[obj description] fs_stringByEscaping];
        
        if (fspp_suppressWhitespace(fspp_set))
            tmpString = [tmpString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [str appendFormat:@"%@%@%@", indent, sub_indent, tmpString];
        if (idx+1 == count)
            [str appendString:@"\n"];
        else
            [str appendString:@",\n"];
        
        idx++;
    }];
    
    [str appendFormat:@"%@)}", indent];
    
    return str;
}
@end
@implementation NSMutableSet (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end
#endif

#if defined(DEBUGPRINT_NSORDEREDSET) || defined(DEBUGPRINT_ALL) || defined(DEBUGPRINT_SWIZZLE)
@implementation NSOrderedSet (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent*level];
    NSString * sub_indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent];
    
    Class __strClass = [NSString class];
    __block NSString * tmpString;
    NSUInteger count = [self count];
    
    [str appendFormat:@"%@{(\n", indent];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:__strClass])
            tmpString = [obj fs_stringByEscaping];
        else if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)])
            tmpString = [obj descriptionWithLocale:locale indent:level+1];
        else if ([obj respondsToSelector:@selector(descriptionWithLocale:)])
            tmpString = [[obj descriptionWithLocale:locale] fs_stringByEscaping];
        else if ([obj conformsToProtocol:@protocol(FSDescriptionDict)])
            tmpString = [[obj fs_descriptionDictionary] descriptionWithLocale:locale indent:level+1];
        else
            tmpString = [[obj description] fs_stringByEscaping];
        
        if (fspp_suppressWhitespace(fspp_orderedSet))
            tmpString = [tmpString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [str appendFormat:@"%@%@%@", indent, sub_indent, tmpString];
        if (idx+1 == count)
            [str appendString:@"\n"];
        else
            [str appendString:@",\n"];
    }];
    
    [str appendFormat:@"%@)}", indent];
    
    return str;
}
@end
@implementation NSMutableOrderedSet (DebugPrint)
#ifndef DEBUGPRINT_SWIZZLE
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
#endif
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end
#endif

@implementation NSString (EscapeArtist)
- (NSString *)fs_stringByEscaping
{ @autoreleasepool {
    NSMutableString * s = [self mutableCopy];
    NSDictionary * replacementDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      // REPLACEMENT, PATTERN
                                      @"\\n", @"\n",
                                      @"\\r", @"\r",
                                      @"\"",  @"\\\"",
                                      nil];    // TODO: many many more kinds of escapes
    BOOL replacedSomething = NO;
    for (NSString * pattern in [replacementDict allKeys]) {
        if (NSNotFound!=[s rangeOfString:pattern].location) {
            replacedSomething = YES;
            [s replaceOccurrencesOfString:pattern withString:[replacementDict objectForKey:pattern] options:NSLiteralSearch range:NSMakeRange(0, [s length])];
        }
    }

    if (NSNotFound!=[s rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@";,. "]].location)
        replacedSomething = YES;
    
    if (YES==replacedSomething) {
        [s insertString:@"\"" atIndex:0];
        [s appendString:@"\""];
    }
    
    return [s copy];
} }
@end

@implementation NSString (FilledString)
+ (NSString *)fs_stringByFillingWithCharacter:(char)character repeated:(NSUInteger)times
{
    char* f = malloc(sizeof(char)*times);
    
    f = memset(f, character, times); // memset may be implemented in assembler, which has some really spiffy bits to make filling memory blocks super-fast.
    // It's fair to expect OS X to have an optimized memset; ObjC zero-fills new objects, so using memset for that AND having that super-optimized makes sense.
    // So, by using memset we get to piggy-back on their work, for free.
    return [[NSString alloc] initWithBytesNoCopy:f length:times encoding:NSASCIIStringEncoding freeWhenDone:YES];
}
+ (NSString *)fs_stringByFillingWithString:(NSString *)string repeated:(NSUInteger)times
{
    NSMutableString * s = [NSMutableString stringWithCapacity:[string length]*times];
    for (NSUInteger i=0;
         i<times;
         ++i) [s appendString:string];
    return s;
}
@end

@implementation NSMutableString (PrettyDict)
- (void)fs_appendDictionaryStartWithIndentString:(NSString *)indentString
{
  [self appendFormat:@"%@{\n", indentString];
}
- (void)fs_appendDictionaryStartWithIndentString:(NSString *)indentString caller:(id)caller
{
    [self appendFormat:@"%@{\n", indentString];
    [self fs_appendDictionaryKey:@"_class" value:NSStringFromClass([caller class]) locale:nil indentString:indentString indentLevel:1];
    [self fs_appendDictionaryKey:@"_ptr" value:[NSString stringWithFormat:@"%p", caller] locale:nil indentString:indentString indentLevel:1];
}
- (void)fs_appendDictionaryKey:(NSString *)key value:(id)value locale:(id)locale indentString:(NSString *)indentString indentLevel:(NSUInteger)level
{
    [self fs_appendDictionaryKey:key value:value locale:locale indentString:indentString indentLevel:level whitespaceSuppression:fspp_suppressWhitespace(fspp_dictionary)];
}
- (void)fs_appendDictionaryKey:(NSString *)key value:(id)value locale:(id)locale indentString:(NSString *)indentString indentLevel:(NSUInteger)level whitespaceSuppression:(bool)suppress
{
    NSString * _value = nil;
    if ([value respondsToSelector:@selector(fs_descriptionDictionary)]) _value = [[value fs_descriptionDictionary] descriptionWithLocale:locale indent:level];
    else if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) _value = [value descriptionWithLocale:locale indent:level];
    else if ([value respondsToSelector:@selector(descriptionWithLocale:)]) _value = [[value descriptionWithLocale:locale] fs_stringByEscaping];
    else _value = [[value description] fs_stringByEscaping];
    
    if (suppress)
        _value = [_value fs_stringByTrimmingWhitespace];

    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent];
    
    [self appendFormat:@"%@%@%@ = %@;\n", indentString, indent, [key fs_stringByEscaping], _value];
}
- (void)fs_appendDictionaryEndWithIndentString:(NSString *)indentString
{
  [self appendFormat:@"%@}", indentString];
}
@end

@implementation NSMutableString (ObjectPrinterUtils)
- (void)fs_appendObjectStartWithIndentString:(NSString *)indentString caller:(id)caller
{
    [self appendFormat:@"%@<%@:%p", indentString, NSStringFromClass([caller class]), (const void *)caller];
}
- (void)fs_appendObjectPropertyKey:(NSString *)key value:(id)value locale:(id)locale indentLevel:(NSUInteger)level
{
    [self fs_appendObjectPropertyKey:key value:value locale:locale indentLevel:level whitespaceSuppression:true];
}
- (void)fs_appendObjectPropertyKey:(NSString *)key value:(id)value locale:(id)locale indentLevel:(NSUInteger)level whitespaceSuppression:(bool)suppress
{
    NSString * _value = nil;
    if ([value respondsToSelector:@selector(fs_descriptionDictionary)]) _value = [[value fs_descriptionDictionary] descriptionWithLocale:locale indent:level+1];
    else if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) _value = [value descriptionWithLocale:locale indent:level+1];
    else if ([value respondsToSelector:@selector(descriptionWithLocale:)]) _value = [[value descriptionWithLocale:locale] fs_stringByEscaping];
    else _value = [[value description] fs_stringByEscaping];
    
    if (suppress)
        _value = [_value fs_stringByTrimmingWhitespaceForType:fspp_object];
    
    [self appendFormat:@" %@: %@", key, _value];
}
- (void)fs_appendObjectNewlineWithIndentString:(NSString *)indentString
{
    [self appendFormat:@"\n%@%@", indentString, [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent-1]];
}
- (void)fs_appendObjectEnd
{
    [self appendString:@">"];
}
@end

@implementation NSString (Trimmer)
- (NSString *)fs_stringByTrimmingWhitespace
{
    return [self fs_stringByTrimmingWhitespaceForType:fspp_object];
}
- (NSString *)fs_stringByTrimmingWhitespaceForType:(enum __fspp_type)t
{
    if (fspp_suppressWhitespace(t)) return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return self;
}
@end
