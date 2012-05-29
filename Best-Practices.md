# Best Practices

Generating descriptions is much harder than most folks might think. It
takes careful consideration to arrive at a pattern which is both terse
and sufficiently descriptive. These are my personal recommendations:


## Class Name and Memory Address

Include the memory address and class name of the object. This provides
two important pieces of information which are absolutely essential in
debugging. I suggest using implementations similar to the following:

    - (NSString *)description {
      return [NSString stringWithFormat:@"<%@:%p>",
              NSStringFromClass([self class]),
              (const void *)self];
    }

The class name is absolutely essential in enforcing assumptions about
the type of objects in your code. The memory address is less commonly
useful, except it can become highly useful in situations where
absolutely determining uniqueness of two objects is required (ie.
enforcing that an object was copied and that the copy is in use, not the
original object).


## Short Objects

Smaller objects should have shorter descriptions, preferably all on one
line if at all practical. For example, consider the following contrived
object:

    @implementation FSFoo {
      bool _conflate;
      NSUInteger _bells;
      double _whistles;
    }
    // ...
    - (NSString *)descriptionWithLocale:(id)locale
                                 indent:(NSUInteger)level
    {
      NSString * indent =
        [NSString fs_stringByFillingWithCharacter:' '
                                         repeated:level*4];
      return [NSString stringWithFormat:
              @"%@<%@:%p "
              @"conflate:%@ "
              @"bells:%lu "
              @"whistles:%f>",
              indent,
              NSStringFromClass([self class]),
              (const void *)self,
              _conflate?@"true":@"false", _bells, _whistles];
    }
    @end

    /* Will print out something like this:
     * 
     *    <FSFoo:0xfff8c34f conflate:true bells:3 whistles:4.25>
     */

This is particularly useful in collections of objects, where it will be
emitted like this:

    # printf("%s\n", [[/* some NSArray */ description] UTF8String]);

    (
        <FSFoo:0xfff8c34f conflate:true bells:3 whistles:4.25>,
        <FSFoo:0xfdf333fe conflate:false bells:2 whistles:-42.87>,
        <FSFoo:0xfff8c34f conflate:true bells:3 whistles:4.25>
    )

Right there I can tell that I have a duplicate object in the array, and
the resulting description is easily read.


## Long Objects

The best practice is to not have them, obviously. My recommendation for
printing the description of long objects, or objects which should not
fit on a single line, is to break output items up onto multiple lines,
like this completely contrived example:

    @implementation FSBar {
      NSArray * _foos;
      bool * _shouldNegateConflation;
    }
    // ...
    - (NSString *)descriptionWithLocale:(id)locale
                                 indent:(NSUInteger)level
    {
      NSString * indent =
        [NSString fs_stringByFillingWithCharacter:' '
                                         repeated:level*4];

      return [NSString stringWithFormat:
              @"%@<%@:%p\n"
              @"%@    foos:%@\n"
              @"%@    shouldNegateConflation:%@>",
              indent, NSStringFromClass([self class]),
              (const void*)self,
              [_foos descriptionWithLocale:locale indent:level+2],
              indent, _shouldNegateConflation?@"true":@"false"];
    }
    @end

Notice the newline at the end of the array description! Also note that
the width of a pointer description varies, so trying to align the colons is
useless. Inside the object, I pushed the indentation level up by two in
order to clearly show that all the properties are associated with the
object above. This contraption will emit something to this effect:

    # printf("%s\n", [[/* some NSArray */ description] UTF8String]);

    (
        <FSFoo:0xfff8c34f conflate:true bells:3 whistles:4.25>,
        <FSBar:0xeed239ff
            foos:        (
                <FSFoo:0xfdf333fe conflate:false bells:2 whistles:-42.87>,
                <FSFoo:0x37d94c conflate:true bells:9001 whistles:3.0>
            )
            shouldNegateConflation:true>,
        <FSFoo:0x99ace32 conflate:false bells:4 whistles:42.0>
    )

You'll have to play with each object description in order to ensure that
it performs the way you want and in a way that is most visually
appealing.


## Conditional Compilation

Every feature in NSContainers+PrettyPrint is enabled by setting
compile-time flags, with the exception of the string categories, which
are always compiled. I *highly* suggest that you conditionally-compile
the functionality which depends on NSContainers+PrettyPrint in such a
way that it does *not* compile on release builds, assuming your desired
features do not depend upon NSContainers+PrettyPrint.

So, do not configure Xcode (or whatever builder you happen to be using)
to compile your `descriptionWithLocale:indent:` methods in release
builds, by *not* including either `DEBUGPRINT_ALL` or
`DEBUGPRINT_SWIZZLE` in release mode builds.

After this, wrap your description code like this:

    @implementation FSBaaz {
      // ...
    }
    // ...
    #if defined (DEBUGPRINT_ALL) || defined (DEBUGPRINT_SWIZZLE) || \
        defined (DEBUGPRINT_NSARRAY) || defined (DEBUGPRINT_NSDICTIONARY) \
        defined (DEBUGPRINT_NSSET) || defined (DEBUGPRINT_NSORDEREDSET)
    - (NSString *)descriptionWithLocale:(id)locale
                                 indent:(NSUInteger)level
    {
      // ...
    }
    #endif
    @end

It should make release builds smaller.
