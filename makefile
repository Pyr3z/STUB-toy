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


# META-MAKING #################################################################
#
# The presence of any file named...
override FILTH := ./FILTH
# ...indicates that this makefile has been executed in some way that created
# new (dirty) files. The command `make clean` removes these generated files,
# and `make cleaner` takes the additional step to remove any resulting empty
# directories.
#
# This project should be packaged with a text file named...
override MANIFEST := ./MANIFEST
# ...which lists the non-hidden files that came in the original package. This
# is used by the `make diffman` command to list any files and directories that
# are not original to the package, meaning this command should come back clean
# both when (A) the package is freshly downloaded, or (B) after running the
# `make cleaner` command. Case (B) might fail if any files or directories NOT
# generated by this makefile are introduced.
#
###############################################################################


# SAMPLE TEXT OUTPUT ##########################################################
#
# If the following text file exists in the MANIFEST and in your filesystem...
SAMPLE := ./doc/sample-out.txt
# ...then it should represent one possible output expected from running this
# module's built executable with the following command line switches:
SAMPLEOPTS :=
#
# The commands to easily run diff using your output and the sample output are
# `make diff` and--if you don't want to generate an outfile--`make pipediff`.
#
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


# EXTENSIONS (Adjust as needed. The auto-deduction isn't necessary.)
# Source files      (.c .cc .cpp)
.SRC     := $(suffix $(firstword $(SRCS)))
# Header files      (.h .hpp)
.INC     := $(if $(subst .cpp,,$(.SRC)),.h,.hpp)
# Inline files      (.inl .ipp .tpp)
.INL     := .ipp
# Dependency files  (.d .mk)
.DEP     := .d
# Preprocess files  (.i .ii .mi)
.PPI     := .i
# Object files      (.o .obj .slo .lo)
.OBJ     := .o
# Static libraries  (.a .lib .la .lai)
.LIB     := .a
# Shared archives   (.a .lib .la .lai)
.SAR     := .a
# Shared objects    (.so .dylib .dll)
.SOB     := .so
# Dynamic objects   (.so .dylib .dll)
.DLL     := .so
# Binary executable (.exe .out)
.BIN     := .exe
# Input data files  (.dat .txt .in)
.DAT     := .dat
# Output files      (.dat .txt .out)
.OUT     := .txt


LANG     := $(if $(subst .c,,$(.SRC)),c++,c)


# DIRECTORIES (Again, this is provided precisely so it can be changed by you to fit you.)
ROOTDIR  := .
SRCDIR   := $(ROOTDIR)/src
DEPDIR   := $(ROOTDIR)/dep
OBJDIR   := $(ROOTDIR)/obj
BINDIR   := $(ROOTDIR)/bin
DATADIR  := $(ROOTDIR)/data
OUTDIR   := $(ROOTDIR)/out
INCDIRS  += $(ROOTDIR)/inc
LIBDIRS  += $(ROOTDIR)/lib


# INTERPRETED VPATHS (Comment out as necessary.)
vpath %$(.SRC) $(SRCDIR)
vpath %$(.INC) $(INCDIRS)
vpath %$(.INL) $(INCDIRS)
vpath %$(.DEP) $(DEPDIR)
vpath %$(.OBJ) $(OBJDIR)
vpath %$(.LIB) $(LIBDIRS)
vpath %$(.SAR) $(LIBDIRS)
vpath %$(.SOB) $(BINDIR)
vpath %$(.DLL) $(BINDIR)
vpath %$(.BIN) $(BINDIR)
vpath %$(.DAT) $(DATADIR)
vpath %$(.OUT) $(OUTDIR)
vpath %        $(ROOTDIR)
vpath %        $(BINDIR)

# FALLBACK VPATHS
# vpath %.h   $(INCDIRS)
# vpath %.hpp $(INCDIRS)
# vpath %.c   $(SRCDIR)
# vpath %.cpp $(SRCDIR)
# vpath %.o   $(OBJDIR)
# vpath %.a   $(LIBDIRS)
# vpath %.so  $(LIBDIRS)
# vpath %     $(BINDIR)


# TOOLS
RM        := rm -f
RMDIR     := rm -f -r
MKDIR     := mkdir -p
DIFF      := diff
DIFF      += --strip-trailing-cr
DIFF      += --ignore-case


# STUPID
define NEWLINE


endef


# SPECIFIED ON COMMAND LINE
ARG       :=

VERBOSE    = $(if $(findstring verbose,$(ARG)),,@set -e ;)
IVERBOSE   = $(if $(findstring verbose,$(ARG)),@set -e ;,)


# GENERIC FUNCTIONS
stemname   = $(strip $(basename $(notdir $1)))

newdirext  = $(addprefix $2/,$(addsuffix $3,$(call stemname,$1)))

squelch    = $(foreach w,$1,-Wno-error=$w -Wno-$w )

anyexists  = $(strip $(wildcard $1))

countexist = $(words $(wildcard $1))


# SPECIFIC FUNCTIONS
srcname    = $(call newdirext,$1,$(SRCDIR),$(.SRC))

depname    = $(call newdirext,$1,$(DEPDIR),$(.DEP))

