#import <Foundation/Foundation.h>
#import "NSContainers+DebugPrint.h"

#import "vendor/JRSwizzle/JRSwizzle.h"

@interface MyObject : NSObject <DescriptionDict>
@property (readwrite, strong) NSString * ivar0;
@property (readwrite, assign) size_t ivar1;
@property (readwrite, strong) NSDictionary * ivar2;
@end

@implementation MyObject
@synthesize ivar0=_ivar0,ivar1=_ivar1,ivar2=_ivar2;
- (NSDictionary *)fs_descriptionDictionary
{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          _ivar0,                                       @"_ivar0",
          [NSNumber numberWithUnsignedLongLong:_ivar1], @"_ivar1",
          _ivar2,                                       @"_ivar2", nil];
}
@end

int main(int argc, char *argv[]) { @autoreleasepool {
  MyObject * m0 = [[MyObject alloc] init], * m1 = [[MyObject alloc] init];

  m0.ivar0 = @"m0: Foobar!";
  m0.ivar1 = 42;
  m0.ivar2 = [NSDictionary dictionaryWithObject:m1 forKey:@"m1"];

  m1.ivar0 = @"Foobar!";
  m1.ivar1 = 1;
  m1.ivar2 = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"Foo", @"Bar", [NSArray array], [NSDictionary dictionary], nil]
                                         forKey:@"arr"];
  
  NSLog(@"%@", [[m0 fs_descriptionDictionary] fs_description]);

  // NSError * error;
  // [NSDictionary jr_swizzleMethod:@selector(descriptionWithLocale:indent:) withMethod:@selector(fs_descriptionWithLocale:indent:) error:&error];

  // NSLog(@"%@", m0);

  return 0;
} }
