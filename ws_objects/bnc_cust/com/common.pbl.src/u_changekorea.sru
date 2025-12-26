$PBExportHeader$u_changekorea.sru
$PBExportComments$한영자동변환(imm32.dll)
forward
global type u_changekorea from userobject
end type
end forward

global type u_changekorea from userobject
integer width = 265
integer height = 160
boolean border = true
userobjects objecttype = externalvisual!
long backcolor = 0
string libraryname = ".imectl32.dll"
long style = 1174405120
long tabtextcolor = 33554432
end type
global u_changekorea u_changekorea

type prototypes
FUNCTION Long ImmGetContext ( Long handle )                             LIBRARY "IMM32.DLL"
FUNCTION Long ImmSetConversionStatus ( Long hIMC, Long fFlag, Long I )  LIBRARY "IMM32.DLL"
FUNCTION Long ImmReleaseContext ( Long handle, Long hIMC )              LIBRARY "IMM32.DLL"

end prototypes

forward prototypes
public subroutine u_changekorea (readonly unsignedinteger hwindow, boolean lmode)
end prototypes

public subroutine u_changekorea (readonly unsignedinteger hwindow, boolean lmode);/*------------------------------------------------------------*/
/* Function Name : f_ChangeKorea                              */
/* Parameter     : unsignedinteger hwindow : Window handle    */
/*                 boolean LMode           : 한/영            */
/* Retrun Value  : (none)                                     */
/* 작   성   자  : M.S.I                                      */
/*------------------------------------------------------------*/

ULong lul_conversion , lul_hic

lul_hic = ImmGetConText(hwindow)

if lmode then 
	lul_conversion = 1
else 
	lul_conversion = 0
end if
ImmSetConversionStatus(lul_hic, lul_conversion, 0)
ImmReleaseConText(hWindow, lul_hic)

end subroutine

on u_changekorea.create
end on

on u_changekorea.destroy
end on

