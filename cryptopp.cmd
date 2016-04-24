SETLOCAL
SET SolutionDir=%CD%\
msbuild cryptopp.proj /t:BuildLibrary /verbosity:m
if %errorlevel% equ 1 exit /b %errorlevel%
msbuild cryptopp.proj /t:BuildDynamicLibrary /verbosity:m
if %errorlevel% equ 1 exit /b %errorlevel%

FOR %%F IN (Win32\DLL_Output\Debug,Win32\DLL_Output\Release,x64\DLL_Output\Debug,x64\DLL_Output\Release) DO (
	mkdir %%F\TestVectors
	mkdir %%F\TestData
	copy TestVectors %%F\TestVectors
	copy TestData %%F\TestData
	pushd %%F
	cryptest.exe tv all
	if %errorlevel% equ 1 exit /b %errorlevel%
	rem dlltest.exe
	rem if %errorlevel% equ 1 exit /b %errorlevel%
	popd
	RD /s /q %%F
)

FOR %%F IN (Win32\Output\Debug,Win32\Output\Release,x64\Output\Debug,x64\Output\Release) DO (
	mkdir %%F\TestVectors
	mkdir %%F\TestData
	copy TestVectors %%F\TestVectors
	copy TestData %%F\TestData
	pushd %%F
	cryptest.exe tv all
	if %errorlevel% equ 1 exit /b %errorlevel%
	popd
	RD /s /q %%F
)



ENDLOCAL
