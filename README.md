# Pretty Print Cocoa Containers

Due to [a pretty obnoxious behavior in Foundation](http://openradar.appspot.com/10765424), the commonly used containers don't actually allow you to print out pretty descriptions of your own custom objects. This is a dirty ugly hack which gets you that capability.

## In a flash

I replace the implementations of `descriptionWithLocale:indent:` on commonly used containers.

## Example

In the output, pay *special attention* to how the object in the dictionary changes after swizzling:

    > ./readme-example 
    Before swizzling:
    {
        _ivar0 = Foo;
        _ivar1 = 42;
        _ivar2 =     {
            anotherObject = "{\n    _ivar0 = Bar;\n    _ivar1 = 1;\n    _ivar2 =     {\n    };\n}";
        };
    }

    After swizzling:
    {
        _ivar0 = Foo;
        _ivar1 = 42;
        _ivar2 =     {
            anotherObject =         {
                _ivar0 = Bar;
                _ivar1 = 1;
                _ivar2 =             {
                };
            };
        };
    }

*Because I switched from swizzling to replacing based on build flags, it's no longer possible to toggle this functionality on and off.*

### How to enable

This is turned on by use of defines created by compiler flags. For example, if I wanted to turn everything on, I'd add the `-DDEBUGPRINT_ALL` flag to my build settings.

* `DEBUGPRINT_ALL`: `NSArray`, `NSMutableArray`, `NSDictionary`, `NSMutableDictionary`, `NSSet`, `NSMutableSet`
* `DEBUGPRINT_NSARRAY`: `NSArray`, `NSMutableArray`
* `DEBUGPRINT_NSDICTIONARY`: `NSDictionary`, `NSMutableDictionary`
* `DEBUGPRINT_NSSET`: `NSSet`, `NSMutableSet`

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

I like my objects formatted nicely when they print out to the console. It helps when debugging applications.