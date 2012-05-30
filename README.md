# Pretty Print Cocoa Containers

Due to [a pretty obnoxious behavior in Foundation](http://openradar.appspot.com/10765424),
the commonly used containers don't actually allow you to print
out pretty descriptions of your own custom objects. This is a
dirty ugly hack which gets you that capability.


## In a flash

I replace the implementations of `descriptionWithLocale:indent:`
on commonly used containers.


## Example

In the output, pay *special attention* to how the object in the
dictionary changes after swizzling:

    Before swizzling:
    <ExObj:0x7fc098415140
        _ivar0 = Foo
        _ivar1 = 42
        _ivar2 = {
                anotherObject = "<ExObj:0x7fc098414d80\n    _ivar0 = Bar\n    _ivar1 = 1\n    _ivar2 = {\n        }>";
            }>

    After swizzling:
    <ExObj:0x7fc098415140
        _ivar0 = Foo
        _ivar1 = 42
        _ivar2 = {
                anotherObject = <ExObj:0x7fc098414d80
                    _ivar0 = Bar
                    _ivar1 = 1
                    _ivar2 = {
                        }>;
            }>    


### How to enable

This is turned on by use of defines created by compiler flags. For
example, if I wanted to turn everything on, I'd add the
`-DDEBUGPRINT_ALL` flag to my build settings.

* `DEBUGPRINT_ALL`: `NSArray`, `NSMutableArray`, `NSDictionary`,
  `NSMutableDictionary`, `NSSet`, `NSMutableSet`, `NSOrderedSet`,
  `NSMutableOrderedSet`
* `DEBUGPRINT_NSARRAY`: `NSArray`, `NSMutableArray`
* `DEBUGPRINT_NSDICTIONARY`: `NSDictionary`, `NSMutableDictionary`
* `DEBUGPRINT_NSSET`: `NSSet`, `NSMutableSet`
* `DEBUGPRINT_NSORDEREDSET`: `NSOrderedSet`, `NSMutableOrderedSet`

Alternatively, if you want to include the JRSwizzle library, you can
swizzle the changes in an out at runtime:

* `DEBUGPRINT_SWIZZLE`: Exposes the `fspp_swizzleContainerPrinters`
  function.

Also, you can use the `DEBUGPRINT_SPACES_PER_INDENT` macro to define how
many spaces per level of indentation. The default is four.


## Whitespace Trimming

By default, whitespace is trimmed from Foundation containers (a distinct
difference from Foundation's default behavior). To illustrate the
difference, consider the following:

    {
        foo =     (
            bar
        );
    }

Notice the whitespace after `foo =`? With whitespace trimming
enabled (as it is by default), that disappears.

    {
        foo = (
            bar
        );
    }

This can make some kinds of descriptions much easier to work with.
Please see the Whitespace guide for more information.

To disable whitespace trimming, use the `DEBUGPRINT_NO_SUPPRESS_WHITESPACE_ALL` macro.


## WTF man, why?

I like my objects formatted nicely when they print out to the
console. It helps when debugging applications.
