# Pretty Print Cocoa Containers

Due to [a pretty obnoxious behavior in Foundation](http://openradar.appspot.com/10765424), the commonly used containers don't actually allow you to print out pretty descriptions. This is a dirty ugly hack which gets you that capability.

## In a flash

Rather than swizzle `description`, `descriptionWithLocale:`, and `descriptionWithLocale:indent:`, I decided to implement my own description methods for `NSArray` and `NSDictionary` which sit alongside the defaults. Because code speaks louder than words:

    #import <Foundation/Foundation.h>
    #import "NSContainers+DebugPrint.h"

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

      return 0;
    } }

It's not as terse as usual because of how I had to dance around the default `description` behavior, but it does produce some nice output (this was actually emitted by the example program at `example_main.m`:

    2012-01-30 14:30:19.495 example_main[11095:707] {
        _ivar2 = {
            m1 = {
                _ivar2 = {
                    arr = (
                        Foo,
                        Bar,
                        (),
                        {},
                    ),
                },
                _ivar1 = 1,
                _ivar0 = Foobar!,
            },
        },
        _ivar1 = 42,
        _ivar0 = m0: Foobar!,
    }

## WTF man, why?

I was writing some stuff and I just really wanted to see pretty-printed output from some of my own classes. Nothing more, nothing less. This is a *really quick* sketch, but I believe it's a starting point that you might consider using to expand upon to build your own full-blown drop-in replacement for `description`. If you do, great! Please considering dropping a pull-req to what you did.