; --------- Instellingen -----------
!define APP_NAME "Lucy"
!define APP_VERSION "0.1"
!define INSTALL_EXE "lucy_v0.1.exe"
!define SOURCE_DIR "C:\Users\jules\Desktop\Lucy\Lucy_v0.1"
!define ICON_FILE "${SOURCE_DIR}\lucy.ico"
!define SPLASH_IMAGE "${SOURCE_DIR}\splash.bmp"
!define VERSION_FILE "${SOURCE_DIR}\version.txt"
!define UPDATE_CHECK_URL "https://jouw-url-voor-update.txt"
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH

; --------- Algemene setup -----------
!include "MUI2.nsh"
!include "LogicLib.nsh"

Outfile "LucyInstaller.exe"
InstallDir "$PROGRAMFILES\Lucy"
InstallDirRegKey HKLM "Software\Lucy" "Install_Dir"
RequestExecutionLevel admin
Icon "${ICON_FILE}"
Name "Lucy Installatie"
Caption "Lucy Installatie Wizard"
BrandingText "Lucy ${APP_VERSION}"

; --------- Variables -----------
Var Dialog
Var UpdateCheck

; --------- UI Configuratie -----------
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Weet u zeker dat u de installatie van Lucy wilt afbreken?"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${SPLASH_IMAGE}"
!define MUI_WELCOMEPAGE_TITLE "Welkom bij de Lucy Installatiewizard"
!define MUI_WELCOMEPAGE_TEXT "Deze wizard installeert Lucy ${APP_VERSION} op uw computer."
!define MUI_FINISHPAGE_TITLE "Lucy installatie voltooid"
!define MUI_FINISHPAGE_TEXT "Lucy is succesvol geïnstalleerd op uw computer."
!define MUI_FINISHPAGE_RUN "$INSTDIR\${INSTALL_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "Lucy nu starten"

; Pagina's
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${SOURCE_DIR}\license.txt"
!define MUI_LICENSEPAGE_TEXT_TOP "Dit zijn de gebruiksvoorwaarden voor Lucy. Scroll naar beneden om ze te accepteren."
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
Page custom UpdatePageCreate UpdatePageLeave
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!define MUI_UNCONFIRMPAGE_TEXT_TOP "Lucy zal worden verwijderd van uw computer."
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "Dutch"

; --------- Custom Update Page -----------
Function UpdatePageCreate
  nsDialogs::Create 1018
  Pop $Dialog

  ${If} $Dialog == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 24u "Selecteer installatie opties voor Lucy:"
  ${NSD_CreateCheckBox} 20u 40u 160u 12u "Controleer op updates bij opstarten"
  Pop $UpdateCheck
  ${NSD_SetState} $UpdateCheck ${BST_CHECKED}

  nsDialogs::Show
FunctionEnd

Function UpdatePageLeave
  ${NSD_GetState} $UpdateCheck $0
  ${If} $0 == ${BST_CHECKED}
    WriteRegDWORD HKLM "Software\Lucy" "CheckForUpdates" 1
  ${Else}
    WriteRegDWORD HKLM "Software\Lucy" "CheckForUpdates" 0
  ${EndIf}
FunctionEnd

; --------- Installatie sectie -----------
Section -Main
  SetOutPath $INSTDIR
  
  ; Bestanden kopiëren
  File "${SOURCE_DIR}\${INSTALL_EXE}"
  File "${ICON_FILE}"
  File "${VERSION_FILE}"
  File "${SPLASH_IMAGE}"
  File "${SOURCE_DIR}\license.txt"

  ; Registry instellingen
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "DisplayName" "Lucy"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "DisplayIcon" '"$INSTDIR\lucy.ico"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "Publisher" "Jouw Naam"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "DisplayVersion" "${APP_VERSION}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy" "NoRepair" 1
  WriteRegStr HKLM "Software\Lucy" "Version" "${APP_VERSION}"

  ; Snelkoppelingen
  CreateShortcut "$DESKTOP\Lucy.lnk" "$INSTDIR\${INSTALL_EXE}" "" "$INSTDIR\lucy.ico"
  CreateDirectory "$SMPROGRAMS\Lucy"
  CreateShortcut "$SMPROGRAMS\Lucy\Lucy.lnk" "$INSTDIR\${INSTALL_EXE}" "" "$INSTDIR\lucy.ico"
  CreateShortcut "$SMPROGRAMS\Lucy\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

; --------- Uninstall sectie -----------
Section "Uninstall"
  ; Bestanden verwijderen
  Delete "$INSTDIR\${INSTALL_EXE}"
  Delete "$INSTDIR\lucy.ico"
  Delete "$INSTDIR\version.txt"
  Delete "$INSTDIR\splash.bmp"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\license.txt"

  ; Snelkoppelingen verwijderen
  Delete "$DESKTOP\Lucy.lnk"
  Delete "$SMPROGRAMS\Lucy\Lucy.lnk"
  Delete "$SMPROGRAMS\Lucy\Uninstall.lnk"
  RMDir "$SMPROGRAMS\Lucy"

  ; Registry verwijderen
  DeleteRegKey HKLM "Software\Lucy"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Lucy"

  ; Installatiemap verwijderen
  RMDir /r "$INSTDIR"
  RMDir "$PROGRAMFILES\Lucy"
SectionEnd
