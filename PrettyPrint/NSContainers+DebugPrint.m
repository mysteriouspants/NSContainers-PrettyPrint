//
//  NSContainers+DebugPrint.m
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import "NSContainers+DebugPrint.h"

#if defined(DEBUGPRINT_NSARRAY) || defined(DEBUGPRINT_ALL)
@interface NSArray (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableArray (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif
#if defined(DEBUGPRINT_NSDICTIONARY) || defined(DEBUGPRINT_ALL)
@interface NSDictionary (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableDictionary (__DebugPrint__)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif
#if defined(DEBUGPRINT_NSSET) || defined(DEBUGPRINT_ALL)
@interface NSSet (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableSet (__DebugPrint__)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
#endif

#if defined(DEBUGPRINT_NSARRAY) || defined(DEBUGPRINT_ALL)
@implementation NSArray (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    Class __strClass = [NSString class];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:4*level];
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

        [str appendFormat:@"%@    %@%@\n", indent, tmpString, (idx==lastObjectIndex)?@"":@","];
    }];

    [str appendFormat:@"%@)", indent];

    return str;
}
@end
@implementation NSMutableArray (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end
#endif

#if defined(DEBUGPRINT_NSDICTIONARY) || defined(DEBUGPRINT_ALL)
@implementation NSDictionary (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:4*level];

    [str fs_appendDictionaryStartWithIndentString:indent];

    [self enumerateKeysAndObjectsUsingBlock:^(id _key, id _value, BOOL *stop) {
        [str fs_appendDictionaryKey:_key value:_value locale:locale indentString:indent indentLevel:level+1];
    }];

    [str fs_appendDictionaryEndWithIndentString:indent];

    return str;
}
@end
@implementation NSMutableDictionary (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end
#endif

#if defined(DEBUGPRINT_NSSET) || defined(DEBUGPRINT_ALL)
@implementation NSSet (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:4*level];
    
    Class __strClass = [NSString class];
    __block NSString * tmpString;
    
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
        
        [str appendFormat:@"%@    %@%@\n", indent, tmpString, @","];
    }];
    
    // snip the last two characters, which is an ,\n, and replace with just an \n
    if ([self count]>0)
        [str replaceCharactersInRange:NSMakeRange([str length]-2, 2) withString:@"\n"];
    
    [str appendFormat:@"%@)}", indent];
    
    return str;
}
@end
@implementation NSMutableSet (DebugPrint)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
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
- (void)fs_appendDictionaryKey:(NSString *)key value:(id)value locale:(id)locale indentString:(NSString *)indentString indentLevel:(NSUInteger)level
{
    NSString * _value = nil;
    if ([value respondsToSelector:@selector(fs_descriptionDictionary)]) _value = [[value fs_descriptionDictionary] descriptionWithLocale:locale indent:level];
    else if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) _value = [value descriptionWithLocale:locale indent:level];
    else if ([value respondsToSelector:@selector(descriptionWithLocale:)]) _value = [[value descriptionWithLocale:locale] fs_stringByEscaping];
    else _value = [[value description] fs_stringByEscaping];
    [self appendFormat:@"%@    %@ = %@;\n", indentString, [key fs_stringByEscaping], _value];
}
- (void)fs_appendDictionaryEndWithIndentString:(NSString *)indentString
{
  [self appendFormat:@"%@}", indentString];
}
@end
