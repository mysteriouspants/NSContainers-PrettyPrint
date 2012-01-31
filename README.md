# Pretty Print Cocoa Containers

Due to [a pretty obnoxious behavior in Foundation](http://openradar.appspot.com/10765424), the commonly used containers don't actually allow you to print out pretty descriptions. This is a dirty ugly hack which gets you that capability.

## In a flash

I swizzle `descriptionWithLocale:indent:` on the *implementation* following classes:

* `NSArray`
* `NSDictionary`
* `NSMutableArray`
* `NSMutableDictionary`

So this means that I swizzle on `[[NSArray array] class]` and not `[NSArray class]`. Because code speaks louder than words:

    #import <Foundation/Foundation.h>
    #import <stdio.h>

    #import "NSContainers+DebugPrint.h"

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

It's not as terse as usual because of how I had to dance around the default `description` behavior, but it does produce some nice output (this was actually emitted by the example program at `example_main.m`:

    Exemplar of what normal NSContainer descriptions look like:
      // you probably know what this looks like, so I've snipped it

    What the swizzled output looks like:
    {
        "empty dictionary" =     {
        };
        float = "3.141593";
        integer = 42;
        "filled array" =     (
            Foo,
            "Newlines\nAre fun?",
            "I have space but no newline",
                    (
            ),
                    (
                            (
                    foo,
                ),
            ),
                    {
            },
                    {
                bar = foo;
            },
        );
        filledDict =     {
            bar =         {
                bar = foo;
            };
        };
        emptyArray =     (
        );
    }

## FSDescriptionDict

Additionally, if an object in an NSContainer conforms to the protocol `FSDescriptionDict`, then the dictionary returned by `fs_descriptionDictionary` is output instead of `description`. For example:

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
* It doesn't dictionaries the same way that `NSDictionary` does; it's not a big deal, but it'd be nice to get closer to per-byte identicalness to the reference stuff.