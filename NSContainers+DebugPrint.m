//
//  NSContainers+DebugPrint.m
//
//  Created by Christopher Miller on 1/30/12.
//  Copyright (c) 2012 Christopher Miller. All rights reserved.
//

#import "NSContainers+DebugPrint.h"

@protocol DescriptionPrint <NSObject>
- (NSString *)fs_description;
@end

@interface NSString (IndentMutator)
- (NSString *)fs_stringByIndentingAllButFirstLine:(NSString *)indent;
- (NSString *)fs_stringByIndentingAllLines:(NSString *)indent;
@end

@interface NSString (EscapeArtist)
- (NSString *)fs_stringByEscaping;
@end

@implementation NSArray (DebugPrint)
- (NSString *)fs_description
{
    Class __strClass = [NSString class];
    
    NSString * indent_string = @"    ";
    
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"("];
    
    for (id obj in self) {
        if ([obj isKindOfClass:__strClass])
            [str appendFormat:@"\n%@%@", indent_string, [obj fs_stringByEscaping]];
        else if ([obj respondsToSelector:@selector(fs_description)])
            [str appendFormat:@"\n%@%@", indent_string, [[obj fs_description] fs_stringByIndentingAllButFirstLine:indent_string]];
        else if ([obj respondsToSelector:@selector(fs_descriptionDictionary)])
            [str appendFormat:@"\n%@%@", indent_string, [[((id<DescriptionPrint>)[((id<DescriptionDict>)obj) fs_descriptionDictionary]) fs_description] fs_stringByIndentingAllButFirstLine:indent_string]];
        else
            [str appendFormat:@"\n%@%@", indent_string, [[obj description] fs_stringByEscaping]];
        [str appendString:@","];
    }
    
    if (0==[self count]) [str appendString:@")"];
    else [str appendString:@"\n)"];
    
    return [str copy];
}
@end

@implementation NSDictionary (DebugPrint)
- (NSString *)fs_description
{
    Class __strClass = [NSString class];
    
    NSString * indent_string = @"    ";
    
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendString:@"{"];
    
    for (id _key in [self allKeys]) {
        id _value = [self valueForKey:_key];
        [str appendFormat:@"\n%@%@ = ", indent_string, _key];
        if ([_value isKindOfClass:__strClass])
            [str appendFormat:@"%@", [_value fs_stringByEscaping]];
        else if ([_value respondsToSelector:@selector(fs_description)])
            [str appendString:[[_value fs_description] fs_stringByIndentingAllButFirstLine:indent_string]];
        else if ([_value respondsToSelector:@selector(fs_descriptionDictionary)])
            [str appendString:[[((id<DescriptionPrint>)[((id<DescriptionDict>)_value) fs_descriptionDictionary]) fs_description] fs_stringByIndentingAllButFirstLine:indent_string]];
        else
            [str appendString:[[_value description] fs_stringByEscaping]];
        [str appendString:@","];
    }
    
    if (0==[[self allKeys] count]) [str appendString:@"}"];
    else [str appendString:@"\n}"];
    
    return [str copy];
}
@end

@implementation NSString (IndentMutator)
- (NSString *)fs_stringByIndentingAllButFirstLine:(NSString *)indent
{ @autoreleasepool {
    NSMutableString * str = [[NSMutableString alloc] init];
    __block size_t line_no=0;
    [self enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        if (0==line_no) {
            [str appendFormat:@"%@", line];
        } else {
            [str appendFormat:@"\n%@%@", indent, line];
        }
        ++line_no;
    }];
    return [str copy];
} }
- (NSString *)fs_stringByIndentingAllLines:(NSString *)indent
{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n%@", indent]];
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
    
    if (YES==replacedSomething) {
        [s insertString:@"\"" atIndex:0];
        [s appendString:@"\""];
    }
    
    return [s copy];
} }
@end
