//
//  main.m
//  SwizzleDemo
//
//  Created by Christopher Miller on 5/23/12.
//  Copyright (c) 2012 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSContainers+DebugPrint.h"

@interface ExObj : NSObject
@property (readwrite, strong) NSString *     ivar0;
@property (readwrite, assign) size_t         ivar1;
@property (readwrite, strong) NSDictionary * ivar2;
+ (id)exObjWithString:(NSString *)ivar0 uinteger:(size_t)ivar1 dictionary:(NSDictionary *)ivar2;
@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        ExObj * e = [ExObj exObjWithString:@"Foo"
                                  uinteger:42
                                dictionary:[NSDictionary dictionaryWithObject:
                                            [ExObj exObjWithString:@"Bar"
                                                          uinteger:argc
                                                        dictionary:[NSDictionary dictionary]]
                                                                       forKey:@"anotherObject"]];
        NSCAssert(fspp_on()==false, @"Swizzle state should be OFF.");
        printf("Before swizzling:\n%s\n", [[e description] UTF8String]);
        NSError * error;
        if (!fspp_swizzleContainerPrinters(&error)) {
            NSLog(@"Error: %@", error);
        }
        NSCAssert(fspp_on()==true, @"Swizzle state should be ON.");
        printf("\nAfter swizzling:\n%s\n", [[e description] UTF8String]);
        printf("\nfspp_spacesPerIndent = 2\n");
        fspp_spacesPerIndent = 2;
        printf("%s\n", [[e description] UTF8String]);
        if (!fspp_swizzleContainerPrinters(&error)) {
            NSLog(@"Error: %@", error);
        }
        NSCAssert(fspp_on()==false, @"Swizzle state should be OFF.");
    }
    return 0;
}

@implementation ExObj
@synthesize ivar0=_ivar0,ivar1=_ivar1,ivar2=_ivar2;
+ (id)exObjWithString:(NSString *)ivar0 uinteger:(size_t)ivar1 dictionary:(NSDictionary *)ivar2
{
    ExObj * e = [[[self class] alloc] init];
    if (!e) return e;
    e.ivar0=ivar0;
    e.ivar1=ivar1;
    e.ivar2=ivar2;
    return e;
}
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString * str = [[NSMutableString alloc] init];
    NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:fspp_spacesPerIndent*level];
    
    [str appendFormat:@"%@<%@:%p\n",indent, NSStringFromClass([self class]), (const void*)self];
    [str appendFormat:@"%@    _ivar0 = %@\n",indent,[_ivar0 fs_stringByEscaping]];
    [str appendFormat:@"%@    _ivar1 = %lu\n",indent,_ivar1];
    NSString * ivar2_desc = [_ivar2 descriptionWithLocale:locale indent:level+2];
    if (fspp_suppressWhitespace(fspp_object))
        ivar2_desc = [ivar2_desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [str appendFormat:@"%@    _ivar2 = %@>",indent,ivar2_desc];
    
    return str;
}
- (NSString *)description { return [self descriptionWithLocale:nil indent:0]; }
@end
