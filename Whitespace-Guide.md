# Whitespace and You

By default, NSContainers+PrettyPrint will trim whitespace from
the contents of `NSArray`, `NSDictionary`, `NSSet`, and `NSOrderedSet`.
This creates descriptions which are much shorter and easier to follow.
However, there are some very important considerations that you must
understand to customize this feature or extend it to your own custom
objects.


## Where is trimming performed?

**Whitespace trimming is always performed by the container!**


## How to Perform Whitespace Trimming

You perform it in your own `descriptionWithLocale:indent:` method, like
so:

    - (NSString *)descriptionWithLocale:(id)locale
                                 indent:(NSUInteger)level
    {
      NSMutableString * str = [[NSMutableString alloc] init];
      NSString * indent = [NSString fs_stringByFillingWithCharacter:' '
                                    repeated:fspp_spacesPerIndent*level];
      NSString * sub_indent = [NSString fs_stringByFillingWithCharacter:' '
                                          repeated:fspp_spacesPerIndent];
      
      [str appendFormat:@"%@<%@:%p\n", indent,
        NSStringFromClass([self class]), (const void *)self];
      NSString * ivar_desc = [_ivar descriptionWithLocale:locale
                                                   indent:level+2];
      if (fspp_suppressWhitespace(fspp_object))
        ivar_desc = [ivar_desc stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
      [str appendFormat:@"%@%@ivar: %@>", indent, sub_indent, ivar_desc];

      return str;
    }

    /* Generates: (assuming ivar is an NSArray)
     *
     *     <Foo:0xdeadbeef
     *         ivar: (
     *             bar
     *         )>
     */

*aside:* `sub_indent` is using the global `fspp_spacesPerIndent` to
promulgate the inner padding of the description. This is a configurable
global variable you can use to control the padding for containers. If you
use it in your own description code, then your descriptions will be in-line
with everything else. The default is 4, and you probably won't end up
changing this.
