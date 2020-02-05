# H : STUB
# T : 2020-02-04 (15:27:16)
# A : Levi Perez (equivalently hereafter, "the Author")
# E : <levi@leviperez.dev> or <levianperez@gmail.com>
# D : <Leviathan#2318>

override THIS_MODULE := STUB

# PREAMBLE ####################################################################
#
# This makefile is for compiling the following source(s)...
SRCS := STUB.cpp
# ...using either GNU's C++ Compiler (g++) or LLVM's C++ Compiler (clang++)...
CC := g++
# ...into the executable binary "STUB[.exe]".
#
# This makefile, the local source files it references, the binaries these
# sources may compile into, and any output resulting from executing the code
# from those binaries, are all members of the rather light-hearted series of
# exploratory code samples lovingly titled:
#
#       "C/C++ Spells, Alchemy, and other Necromantic falsIties"
#                 (equivalently hereafter, "SANITIES")
#                 Written and Maintained by Levi Perez
#
# "SANITIES" and its contents have been fully released into the public
# domain, and the Author has selected "The Unlicense" copyright license to
# explicitly declare this. A text file named UNLICENSE or UNLICENSE.md, which
# contains the details of said license, should exist in the same directory as
# this makefile. In case this file cannot be found or easily accessed, all the
# same information and more can be found at the webpage
# <https://unlicense.org>.
###############################################################################


# VALIDATION ##################################################################
ifeq ($(strip $(SRCS)),)
$(error The variable SRCS must not be empty.)
endif

ifeq ($(strip $(CC)),)
$(error The variable CC must not be empty.)
endif
###############################################################################


# BOILERPLATE #################################################################

# L. Perez: "The only good tab is a tab that you can see, that has a printing
#            width of 1 character, and that is NOT the ASCII character #9."
.RECIPEPREFIX := >

# BASIC VPATHS
vpath %.h   inc
vpath %.hpp inc
vpath %.c   src
vpath %.cpp src
vpath %.o   obj
vpath %.a   lib
vpath %.so  lib
vpath %     bin

# TOOLS
RM        := rm -f
RMDIR     := rm -f -r
MKDIR     := mkdir -p
DIFF      := diff --strip-trailing-cr

# STUPID
define NEWLINE


endef

# MANIFESTS
override MANIFEST := $(sort $(subst $(NEWLINE), ,$(file <./MANIFEST)))
override FILTH    := $(sort $(subst $(NEWLINE), ,$(file <./FILTH)))

# FUNCTIONS
stemname   = $(strip $(basename $(notdir $1)))

objname    = $(OBJDIR)/$(call stemname,$1)$(.OBJ)

srcname    = $(SRCDIR)/$(call stemname,$1)$(.SRC)

squelch    = $(foreach warn,$1,-Wno-error=$(warn) -Wno-$(warn) )

inmanifest = $(findstring $1,$(MANIFEST))

isfilth    = $(findstring $1,$(FILTH))

src2obj    = $(CC) $(CFLAGS) $(NOLINK) $(INC) $1 -o $(call objname,$1)

obj2exe    = $(CC) $(CFLAGS) $1 $(LINK) -o $2

verbose    = $(if $(findstring verb,$(ARG)),,@set -e ;)

iverbose   = $(if $(findstring verb,$(ARG)),@set -e ;,)


# CONFIGURATION ###############################################################

# Supplied per-command on the command line:
ARG :=

# PREPROCESSOR DEFINES / UNDEFINES
DEFS     += $(ARG)
UNDEFS   +=
PREPROC  += $(addprefix -D,$(DEFS)) $(addprefix -U,$(UNDEFS))

# EXTENSIONS
.SRC     := $(strip $(suffix $(firstword $(SRCS))))
.EXE     := .exe
.OUT     := .out
.OBJ     := .o

# DIRECTORIES
SRCDIR   := $(dir $(firstword SRCS))
BINDIR   := ./bin
OUTDIR   := ./out
OBJDIR   := ./obj
INCDIRS  +=
LIBDIRS  +=
LINKLIBS +=

# EXECUTABLE & OUTPUT
EXEC     := $(BINDIR)/$(THIS_MODULE)$(.EXE)
OUTFILE  := $(OUTDIR)/$(THIS_MODULE)$(.OUT)
SAMPLE   := ./doc/sample.out

# COMPILER FLAGS
STD      := -std=c++11

WARN     += all extra
WERROR   := -Werror
NOWARN   += unknown-pragmas

NOLINK   := -c
DEBUG    := -g

