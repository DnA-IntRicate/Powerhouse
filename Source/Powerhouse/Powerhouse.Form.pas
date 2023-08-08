{ ----------------------------------------------------------------------------
  MIT License

  Copyright (c) 2023 Adam Foflonker

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  ---------------------------------------------------------------------------- }

unit Powerhouse.Form;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Variants, System.Classes, System.SyncObjs,
  Vcl.Forms,
  Powerhouse.Types;

type
  PhFormPtr = ^PhForm;
  PhOnGetParentProc = reference to procedure(parentPtr: PhFormPtr);

  PhForm = class(TForm)
  public
    procedure Enable(); virtual;
    procedure Disable(); virtual;

    procedure EnableModal(); virtual;
    procedure DisableModal(); virtual;

    procedure TransitionForms(const oldForm, newForm: PhFormPtr); overload;
    procedure TransitionForms(const newForm: PhFormPtr); overload;

    procedure Quit();

    procedure GetParentForm(const onGetParentProc: PhOnGetParentProc);
    procedure SetParentForm(const parentPtr: PhFormPtr);

  protected
    m_Parent: PhFormPtr;
  end;

implementation

procedure PhForm.Enable();
begin
  Self.Enabled := true;
  Self.Show();
end;

procedure PhForm.Disable();
begin
  Self.Hide();
  Self.Enabled := false;
end;

procedure PhForm.EnableModal();
begin
  Self.Enabled := true;
  Self.ShowModal();
end;

procedure PhForm.DisableModal();
begin
  Close();
  Self.Enabled := false;
end;

procedure PhForm.TransitionForms(const oldForm, newForm: PhFormPtr);
begin
  oldForm.Disable();

  newForm.SetParentForm(oldForm);
  newForm.Enable();
end;

procedure PhForm.TransitionForms(const newForm: PhFormPtr);
begin
  TransitionForms(@Self, newForm);
end;

procedure PhForm.GetParentForm(const onGetParentProc: PhOnGetParentProc);
var
  mutex: TMutex;
begin
  mutex := TMutex.Create(nil, false, 'PhForm.GetParentForm_Mutex');

  mutex.Acquire();
  onGetParentProc(m_Parent);
  mutex.Release();
  mutex.Free();
end;

procedure PhForm.SetParentForm(const parentPtr: PhFormPtr);
begin
  m_Parent := parentPtr;
end;

procedure PhForm.Quit();
var
  myPID: DWORD;
  myHandle: THandle;
begin
  myPID := GetCurrentProcessId();
  myHandle := OpenProcess(PROCESS_TERMINATE, false, myPID);

  TerminateProcess(myHandle, 0);
  CloseHandle(myHandle);
end;

end.
