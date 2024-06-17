# Microsoft Visual C++ generated build script - Do not modify

PROJ = 1MBFORT
DEBUG = 0
PROGTYPE = 0
CALLER = 
ARGS = 9000
DLLS = 
D_RCDEFINES = 
R_RCDEFINES = 
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = C:\1MBFORT\
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = 1MBFORT.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE = /nologo /YX /G2 /Zp1 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE = /nologo /YX /G2 /Zp1 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE = /NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE = /NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew LIBW 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew LIBW 
RCFLAGS = /NOLOGO  
RESFLAGS = /NOLOGO  -t
RUNFLAGS = 
DEFFILE = 1MBFort.DEF
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WEXE)
LFLAGS = $(LFLAGS_D_WEXE)
LIBS = $(LIBS_D_WEXE)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_WEXE)
LFLAGS = $(LFLAGS_R_WEXE)
LIBS = $(LIBS_R_WEXE)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = 1MBFORT.SBR


1MBFORT_DEP = c:\1MBFort\1MBFort.h


all:	$(PROJ).EXE $(PROJ).BSC

1MBFORT.OBJ:	1MBFORT.C $(1MBFORT_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c 1MBFORT.C

1MBFORT.RES:	1MBFORT.RC $(1MBFORT_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r 1MBFORT.RC


$(PROJ).EXE::	1MBFORT.RES

$(PROJ).EXE::	1MBFORT.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF1MBFORT.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
f:\msvc\lib\+
f:\msvc\mfc\lib\+
d:\msvc\lib\+
d:\msvc\mfc\lib\+
d:\c\lib\+
d:\c\mfc\lib\+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) 1MBFort.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	1MBFORT.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) 1MBFort.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