# SPLICE FLAGS
WARNINGS  = $(addprefix -W,$(WARN)) $(WERROR) $(call squelch,$(NOWARN))
INC       = $(addprefix -I,$(INCDIRS))
LINK      = $(addprefix -L,$(LIBDIRS)) $(addprefix -l,$(LINKLIBS))

# CREATE OBJECTS LIST
OBJS     := $(foreach f,$(SRCS),$(call objname,$f) )

###############################################################################
CFLAGS = $(DEBUG) $(PREPROC) $(STD) $(WARNINGS)
###############################################################################



# RECIPES #####################################################################

# Builds the executable.
$(EXEC) : $(OBJS) | $(BINDIR)
> $(call verbose) $(call obj2exe,$^,$@)
> $(call verbose) echo "$@" >> ./FILTH


# Runs the program and redirects its output to an outfile.
$(OUTFILE) : $(EXEC) | $(OUTDIR)
> $(call verbose) $< > $@
> $(call verbose) echo "$@" >> ./FILTH


# Pattern rule covering any object file prereq:
define object-rule-template
$1 :: $(call srcname,$1) | $(OBJDIR)
> $$(call verbose) $$(call src2obj,$$^)
> $$(call verbose) echo "$$@" >> ./FILTH
endef
# ... and instantiate the above
$(foreach o,$(OBJS),$(eval $(call object-rule-template,$o)))


# Ensures required directories are created first. sort is used to support duplicates.
$(sort $(BINDIR) $(OUTDIR) $(OBJDIR)) :
> $(call verbose) $(MKDIR) $@
# > $(call verbose) echo "$@/" >> ./FILTH



# COMMANDS ####################################################################

.PHONY : help
help :
> @set -e ; echo "  <NFO> Available commands:" ; \
  echo "  <NFO>   - help" ; \
  echo "  <NFO>   - run      (compiles and runs \"$(EXEC)\")" ; \
  echo "  <NFO>   - outfile  (writes your output to \"$(OUTFILE)\")" ; \
  echo "  <NFO>   - printout (prints \"$(OUTFILE)\" to stdout)" ; \
  echo "  <NFO>   - sample   (prints the sample output)" ; \
  echo "  <NFO>   - diff" ; \
  echo "  <NFO>   - pipediff (pipes output directly to diff, no outfile needed)" ; \
  echo "  <NFO>   - verbose  (forces recompile, all flags are echo'd)" ; \
  echo "  <NFO>   - chill    (forces recompile with -Werror disabled)" ; \
  echo "  <NFO>   - check" ; \
  echo "  <NFO>   - clean" ; \
  echo "  <NFO>   - cleaner  (runs clean plus removes empty files/directories)"


.PHONY : list
list : help


.PHONY : run
run : $(EXEC)
> @set -e ; $<


.PHONY : outfile
outfile : $(OUTFILE)


.PHONY : printout
printout : $(OUTFILE)
> @set -e ; cat $<


.PHONY : sample
sample : $(SAMPLE)
> @set -e ; cat $(SAMPLE)


.PHONY : diff
diff : $(OUTFILE) $(SAMPLE)
> $(DIFF) $^


.PHONY : pipediff
pipediff : $(EXEC) $(SAMPLE)
> $(EXEC) | $(DIFF) - $(SAMPLE)


.PHONY : verbose
verbose : ARG := verb
verbose : clean $(EXEC)


.PHONY : chill
chill : WERROR :=
chill : ARG := verb
chill : clean $(EXEC)



ifeq ($(strip $(FILTH)),)
# Either the file ./FILTH does not exist, or it's empty.

.PHONY : clean
clean :
> @set -e ;

else
# The file ./FILTH exists and is not empty.

.PHONY : clean
clean :
> $(call iverbose) $(RM) $(FILTH)
> $(call iverbose) $(RM) ./FILTH

endif


.PHONY : check
check :
> @set -e ; find ./ -print | $(DIFF) - ./MANIFEST


.PHONY : cleaner
cleaner : clean
> @set -e ; find ./ -empty -delete


# COMMANDS (INTERNAL) #########################################################

.PHONY : newmanifest
newmanifest :
> @set -e ; find ./ -fprint ./MANIFEST
> @set -e ; echo "  <NFO> (INTERNAL) Generated new MANIFEST file for module \"$(THIS_MODULE)\"."

.PHONY : newsample
newsample : $(EXEC)
> @set -e ; $< > $(SAMPLE)
> @set -e ; echo "  <NFO> (INTERNAL) Generated new \"$(SAMPLE)\" for module \"$(THIS_MODULE)\"."

###############################################################################
