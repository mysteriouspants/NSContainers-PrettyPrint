//
//  NSContainers+DebugPrint.m
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import "NSContainers+DebugPrint.h"

#import "JRSwizzle.h"

@interface NSArray (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableArray (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
@interface NSDictionary (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level;
@end
@interface NSMutableDictionary (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end

@implementation NSObject (DebugPrint)
+ (BOOL)fs_swizzleContainerPrinters:(__autoreleasing NSError **)error
{
    Class __dictClass, __arrayClass, __mutableDictClass, __mutableArrayClass;
    @autoreleasepool {
        __dictClass = [[NSDictionary dictionary] class];
        __arrayClass = [[NSArray array] class];
        __mutableDictClass = [[NSMutableDictionary dictionary] class];
        __mutableArrayClass = [[NSMutableArray array] class];
    }

    [__dictClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                       withMethod:@selector(fs_descriptionWithLocale:indent:)
                            error:error];
    if (*error) return NO;
    [__arrayClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                        withMethod:@selector(fs_descriptionWithLocale:indent:)
                             error:error];
    if (*error) {
        // unswizzle to prevent a mixed state; it's reasonable to expect that
        // if the swizzle worked the first time that it'll work again
        [__dictClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                           withMethod:@selector(fs_descriptionWithLocale:indent:)
                                error:error];
        return NO;
    }
    if (__dictClass != __mutableDictClass) {
        [__mutableDictClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                                  withMethod:@selector(fs_descriptionWithLocale:indent:)
                                       error:error];
        if (*error) {
            // unswizzle to prevent a mixed state
            [__dictClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                               withMethod:@selector(fs_descriptionWithLocale:indent:)
                                    error:error];
            [__arrayClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                                withMethod:@selector(fs_descriptionWithLocale:indent:)
                                     error:error];
            return NO;
        }
    }
    if (__arrayClass != __mutableArrayClass) {
        [__mutableArrayClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                                   withMethod:@selector(fs_descriptionWithLocale:indent:)
                                        error:error];
        if (*error) {
            // unswizzle to prevent a mixed state
            [__dictClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                               withMethod:@selector(fs_descriptionWithLocale:indent:)
                                    error:error];
            [__arrayClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                                withMethod:@selector(fs_descriptionWithLocale:indent:)
                                     error:error];
            if (__dictClass != __mutableDictClass) {
                [__mutableDictClass jr_swizzleMethod:@selector(descriptionWithLocale:indent:)
                                          withMethod:@selector(fs_descriptionWithLocale:indent:)
                                               error:error];
                             }
            return NO;
        }
    }

    return YES;
}
@end

@implementation NSArray (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
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
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:(NSUInteger)level];
}
@end

@implementation NSDictionary (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
- (NSString *)fs_descriptionWithLocale__impl:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    Class __strClass = [NSString class];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:4*level];

    [str appendFormat:@"%@{\n", indent];

    [self enumerateKeysAndObjectsUsingBlock:^(id _key, id _value, BOOL *stop) {
        [str appendFormat:@"%@    %@ = ", indent, [_key fs_stringByEscaping]];
        if ([_value isKindOfClass:__strClass])
            [str appendString:[_value fs_stringByEscaping]];
        else if ([_value respondsToSelector:@selector(descriptionWithLocale:indent:)])
            [str appendString:[_value descriptionWithLocale:locale indent:1+level]];
        else if ([_value respondsToSelector:@selector(descriptionWithLocale:)])
            [str appendString:[[_value descriptionWithLocale:locale] fs_stringByEscaping]];
        else if ([_value conformsToProtocol:@protocol(FSDescriptionDict)])
            [str appendString:[[_value fs_descriptionDictionary] descriptionWithLocale:locale indent:level+1]];
        else
            [str appendString:[[_value description] fs_stringByEscaping]];
        [str appendString:@";\n"];
    }];

    [str appendFormat:@"%@}", indent];

    return str;
}
@end

@implementation NSMutableDictionary (DebugPrint)
- (NSString *)fs_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self fs_descriptionWithLocale__impl:locale indent:level];
}
@end

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
//    unichar* f = malloc(sizeof(unichar)*times+1);
//    f = (unichar*)wmemset((wchar_t*)f, character, times);
    
    f = memset(f, character, times); // memset may be implemented in assembler, which has some really spiffy bits to make filling memory blocks super-fast.
    // It's fair to expect OS X to have an optimized memset; ObjC zero-fills new objects, so using memset for that AND having that super-optimized makes sense.
    // So, by using memset we get to piggy-back on their work, for free.
    return [[NSString alloc] initWithBytesNoCopy:f length:times encoding:NSASCIIStringEncoding freeWhenDone:YES];
//    NSString * s= [[NSString alloc] initWithUTF8String:<#(const char *)#>tWithCharacters:f length:times];
//    free(f);
//    return s;
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
    else _value = [value fs_stringByEscaping];
    [self appendFormat:@"%@    %@ = %@;\n", indentString, [key fs_stringByEscaping], _value];
}
- (void)fs_appendDictionaryEndWithIndentString:(NSString *)indentString
{
  [self appendFormat:@"%@}", indentString];
}
@end
