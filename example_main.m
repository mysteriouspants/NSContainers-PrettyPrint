#import <Foundation/Foundation.h>
#import "NSContainers+DebugPrint.h"
#import "console.h"
#import "C.h"

int main(int argc, char *argv[]) { @autoreleasepool {
  C0 * m0 = [[C0 alloc] init], * m1 = [[C0 alloc] init];

  m0.ivar0 = @"m0: Foobar!";
  m0.ivar1 = 42;
  m0.ivar2 = [NSDictionary dictionaryWithObject:m1 forKey:@"m1"];

  m1.ivar0 = @"Foobar!";
  m1.ivar1 = 1;
  m1.ivar2 = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"Foo", @"Bar", [NSArray array], [NSDictionary dictionary], nil]
                                         forKey:@"arr"];
  
  NSError * error;
  [NSObject fs_swizzleContainerPrinters:&error];
  if (error) dm_PrintLn(@"error: %@", error);

  // printing C0 by default just gives you some odd junk
  dm_PrintLn(@"C0 Standard format print:          %@", m0); // <C0: 0x10c414290>
  // printing the description dictionary gives you something much more useful; notice how
  // the C0 nested in the dictionary is expanded, too!
  dm_PrintLn(@"C0 fs_descriptionDictionary print: %@", [m0 fs_descriptionDictionary]); // {\n    __ivar2 = {...}}
  dm_PrintLn(@"\n");

  // C1 has a method description which just chains to descriptionWithLocale:indent, allowing
  // the default output to be pretty-printed.
  // The inner object in the dictionary is still of type C0, not C1; it will be pretty-printed
  // because of the fs_descriptionDictionary method.
  C1 * m0_1 = [[C1 alloc] initWithC0:m0];

  dm_PrintLn(@"C1 Standard format print: %@", m0_1); // {\n    __ivar2 = {...}}
  // If I didn't use fs_descriptionDictionary, then I could just as easily use objects which all
  // implement descriptionWithLocale:indent: and not worry about it.

  return 0;
} }
