<title>Why another file manager</title>
<link rel="stylesheet" href="../css/base.css">
* * *
#Why another file manager?
_2016-05-30_

nav started out of frustration when dealing with an existing project, Ranger. Written in Python, Ranger is a TUI file manager that does a lot of things right (see below). The current state of alternatives is an unfortunate myriad of abandoned, [unstable](http://vifm.info/) projects, and [bloatware](https://github.com/MidnightCommander/mc) (or [non-terminal](http://docs.xfce.org/xfce/thunar/start)).

##What Ranger Gets Right

* doesn't waste screen space on excess noise like [hints, keybinds, and menus](https://upload.wikimedia.org/wikipedia/commons/9/9b/Midnight_Commander_4.7.0.9_on_Ubuntu_11.04.png)
* files are grouped into panes by directory with appropriate colorschemes
* file assocations are set by config
* an attempt at a VIM-like command line and a modal mapping system
* image display
* maintained and kept to doing one thing well

##What Ranger Gets Wrong

* synchronous, python core
  * blocking UI. frustrating having to wait for everything.
    * cant typeahead
    * just scrolling is very slow
  * redundant stat calls become very slow over network
  * cancel is useless
* forced python. OOP vimlike abomination
* terrible default commands
* useless commandline
  * the utmost minimal autocomplete with no features
* weak mapping system with incorrect keys (classical ncurses limitaton)
* layout is practically static
* opening a shell hides the program, similar to posix jobs
  * no visual hint for shell state
  * no easy way to identify whether a shell is hosting the program
  * plenty of accidents when killing procs
  * plenty of accidents nesting shells
  * have to exit the shell to return
  * cant copy info back and forth
* forced opening style in associations with no state info provided
  * no pid tracking
  * no before/after
  * no singleton enforcement
  * limited program output
  * confusing syntax and flag system
  * confusing hierarchy
  * open menu determined by type
* useful features burried in menus and obscure python quasi-internal code

##The Plugin Issue

Ranger's API is fundamentally anti-VIM. It was a naive attempt to make VIM features in a file manager. Because the entire underlying mechanisms are left customizable to the user no one shares the same core. Plugin development becomes intractable and undesired without a standard API to work against. And those that want to try have to know Python and have to study Ranger's codebase, even if what they want is achievable in a couple lines of a DSL like vimscript.

A better way to design customization is to create core functionality and then expose it to a **stable but highly configurable interface**, paired with an additional layer of strong defaults. The goal is to allow plugins to run as easily as possible without depending upon some specific configuration of the core program made by another plugin.

##The Language Issue

Configuration is desirable not just in scripts but during runtime. Sometimes it is beyond convenient but an actual requirement to be able to change commands inplace--define powerful one-liners as one would in Bash--to accomplish adhoc tasks. 

Editing script files sucks. One has to navigate to the path, find or create the file, remember how scripting works for the program, load up the documentation because one rarely uses it enough to remember, make the changes, reload the file or the whole program depending, and then maybe it works if there were no mistakes. Contrast all that with writing one line in a familiar language, within the program already open, possibly with autocomplete support.

A commandline with a supported language does sound nice. But a mature, general-purpose language sounds even better. Something like Python comes fully developed with a many features and is rigorously tested. It also comes with a tradeoff: any Python used has to be legal Python, which means going back to script files or having a very customized Python DSL. What is gained by picking up a powerful language is lost in problem-specific utility.

Compare:

####DSL
+ [+] in-program scripts on the commandline
+ [+] minimal syntax
+ [+] same as the config
+ [+] tightly paired with the problem domain
- [-] not a generic language
- [-] lacks mature features. have to start from nothing
- [-] language will be 'stringy' and awkward

###Generic Language
+ [+] can choose an already made language
+ [+] powerful, generic
- [-] config different from language
- [-] no commandline
- [-] scripts require files
- [-] bulky interface
- [-] annoying mapping system

Another way to think about the situation: a DSL can always run external scripts or programs if a problem seems too difficult or unrelated. However the inverse is not possible without the above tradeoffs plus some form of IPC.

##nav

nav was created to address the above issues and introduce some modern software engineering techniques to this archaic problem domain. Just having an async core solves a significant number of UI problems. More become manageable with good design.

Many areas of nav remain provisional and only solve known issues shallowly. Ideally, over time development will cover these areas better.
* * *
<div id="footer">
  <a href=../index>Home</a>
</div>
