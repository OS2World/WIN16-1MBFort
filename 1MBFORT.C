/****************************************************************************

	1MBFort Version 1.0 Copyright (c) 1995 John McSorley.
	First Published in PC Magazine, March 28, 1995, US Edition

    PROGRAM: 1MBFort.c

    PURPOSE: 1MBFort low order memory fragmenter helps prevent
             "Insufficient memory to start application" errors.

    FUNCTIONS:

    WinMain() - calls initialization function, processes message loop
    InitApplication() - initializes window data and registers window
    InitInstance() - saves instance handle and creates main window
    MainWndProc() - processes messages
	HandleWMCreate() - processes WM_CREATE

    COMMENTS:

        
****************************************************************************/

#include "windows.h"            /* required for all Windows applications */
#include "1MBFort.h"           /* specific to this program          */
#include "string.h"             /*           */
#include "stdlib.h"             /*           */
#include "stdio.h"              /*           */

HANDLE hInst;               /* current instance              */

HANDLE HInstance;


/****************************************************************************

    FUNCTION: WinMain(HANDLE, HANDLE, LPSTR, int)

    PURPOSE: calls initialization function, processes message loop

    COMMENTS:

        Windows recognizes this function by name as the initial entry point
        for the program.  This function calls the application initialization
        routine, if no other instance of the program is running, and always
        calls the instance initialization routine.  It then executes a message
        retrieval and dispatch loop that is the top-level control structure
        for the remainder of execution.  The loop is terminated when a WM_QUIT
        message is received, at which time this function exits the application
        instance by returning the value passed by PostQuitMessage().

        If this function must abort before entering the message loop, it
        returns the conventional value NULL.

****************************************************************************/

int PASCAL WinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
HANDLE hInstance;                /* current instance         */
HANDLE hPrevInstance;            /* previous instance        */
LPSTR lpCmdLine;                 /* command line             */
int nCmdShow;                    /* show-window type (open/icon) */
{
    MSG msg;                     /* message              */

    /* Other instances of app running? */
    if (hPrevInstance) {
    	MessageBox(0,"1MBFort is already running", "1MBFort", MB_OK | MB_ICONEXCLAMATION);
    	return (FALSE);
    }
    

    if (!InitApplication(hInstance)) /* Initialize shared things */
        return (FALSE);      /* Exits if unable to initialize     */

    /* Perform initializations that apply to a specific instance */

    if (!InitInstance(hInstance, nCmdShow))
        return (FALSE);

	HInstance=hInstance;
    
    /* Acquire and dispatch messages until a WM_QUIT message is received. */

    while (GetMessage(&msg,    /* message structure              */
        NULL,          /* handle of window receiving the message */
        NULL,          /* lowest message to examine          */
        NULL))         /* highest message to examine         */
    {
    TranslateMessage(&msg);    /* Translates virtual key codes       */
    DispatchMessage(&msg);     /* Dispatches message to window       */
    }
    return (msg.wParam);       /* Returns the value from PostQuitMessage */
}


/****************************************************************************

    FUNCTION: InitApplication(HANDLE)

    PURPOSE: Initializes window data and registers window class

    COMMENTS:

        This function is called at initialization time only if no other
        instances of the application are running.  This function performs
        initialization tasks that can be done once for any number of running
        instances.

        In this case, we initialize a window class by filling out a data
        structure of type WNDCLASS and calling the Windows RegisterClass()
        function.  Since all instances of this application use the same window
        class, we only need to do this when the first instance is initialized.


****************************************************************************/

BOOL InitApplication(hInstance)
HANDLE hInstance;                  /* current instance       */
{
    WNDCLASS  wc;

    /* Fill in window class structure with parameters that describe the       */
    /* main window.                                                           */

    wc.style = NULL;                    /* Class style(s).                    */
    wc.lpfnWndProc = MainWndProc;       /* Function to retrieve messages for  */
                                        /* windows of this class.             */
    wc.cbClsExtra = 0;                  /* No per-class extra data.           */
    wc.cbWndExtra = 0;                  /* No per-window extra data.          */
    wc.hInstance = hInstance;           /* Application that owns the class.   */
    wc.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_ICON1));
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = GetStockObject(WHITE_BRUSH);
    wc.lpszMenuName =  "1MBFortMenu";   /* Name of menu resource in .RC file. */
    wc.lpszClassName = "1MBFortWClass"; /* Name used in call to CreateWindow. */

    /* Register the window class and return success/failure code. */

    return (RegisterClass(&wc));

}


/****************************************************************************

    FUNCTION:  InitInstance(HANDLE, int)

    PURPOSE:  Saves instance handle and creates main window

    COMMENTS:

        This function is called at initialization time for every instance of
        this application.  This function performs initialization tasks that
        cannot be shared by multiple instances.

        In this case, we save the instance handle in a static variable and
        create and display the main program window.

****************************************************************************/

