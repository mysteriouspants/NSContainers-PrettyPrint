#import <Foundation/Foundation.h>

#import "NSContainers+DebugPrint.h"

@interface C0 : NSObject <FSDescriptionDict>
@property (readwrite, strong) NSString * ivar0;
@property (readwrite, assign) size_t ivar1;
@property (readwrite, strong) NSDictionary * ivar2;
@end

// the presence of descriptionWithLocale:indent will cause NSContainers+PrettyPrint
// to use descriptionWithLocale:indent: instead of fs_descriptionDictionary
@interface C1 : C0
- (id)initWithC0:(C0 *)c0;
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
@end
