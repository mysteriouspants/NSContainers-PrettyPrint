#import <Foundation/Foundation.h>
#import "NSContainers+DebugPrint.h"
#import "console.h"

@interface ExObj : NSObject
@property (readwrite, strong) NSString *     ivar0;
@property (readwrite, assign) size_t         ivar1;
@property (readwrite, strong) NSDictionary * ivar2;
+ (id)exObjWithString:(NSString *)ivar0 uinteger:(size_t)ivar1 dictionary:(NSDictionary *)ivar2;
@end

int main(int argc, char *argv[]) { @autoreleasepool {

  ExObj * e = [ExObj exObjWithString:@"Foo"
      uinteger:42
    dictionary:[NSDictionary dictionaryWithObject:
      [ExObj exObjWithString:@"Bar"
          uinteger:argc
        dictionary:[NSDictionary dictionary]]
                                           forKey:@"anotherObject"]];

  dm_PrintLn(@"\nAfter swizzling:");
  dm_PrintLn(@"%@", e);

  return 0;

} }

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
  NSString * indent = [NSString fs_stringByFillingWithCharacter:' ' repeated:4*level];

  [str appendFormat:@"%@{\n",indent];
  [str appendFormat:@"%@    _ivar0 = %@;\n",indent,[_ivar0 fs_stringByEscaping]];
  [str appendFormat:@"%@    _ivar1 = %lu;\n",indent,_ivar1];
  [str appendFormat:@"%@    _ivar2 = %@;\n",indent,[_ivar2 descriptionWithLocale:locale indent:level+1]];
  [str appendFormat:@"%@}",indent];

  return str;
}
- (NSString *)description { return [self descriptionWithLocale:nil indent:0]; }
@end