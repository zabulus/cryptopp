SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET SolutionDir=%CD%\

RD /s /q .\Win32
RD /s /q .\x64

CALL :Build 
CALL :Build "CRYPTOPP_NO_UNALIGNED_DATA_ACCESS"
CALL :Build "NO_OS_DEPENDENCE"
CALL :Build "CRYPTOPP_USE_FIPS_202_SHA3"
CALL :Build "CRYPTOPP_NO_UNALIGNED_DATA_ACCESS;NO_OS_DEPENDENCE"
CALL :Build "CRYPTOPP_NO_UNALIGNED_DATA_ACCESS;CRYPTOPP_USE_FIPS_202_SHA3"
CALL :Build "NO_OS_DEPENDENCE;CRYPTOPP_USE_FIPS_202_SHA3"
CALL :Build "CRYPTOPP_NO_UNALIGNED_DATA_ACCESS;NO_OS_DEPENDENCE;CRYPTOPP_USE_FIPS_202_SHA3"

:Build
SETLOCAL

msbuild cryptopp.proj /t:BuildAll /verbosity:m /p:"PreprocessorDefinitions=%1"
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

ENDLOCAL
