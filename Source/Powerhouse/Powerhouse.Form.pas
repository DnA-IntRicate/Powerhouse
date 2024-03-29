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
  Winapi.Windows, Winapi.ShellAPI, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.SyncObjs,
  Vcl.Forms,
  Powerhouse.Types;

type
  /// <summary>
  /// Typedef for a pointer to a <c>PhForm</c> object.
  /// </summary>
  PhFormPtr = ^PhForm;

  /// <summary>
  /// Typedef for the lambda procedure to be executed in PhForm.GetParentForm().
  /// Since different forms run on different threads; a mutex has to be used to
  /// sync access to the parent form pointer accross different threads to
  /// prevent race-conditions and memory-access violations.
  /// </summary>
  PhOnGetParentProc = reference to procedure(parentPtr: PhFormPtr);

  /// <summary>
  /// Base class for all custom forms in Powerhouse.
  /// </summary>
  PhForm = class(TForm)
  public
    /// <summary>
    /// Enables the form and its controls.
    /// </summary>
    procedure Enable(); virtual;

    /// <summary>
    /// Disables the form and its controls.
    /// </summary>
    procedure Disable(); virtual;

    /// <summary>
    /// Enables the form and shows it as a modal form.
    /// </summary>
    procedure EnableModal(); virtual;

    /// <summary>
    /// Disables the form and closes it as a modal form.
    /// </summary>
    procedure DisableModal(); virtual;

    /// <summary>
    /// Transitions visibilty and control between two forms.
    /// </summary>
    /// <param name="oldForm">
    /// Pointer to the old form.
    /// </param>
    /// <param name="newForm">
    /// Pointer to the new form.
    /// </param>
    procedure TransitionForms(const oldForm, newForm: PhFormPtr); overload;

    /// <summary>
    /// Transitions visibilty and control between two forms.
    /// </summary>s
    /// <param name="newForm">
    /// Pointer to the new form.
    /// </param>
    procedure TransitionForms(const newForm: PhFormPtr); overload;

    /// <summary>
    /// Quits the application.
    /// </summary>
    procedure Quit();

    /// <summary>
    /// Restarts the application.
    /// </summary>
    procedure Restart();

    /// <summary>
    /// Retrieves the parent form using a lambda-callback procedure.
    /// </summary>
    /// <param name="onGetParentProc">
    /// The callback procedure to retrieve the parent form pointer whilst a
    /// mutex lock is acquired on the current thread.
    /// </param>
    procedure GetParentForm(const onGetParentProc: PhOnGetParentProc);

    /// <summary>
    /// Sets the parent form pointer for this form.
    /// </summary
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

procedure PhForm.Restart();
var
  oldHandle: HWND;
begin
  oldHandle := Application.MainFormHandle;
  ShellExecute(0, 'open', PChar(ParamStr(0)), nil, nil, SW_SHOWNORMAL);
  SendMessage(oldHandle, WM_CLOSE, 0, 0);
end;

end.
