#reader(lib "docreader.ss" "scribble")
@require["mz.ss"]

@title{Environment and Runtime Information}

@defproc[(getenv [name string?]) (or/c string? false/c)]{

Gets the value of an operating system environment variable. The
@scheme[name] argument cannot contain a null character; if an
environment variable named by @scheme[name] exists, its value is
returned (as a string); otherwise, @scheme[#f] is returned.}

@defproc[(putenv [name string?][value string?]) boolean?]{

Sets the value of an operating system environment variable. The
@scheme[name] and @scheme[value] arguments are strings that cannot
contain a null character; the environment variable named by
@scheme[name] is set to @scheme[value]. The return value is
@scheme[#t] if the assignment succeeds, @scheme[#f] otherwise.}

@defproc[(system-type [mode (one-of 'os 'gc 'link 'so-suffix 'machine)
                            'os])
         (or/c symbol? string? bytes?)]{

Returns information about the operating system, build mode, or machine
for a running Scheme.

In @scheme['os] mode,
 the possible symbol results are:

@itemize{
@item{@scheme['unix]}
@item{@scheme['windows]}
@item{@scheme['macosx]}
}

In @scheme['gc] mode,
the possible symbol results are:

@itemize{
@item{@scheme['cgc]}
@item{@scheme['3m]}
}

In @scheme['link] mode, the possible symbol results are:

@itemize{
@item{@scheme['static] (Unix)}
@item{@scheme['shared] (Unix)}
@item{@scheme['dll] (Windows)}
@item{@scheme['framework] (Mac OS X)}
}

Future ports of Scheme may expand the list of @scheme['os],
@scheme['gc], and @scheme['link] results.

In @scheme['so-suffix] mode, then the result is a byte string that
represents the file extension used for shared objects on the current
platform. The byte string starts with a period, so it is suitable as a
second argument to @scheme[path-replace-suffix].

In @scheme['machine] mode, then the result is a string, which contains
further details about the current machine in a platform-specific
format.}


@defproc[(system-language+country) string?]{

Returns a string to identify the current user's language and
country.

Under Unix and Mac OS X, the string is five characters: two lowercase
ASCII letters for the language, an underscore, and two uppercase ASCII
letters for the country. Under Windows, the string can be arbitrarily
long, but the language and country are in English (all ASCII letters
or spaces) separated by an underscore.

Under Unix, the result is determined by checking the @envvar{LC_ALL},
@envvar{LC_TYPE}, and @envvar{LANG} environment variables, in that
order (and the result is used if the environment variable's value
starts with two lowercase ASCII letters, an underscore, and two
uppercase ASCII letters, followed by either nothing or a
period). Under Windows and Mac OS X, the result is determined by
system calls.}


@defproc[(system-library-subpath [mode (one-of 'cgc '3m #f)
                                       (system-type 'gc)])
         path?]{

Returns a relative directory path. This string can be used to build
paths to system-specific files. For example, when Scheme is running
under Solaris on a Sparc architecture, the subpath starts
@scheme["sparc-solaris"], while the subpath for Windows on an i386
architecture starts @scheme["win32\\i386"].

The optional @scheme[mode] argument specifies the relevant
garbage-collection variant, which one of the possible results of
@scheme[(system-type 'gc)]: @scheme['cgc] or @scheme['3m]. It can also
be @scheme[#f], in which case the result is independent of the
garbage-collection variant.}


@defproc[(version) (and/c string? immutable?)]{

Returns an string indicating the currently executing version of
Scheme.}


@defproc[(banner) (and/c string? immutable?)]{

Returns an immutable string for Scheme's start-up banner text (or the
banner text for an embedding program, such as MrEd). The banner string
ends with a newline.}


@defproc[(vector-set-performance-stats! [results (and/c vector?
                                                        (not/c immutable?))]
                                        [thd (or/c thread? false/c) #f])
         void?]{

Sets elements in @scheme[results] to report current performance
statistics. If @scheme[thd] is not @scheme[#f], a particular set of
thread-specific statistics are reported, otherwise a different set of
global statics are reported.

For global statistics, up to @math{10} elements are set in the vector,
starting from the beginning. (In future versions of Scheme, additional
elements will be set.) If @scheme[results] has @math{n} elements where
@math{n < 8}, then the @math{n} elements are set to the first @math{n}
performance-statistics values. The reported statistics values are as
follows, in the order that they are set within @scheme[results]:

 @itemize{

  @item{@scheme[0]: The same value as returned by
  @scheme[current-process-milliseconds].}

  @item{@scheme[1]: The same value as returned
  by @scheme[current-milliseconds].}

  @item{@scheme[2]: The same value as returned
  by @scheme[current-gc-milliseconds].}

  @item{@scheme[3]: The number of garbage collections performed since
  start-up.}

  @item{@scheme[4]: The number of thread context switches performed since
  start-up.}

  @item{@scheme[5]: The number of internal stack overflows handled since
  start-up.}

  @item{@scheme[6]: The number of threads currently scheduled for
  execution (i.e., threads that are running, not suspended, and not
  unscheduled due to a synchronization).}

  @item{@scheme[7]: The number of syntax objects read from compiled code
  since start-up.}

  @item{@scheme[8]: The number of hash-table searches performed.}

  @item{@scheme[9]: The number of additional hash slots searched to complete
  hash searches (using double hashing).}

 }

For thread-specific statistics, up to @math{4} elements are set in the
vector:

 @itemize{

  @item{@scheme[0]: @scheme[#t] if the thread is running, @scheme[#f]
  otherwise (same result as @scheme[thread-running?]).}

  @item{@scheme[1]: @scheme[#t] if the thread has terminated,
  @scheme[#f] otherwise (same result as @scheme[thread-dead?]).}

  @item{@scheme[2]: @scheme[#t] if the thread is currently blocked on a
  synchronizable event (or sleeping for some number of milliseconds),
  @scheme[#f] otherwise.}

  @item{@scheme[3]: The number of bytes currently in use for the
  thread's continuation.}

 }
}