objname    = $(call newdirext,$1,$(OBJDIR),$(.OBJ))

binname    = $(call newdirext,$1,$(BINDIR),$(.BIN))

src2dep    = $(CC) $(PREPROC) $(INC) -MT '$(call objname,$1)' -MM $1 -MF $2

src2obj    = $(CC) $(CFLAGS) $(NOLINK) $(INC) $1 -o $2

obj2exe    = $(CC) $(CFLAGS) $1 $(LINK) -o $2

src2exe    = $(CC) $(CFLAGS) $(INC) $1 $(LINK) -o $2


# READ META-FILES
override FILTHIES := $(if $(call anyexists,$(FILTH)),$(sort $(subst $(NEWLINE), ,$(file < $(FILTH)))),)


# DETAILED CONFIGURATION ######################################################

# PREPROCESSOR DEFINES / UNDEFINES
DEFS     +=
UNDEFS   +=
PREPROC  += $(addprefix -D,$(DEFS)) $(addprefix -U,$(UNDEFS))


# LINK LIBRARIES
LINKLIBS +=


# COMPILER FLAGS
STD      := -std=$(LANG)11

WARN     += all extra
WERROR   := -Werror
NOWARN   += unknown-pragmas

NOLINK   := -c
DEBUG    := -g


# CREATE INPUT/INTERMEDIATE/OUTPUT LISTS  (CURRENT SCHEMA: MAKE ONE BIN, BIN OUTPUTS ONE FILE)
OBJS     := $(call objname,$(SRCS))
EXEC     := $(BINDIR)/$(THIS_MODULE)$(.BIN)
OUTFILE  := $(OUTDIR)/$(THIS_MODULE)$(.OUT)


# AUTO-INTERPRET CONFIGURATION ################################################

# SPLICE FLAGS
WARNINGS  = $(addprefix -W,$(WARN)) $(WERROR) $(call squelch,$(NOWARN))
INC       = $(addprefix -I,$(INCDIRS))
LINK      = $(addprefix -L,$(LIBDIRS)) $(addprefix -l,$(LINKLIBS))

###############################################################################
CFLAGS = $(DEBUG) $(PREPROC) $(STD) $(WARNINGS)
###############################################################################



# RECIPES #####################################################################

# Builds the executable.
$(EXEC) : $(OBJS) | $(BINDIR)
> $(VERBOSE) $(call obj2exe,$^,$@)
> $(VERBOSE) echo "$@" >> $(FILTH)


# Runs the program and redirects its output to an outfile.
$(OUTFILE) : $(EXEC) | $(OUTDIR)
> $(VERBOSE) $< $(SAMPLEOPTS) > $@
> $(VERBOSE) echo "$@" >> $(FILTH)


# Template rule covering any object file prereq:
define object-rule-template
$1 :: $(call srcname,$1) | $(OBJDIR)
> $$(VERBOSE) $$(call src2obj,$$^,$$@)
> $$(VERBOSE) echo "$$@" >> $$(FILTH)
endef
# ... and instantiate the above
$(foreach o,$(OBJS),$(eval $(call object-rule-template,$o)))


# Ensures required directories are created first. sort is used to support duplicates.
$(sort $(DEPDIR) $(BINDIR) $(OUTDIR) $(OBJDIR)) :
> $(VERBOSE) $(MKDIR) $@



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
  echo "  <NFO>   - diffman  (diffs the filesystem against \"$(MANIFEST)\")" ; \
  echo "  <NFO>   - clean    (removes files make previously created)" ; \
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
> $(VERBOSE) $(DIFF) $^


.PHONY : pipediff
pipediff : $(EXEC) $(SAMPLE)
> $(VERBOSE) $(EXEC) $(SAMPLEOPTS) | $(DIFF) - $(SAMPLE)


.PHONY : verbose
verbose : ARG := verbose
verbose : clean $(EXEC)


.PHONY : chill
chill : WERROR :=
chill : ARG := verbose
chill : clean $(EXEC)



ifeq ($(strip $(FILTHIES)),)
# Either the FILTH file does not exist, or it's empty.

.PHONY : clean
clean :
> @set -e ;

else
# The FILTH file exists and is not empty.

.PHONY : clean
clean :
> $(IVERBOSE) $(RM) $(FILTHIES)
> $(IVERBOSE) $(RM) $(FILTH)

endif


.PHONY : cleaner
cleaner : clean
> @set -e ; find ./ -empty -delete


.PHONY : diffman
diffman :
> @set -e ; find ./ -not -path '*/\.*' -print | $(DIFF) - $(MANIFEST)


# COMMANDS (INTERNAL) #########################################################

.PHONY : newmanifest
newmanifest :
> @set -e ; find ./ -not -path '*/\.*' -fprint $(MANIFEST)
> @set -e ; echo "  <NFO> (INTERNAL) Regenerated \"$(MANIFEST)\" for module \"$(THIS_MODULE)\"."

.PHONY : newsample
newsample : $(EXEC)
> @set -e ; $< $(SAMPLEOPTS) > $(SAMPLE)
> @set -e ; echo "  <NFO> (INTERNAL) Regenerated \"$(SAMPLE)\" for module \"$(THIS_MODULE)\"."

###############################################################################
