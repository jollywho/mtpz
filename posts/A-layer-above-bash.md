<title>A layer above bash</title>
<link rel="stylesheet" href="../css/base.css">
#A layer above bash

navscript is intended to be used with bash. From the start of navscript there has been a design goal to avoid pipes, sockets, language extensions, etc. so that the user can compose simple bash from within nav.

##Commands

The first word in the line is the command that will be run. The rest of the command data is split into words which make the arguments. Similar to Bash, navscript breaks the command line into tokens separated by whitespace (any spaces that are not escaped).

Most commands have an abbreviated alias to make things quicker and shorter.

Many commands support a reverse flag to change the behavior of the command (mainly to reverse or invert where it seems logical). Whichever schema ":Sort" applies to a buffer ":Sort!" will apply a reversed schema to it.

##Variables

    let var = stuff
    echo $var                # => stuff

    let var = 123
    echo $var                # => 123

##Expansions

    echo %f       # fullpath
    echo %t       # type
    echo %d       # dir

##Control Flow

    if %t == 'Image'
      let bno = (vnew img %b)
    elseif %t == 'Document'
      let bno = (vnew dt %f)
    else
      let bno = 0
    en

##User Functions

    fu! test_func()
      echo test
    end

    fu! max(a,b)
      if $a > $b
        return $a
      else
        return $b
      end
    end

    test_func()                # => test
    echo max(1,9)              # => 9
    echo max(nya,nyaaa)        # => nyan

##Statements

The root config file is read line by line into statements. Each statement is a single line unless the end if marked by a '\'.

    let a = [1,2,     \
             3,4]

Statements can be delimited by a '|' to compact short commands together. This is also the only way to run multiline statements in the cmdline.

    if %o:prev | !mpvctl stop | en

Subexpressions are anything inside "()" and the first thing to evaluated in a statement. The output returned is substituted inplace similar to "$()" in Bash.

    echo (echo this (echo merges) togeher)   # => this merges together
    let bno = (vnew img %b)                  # => <buffer id>

##!{cmd}

navscript supports legit inline bash using a '!' flag at the front of a statement instead of a command.

    !for i in %d/*; do echo "$i"; done

The shell flag makes for easy running of external programs but also poses some challenges.

###**_Conflicts_**
navscript expands $vars synonymously with bash. This results in nav expanding all variables before running the statement in Bash. However, if placed inside quotes variables are ignored by navscript (this also applies to other special symbols). 
navscript uses pipes as statement delimiters. these are handled first and before any statement is run, which splits and line of bash using pipes into multiple parts. the change is to make flagged lines use the entire line. then pipes can be used without issue inside a subexpression.

    if 1 | (!echo "bash pipe"   | read invar; echo "$invar") | end
    if 1 | !echo "this is bash" | echo "this isnt"           | end

###**_Output Issue_**

Statements with shell flags return the pid of the first process spawned. This is used within opgroups for tracking and other control mechanisms.

    let movie_pid = !mpv %f
    kill $movie_pid

The STDOUT and STDERR of these processes is stored by nav and viewable from an OUT buffer. There is currently no way to access this information directly within navscript.

The planned method for extracting output from a processes is through expansions.

    echo %0:$movie_pid    # => <stdout for pid#>
    echo %1:$movie_pid    # => <stderr for pid#>

and an await to force an synchronous result.

    let follow_pid = (!tail -f some_log_file)
    echo (await %0+:follow_pid)    # all file descriptors

##Arrays

    let ary = [1,2,3]
    echo $ary                # => [1,2,3]
    echo $ary[0]             # => 1

    let ary[1] = [cat, cow]
    echo $ary                # => [1, [cat, cow], 3]
    echo $ary[1]             # => [cat, cow]
    echo $ary[1][0]          # => cat

#Future

Planned features, not yet implemented.

#####Core concepts
* simple and convenient.
* navscript is not a generic language.
* provide just enough glue to make meaningful Bash (or run in other languages).

##Arithmetic

    let sum = ((5+90))
    let inc = (($inc * 100))
    bd ((%b+1))

##Dictionaries

    let a = {key:val, cat:nyan}
    echo $a[key]                 # => val
    echo $a[cat]                 # => nyan

##Namespaces

Style still to be decided. Very important when writing plugins.

*vim style*

    #some_plugin.nav
    let s:var = 9
    fu! s:func()
    end

    #.navrc
    echo $some_plugin#var
    some_plugin#func()

*python style*

    #some_plugin.nav
    let var = 9
    fu! func()
    end

    #.navrc
    import some_plugin as sp
    echo sp.$var()
    sp.func()

*something other style*


* * *
**2016-06-05**
