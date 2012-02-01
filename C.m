#import "C.h"

@implementation C0
@synthesize ivar0=_ivar0,ivar1=_ivar1,ivar2=_ivar2;
- (NSDictionary *)fs_descriptionDictionary
{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          _ivar0,                                       @"_ivar0",
          [NSNumber numberWithUnsignedLongLong:_ivar1], @"_ivar1",
          _ivar2,                                       @"_ivar2", nil];
}
@end

@implementation C1
- (id)initWithC0:(C0 *)c0
{
  self = [super init];
  if (!self) return nil;

  self.ivar0 = c0.ivar0;
  self.ivar1 = c0.ivar1;
  self.ivar2 = c0.ivar2;

  return self;
}
- (NSString *)description { return [self descriptionWithLocale:nil indent:0]; }
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
  // I'm lazy, so just chain to the dict
  return [[self fs_descriptionDictionary] description];
}
@end
