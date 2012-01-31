#import <Foundation/Foundation.h>

#import "NSContainers+DebugPrint.h"

#import <stdio.h>

void dm_PrintLn(NSString* format, ...)        NS_FORMAT_FUNCTION(1,2);

int main(int argc, char *argv[]) { @autoreleasepool {
  NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithInteger:42], @"integer",
    [NSNumber numberWithFloat:3.141592654f], @"float",
    [NSArray array], @"emptyArray",
    [NSArray arrayWithObjects:
      @"Foo",
      @"Newlines\nAre fun?",
      @"I have space but no newline",
      [NSArray array],
      [NSArray arrayWithObject:[NSArray arrayWithObject:@"foo"]],
      [NSDictionary dictionary],
      [NSDictionary dictionaryWithObject:@"foo" forKey:@"bar"],
      nil], @"filled array",
    [NSDictionary dictionary], @"empty dictionary",
    [NSDictionary dictionaryWithObjectsAndKeys:
      [NSDictionary dictionaryWithObject:@"foo"
                                  forKey:@"bar"], @"bar", nil], @"filledDict",
    nil
  ];

#if 1
  // some curious output to play with
  dm_PrintLn(@"[NSArray class]:                                %@", NSStringFromClass([NSArray class]));
  dm_PrintLn(@"[[NSArray array] class]:                        %@\n", NSStringFromClass([[NSArray array] class]));
  dm_PrintLn(@"[NSDictionary class]:                           %@", NSStringFromClass([NSDictionary class]));
  dm_PrintLn(@"[[NSDictionary dictionary] class]:              %@\n", NSStringFromClass([[NSDictionary dictionary] class]));
  dm_PrintLn(@"[NSMutableArray class]:                         %@", NSStringFromClass([NSMutableArray class]));
  dm_PrintLn(@"[[NSMutableArray array] class]:                 %@\n", NSStringFromClass([[NSMutableArray array] class]));
  dm_PrintLn(@"[NSMutableDictionary class]:                    %@", NSStringFromClass([NSMutableDictionary class]));
  dm_PrintLn(@"[[NSMutableDictionary dictionary] class]:       %@\n", NSStringFromClass([[NSMutableDictionary dictionary] class]));

  dm_PrintLn(@"[[dict valueForKeyPath:@\"emptyArray\"] class]:   %@", NSStringFromClass([[dict valueForKeyPath:@"emptyArray"] class]));
#endif

  dm_PrintLn(@"Exemplar of what normal NSContainer descriptions look like:");
  dm_PrintLn(@"%@", dict);

  NSError * error;
  [NSObject fs_swizzleContainerPrinters:&error];
  if (error) dm_PrintLn(@"%@", error);

  dm_PrintLn(@"What the swizzled output looks like:");
  dm_PrintLn(@"%@", dict);

  return 0;
}}

void dm_PrintLn(NSString *format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    NSString* s0 = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    printf("%s\n", [s0 UTF8String]);
}
