# Tools

There are a few categories that you can use to make life a lot easier.
All are found in `NSContainers+DebugPrint.h`, and all of them are
compiled at all times, regardless of other configuration. They are
purposed for refactoring common tasks when constructing description
strings, and are available to you for use in your own custom description
string generators (or anywhere else you feel like it).


## NSString+EscapeArtist fs\_stringByEscaping

`fs_stringByEscaping` is a copy-and-modify constructor which seeks to
backslash-escape characters in a way consistent with that of
Foundation's defaults. The behavior is being observed from the following:

    #import <Foundation/Foundation.h>

    int main(int argc, char *argv[]) {
      if (argc != 2) {
        printf("I am terribly sorry sir, but that is not a valid!\n");
        printf("Please invoke like this:\n");
        printf("  esc-behavior \"string here\"\n");
        return -1;
      }
      @autoreleasepool {
        NSArray * procArgs = [[NSProcessInfo processInfo] arguments];
        NSString * string = [procArgs objectAtIndex:1];
        printf("%s\n", [[[NSArray arrayWithObject:string]
                         description] UTF8String]);
      }
      return 0;
    }


## NSString+FilledString

`fs_stringByFillingWithCharacter:repeated:` is a specialized constructor that creates a string of a single character, repeated `times` times. It uses `memset`, so it's safe to assume it's very performant.

`fs_stringByFillingWithString:repeated:` is a specialized constructor
that creates a string of `string` repeated `times` times.


## NSString+ObjectPrinterUtils

The object printer utils are designed to help you implement object
printers that comply to the Best Practices guide. An example use-case
would be:

    @implementation MyObj { size_t _foo; id _bar; }
    - (NSString *)descriptionWithLocale:(id)locale
                                 indent:(NSUInteger)level {
      NSString * indent =
        [NSString fs_stringByFillingWithCharacter:' '
                   repeated:fspp_spacesPerIndent*level];
      NSMutableString * str = [[NSMutableString alloc] init];
      [str fs_appendObjectStartWithIndentString:indent caller:self];
      [str fs_appendObjectPropertyKey:@"foo" value:
            [NSNumber numberWithUnsignedInteger:_foo]
            locale:locale indentLevel:level+1];
      [str fs_appendObjectNewlineWithIndentString:indent];
      [str fs_appendObjectPropertyKey:@"bar" value:_bar
            locale:locale indentLevel:level+1];
      [str fs_appendObjectEnd];
      return str;
    }

    /* will create this: */

    <MyObj:0x7fcff8c189d0 foo: 41
        bar: {
                _class = MyObj;
                _ptr = 0x7fcff8c144a0;
                foo = "3.141593";
            }>

`fs_appendObjectStartWithIndentString:caller:` starts the description,
as like the following:

    <MyObj:0x7fcff8c189d0

`fs_appendObjectPropertyKey:value:locale:indentLevel:` adds a propery to
the output, properly escaping it if it doesn't respond to
`descriptionWithLocale:indent:`, `descriptionWithLocale:`, or
`fs_descriptionDictionary`. It works by adding a single space, the key
name, then the description of the key. Use this without newlines (see
below method) to create descriptions that are all on one line, such as
the following:

    <MyObj:0x7fcff8c189d0 foo: 42 bar: 3.141592654>

`fs_appendObjectNewlineWithIndentString:` takes the output and pops it
down to a new line, which creates the multi-line object description
before shown.

`fs_appendObjectEnd` just appends a `>`.


## NSString+PrettyDict

The dictionary printer helper is to help you print out your own custom
dictionary-style descriptions (as like a plist dictionary). They take
indentation strings that you provide in order to reduce the amount of
string construction taking place. An example use case would be:

    @implementation MyObj { NSNumber * _foo }
    - (NSString *)descriptionWithLocale:(id)locale
                                 indent:(NSUInteger)level {
      NSString * indent =
        [NSString fs_stringByFillingWithCharacter:' '
                   repeated:fspp_spacesPerIndent*level];
      NSMutableString * str = [[NSMutableString alloc] init];
      [str fs_appendDictionaryStartWithIndentString:indent caller:self];
      [str fs_appendDictionaryKey:@"foo" value:_foo locale:locale
            indentString:indent indentLevel:level+1];
      [str fs_appendDictionaryEndWithIndentString:indent];
      return str;
    }
    @end

    /* will create this: */

    {
        _class = MyObj;
        _ptr = 0x10ab14490;
        foo = "3.141593";
    }

`fs_appendDictionaryStartWithIndentString:` is a simple way to quickly
append the opening `{` to the string.

`fs_appendDictionaryStartWithIndentString:caller:` also injects
`_class` and `_ptr`, which are set as the class name and the memory
address of the supplied caller.

`fs_appendDictionaryKey:value:locale:indentString:indentLevel:` adds an
element to the output, properly escaping the string or not depending on
whether it responds to `descriptionWithLocale:indent:`,
`descriptionWithLocale:`, or `fs_descriptionDict`.

`fs_appendDictionaryKey:value:locale:indentString:indentLevel:whitespaceSuppression:`
is the same, but by fiddling with `whitespaceSuppression` you can
override whether or not leading and trailing whitespace will be cut out
of the output. (See the Whitespace Guide for more information on
whitespace suppression).

`fs_appendDictionaryEndWithIndentString:` just closes the dictionary by
appending `}`, prefixed with the proper indentation.


## NSString+Trimmer

Trims leading and trailing newlines from strings. You should use this to
implement custom printers. Note that for some reason this is
conditionally compiled.

`fs_stringByTrimmingWhitespace` just returns a new string without
leading or trailing whitespace.

`fs_stringByTrimmingWhitespaceForType:` returns a new string without
leading or trailing spaces if and only if `fspp_suppressWhitespace` for
that type is `true`. Please see the Whitespace Guide for more
information on that particular topic.
