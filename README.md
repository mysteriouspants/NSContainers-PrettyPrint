# Pretty Print Cocoa Containers

Due to [a pretty obnoxious behavior in Foundation](http://openradar.appspot.com/10765424), the commonly used containers don't actually allow you to print out pretty descriptions of your own custom objects. This is a dirty ugly hack which gets you that capability.

## In a flash

I swizzle `descriptionWithLocale:indent:` on the *implementation* following classes:

* `NSArray`
* `NSDictionary`
* `NSMutableArray`
* `NSMutableDictionary`

So this means that I swizzle on `[[NSArray array] class]` and not `[NSArray class]`.

## Example

In the output, pay *special attention* to how the object in the dictionary changes after swizzling:

    > ./readme-example 
    Before swizzling:
    {
        _ivar0 = Foo;
        _ivar1 = 42;
        _ivar2 = {
        anotherObject = "{\n    _ivar0 = Bar;\n    _ivar1 = 1;\n    _ivar2 = {\n};\n}";
    };
    }

    After swizzling:
    {
        _ivar0 = Foo;
        _ivar1 = 42;
        _ivar2 = {
        anotherObject =     {
            _ivar0 = Bar;
            _ivar1 = 1;
            _ivar2 = {
    };
        };
    };
    }

### Because code speaks louder than words

From the file `example_for_readme.m`:

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

      dm_PrintLn(@"Before swizzling:");
      dm_PrintLn(@"%@", e);

      NSError * error;
      [NSObject fs_swizzleContainerPrinters:&error];
      if (error) {
        dm_PrintLn(@"Failed to swizzle: %@", error);
        return -1;
      }

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
      char* indent = malloc(sizeof(char)*4*level+1);
      memset(indent, ' ', sizeof(char)*4*level);
      indent[4*level]='\0'; // null terminator for c-string format appends

      [str appendFormat:@"%s{\n",indent];
      [str appendFormat:@"%s    _ivar0 = %@;\n",indent,[_ivar0 fs_stringByEscaping]];
      [str appendFormat:@"%s    _ivar1 = %lu;\n",indent,_ivar1];
      [str appendFormat:@"%s    _ivar2 = %@;\n",indent,_ivar2];
      [str appendFormat:@"%s}",indent];

      free(indent); // no leaking!
      return str;
    }
    - (NSString *)description { return [self descriptionWithLocale:nil indent:0]; }
    @end

## FSDescriptionDict

My custom implementation of `descriptionWithLocale:indent:` does something else that's cool: if an object in an NSContainer conforms to the protocol `FSDescriptionDict`, then the dictionary returned by `fs_descriptionDictionary` is output instead of `description`. For example:

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

It's a little easier to throw together a dictionary than it is to lovingly hand-format all the output. If you don't want to use this functionality, then don't use that protocol in your own custom classes.

## WTF man, why?

I was writing some stuff and I just really wanted to see pretty-printed output from some of my own classes. Nothing more, nothing less. This is a *really quick* sketch, but I believe it's a starting point that you might consider using to expand upon. Things that aren't quite right:

* Well, it hasn't been rigorously tested.
* String escaping isn't all the way there. There's a bunch of control characters which need to be escaped.
* It doesn't order dictionaries the same way that `NSDictionary` does; it's not a big deal, but it'd be nice.