BOOL InitInstance(hInstance, nCmdShow)
    HANDLE          hInstance;          /* Current instance identifier.       */
    int             nCmdShow;           /* Param for first ShowWindow() call. */
{
    HWND            hWnd;               /* Main window handle.                */

    /* Save the instance handle in static variable, which will be used in  */
    /* many subsequent calls from this application to Windows.            */

    hInst = hInstance;

    /* Create a main window for this application instance.  */

    hWnd = CreateWindow(
        "1MBFortWClass",               /* See RegisterClass() call.          */
        "1MBFort",   			        /* Text for window title bar.         */
        WS_POPUP | WS_CAPTION,          /* Window style.                      */
        CW_USEDEFAULT,                  /* Default horizontal position.       */
        CW_USEDEFAULT,                  /* Default vertical position.         */
        0,                              /* 0 width.                           */
        0,                              /* 0 height.                          */
        NULL,                           /* Overlapped windows have no parent. */
        NULL,                           /* Use the window class menu.         */
        hInstance,                      /* This instance owns this window.    */
        NULL                            /* Pointer not needed.                */
    );

    /* If window could not be created, return "failure" */

    if (!hWnd)
        return (FALSE);

    /* Make the window visible; update its client area; and return "success" */
    ShowWindow(hWnd, nCmdShow);  /* Show the window                        */
    UpdateWindow(hWnd);          /* Sends WM_PAINT message                 */

    return (TRUE);               /* Returns the value from PostQuitMessage */

}

/****************************************************************************

    FUNCTION: HandleWMCreate(HWND, UINT, WPARAM, LPARAM)

    PURPOSE:  Processes Create

    MESSAGES:

    COMMENTS: Here is where the heart of 1MBFort code takes place.
              We read INI file and create fragemented blocks here.


****************************************************************************/

void HandleWMCreate(hWnd, message, wParam, lParam)
HWND hWnd;                      /* window handle                 */
UINT message;                   /* type of message               */
WPARAM wParam;                  /* additional information        */
LPARAM lParam;                  /* additional information        */
{

	int i;
	int totBlks;
	DWORD hBlks[500];
	DWORD hb;
	unsigned int hbret;
	unsigned int bsel;
	unsigned int isize;
	unsigned int nblocks;
	unsigned int iret;
	char sIniFile[255];
	
	char appTitle[80];
	


			/* Get users Windows Directory */
			i=GetWindowsDirectory(sIniFile,254);
			
			/* Add INI filename */
			strcat(sIniFile,"\\1MBFort.INI");
			
			/* Get blocksize or default to -1 */
			isize=GetPrivateProfileInt("1MBFort","BLOCKSIZE",-1 ,sIniFile);
		
			if (isize==-1) {
				
				/* No INI setting so create INI file with default value 10272 */
				iret=WritePrivateProfileString("1MBFort", "INSTRUCTIONS", "Valid BlockSize values 5000 to 20000 no commas.", sIniFile);
				iret=WritePrivateProfileString("1MBFort", "BLOCKSIZE", "10272", sIniFile);
				
				/* Use default blocksize */
				isize=10272;
			
			}
			else
			{ 
				/* Range check user supplied block size */
				if (isize == 0) isize=10272;
				if (isize < 5000) isize=5000;
				if (isize > 20000) isize=20000;
			}			
			
			/* Allocate as many memory blocks as possible */
            i=0;
			hBlks[i]=GlobalDosAlloc(isize);            
			while (hBlks[i]!=0) {
				i++;
				hBlks[i]=GlobalDosAlloc(isize);
			}  
				
			totBlks=i;
			
			/* save number of blocks allocated for later display */
			nblocks=totBlks;
			
			/* display resulting size/blocks */
			sprintf(appTitle,"1MBFort %d/%d",isize - 32,nblocks);
			
			/* set text for task manager display */
			SetWindowText(hWnd, appTitle);
						
			/* shrink blocks so that low order memory is fragmented */
			for (i=0;i<=totBlks;i++) {
				hb=hBlks[i];
				memcpy(&bsel,&hb,2);
				if (bsel!=0) {
					/* reduce blocks to as small as possible */
					/* request 1 byte but will get 32 bytes due to overhead */
					hbret=GlobalReAlloc(bsel,1,0);
				}
			}
				
}

/****************************************************************************

    FUNCTION: MainWndProc(HWND, UINT, WPARAM, LPARAM)

    PURPOSE:  Processes messages

    MESSAGES:

    WM_COMMAND    - application menu 
    WM_DESTROY    - destroy window
	WM_CREATE	  - create 

    COMMENTS:


****************************************************************************/

long CALLBACK __export MainWndProc(hWnd, message, wParam, lParam)
HWND hWnd;                      /* window handle                 */
UINT message;                   /* type of message               */
WPARAM wParam;                  /* additional information        */
LPARAM lParam;                  /* additional information        */
{

    switch (message)
    {

		case WM_CREATE:
		
			HandleWMCreate(hWnd, message, wParam, lParam);

			return (DefWindowProc(hWnd, message, wParam, lParam));
			
			break;			


        case WM_DESTROY:          /* message: window being destroyed */
            PostQuitMessage(0);
            break;

        default:                  /* Passes it on if unproccessed    */
            return (DefWindowProc(hWnd, message, wParam, lParam));
    }
    return (NULL);
}


