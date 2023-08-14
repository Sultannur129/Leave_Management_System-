unit userPage;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, dbConnection, creatUserPage,
  Vcl.ComCtrls, deleteUserPage, editUserPage, Vcl.ExtCtrls, Oracle, adminRequestControlPage, OleAuto, ComObj;
type
  TuserForm = class(TForm)
    employeesTable: TStringGrid;
    createNewUserButton: TButton;
    updateButton: TButton;
    deleteUserButton: TButton;
    editUserButton: TButton;
    filterPanel: TPanel;
    filterButton: TButton;
    idBox: TEdit;
    firstNameBox: TEdit;
    departmentBox: TEdit;
    idLabel: TLabel;
    lastNameLabel: TLabel;
    firstNameLabel: TLabel;
    departmentLabel: TLabel;
    lastNameBox: TEdit;
    resetFilterButton: TButton;
    showRequestsButton: TButton;
    exportBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure createNewUserButtonClick(Sender: TObject);
    procedure updateButtonClick(Sender: TObject);
    procedure deleteUserButtonClick(Sender: TObject);
    procedure editUserButtonClick(Sender: TObject);
    procedure filterButtonClick(Sender: TObject);
    procedure resetFilterButtonClick(Sender: TObject);
    procedure showRequestsButtonClick(Sender: TObject);
    procedure exportBtnClick(Sender:TObject);

  private
    { Private declarations }
    function checkEmptyBox(filterBox : TEdit): boolean;
  public
    { Public declarations }
    function fillTable(tableQuery: TOracleQuery): boolean;
  end;
type
  TcolumnNames = array [0..5] of string;
var
  userForm: TuserForm;
  columnNames: TcolumnNames;
implementation
{$R *.dfm}

function ExportToExcel(AGrid:TStringGrid;AFileName:String):Boolean;
var
  row,col:Integer;
  lst:TStringList;
  txt:String;
  tnd:String;
  myFile:File;

begin
  lst := TStringList.Create;
  for row := 0 to AGrid.RowCount-1 do
  begin
    txt := '';
    tnd := '';
    for col := 0 to AGrid.ColCount -1 do
    begin
      if col=AGrid.ColCount -1 then tnd := '' else tnd := ';';
      txt := txt + AGrid.Cells[col,row]+tnd;
    end;
    lst.Add(txt);
  end;
  try
    DeleteFile(AFileName);
    lst.SaveToFile(AFileName);
    Result := True;
  except
    Result := False;
  end;
  lst.Free;
end;



  procedure TuserForm.exportBtnClick(Sender: TObject);
    var saveDialog : TSaveDialog;
  begin
       saveDialog := TSaveDialog.Create(self);
       saveDialog.Title := 'Save your csv or excel file';
       saveDialog.InitialDir := GetCurrentDir;
       saveDialog.Filter := 'Csv file|*.csv|Word file|*.doc';
       saveDialog.DefaultExt := 'csv';
       saveDialog.FilterIndex := 1;
       saveDialog.FileName:='Employee.csv';
       if saveDialog.Execute then
       begin

         if ExportToExcel(employeesTable,saveDialog.FileName) then
         begin
         ShowMessage('File Successfully Saved !');
         end
         else
         begin
         ShowMessage('File Saving Error!');
         end;

       end
       else ShowMessage('Save file was cancelled');

      saveDialog.Free;
  end;

   procedure TuserForm.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    Application.Terminate;
  end;


  procedure TuserForm.FormCreate(Sender: TObject);
  begin

    userForm.employeesTable.ColWidths[0] := 60;
    userForm.employeesTable.ColWidths[5] := 300;
    userForm.employeesTable.Cells[0,0] := 'Id';
    userForm.employeesTable.Cells[1,0] := 'First Name';
    userForm.employeesTable.Cells[2,0] := 'Last Name';
    userForm.employeesTable.Cells[3,0] := 'Phone';
    userForm.employeesTable.Cells[4,0] := 'Department';
    userForm.employeesTable.Cells[5,0] := 'E-mail';
    userForm.fillTable(dbConnection.dbForm.employeesTableQ);


  end;



  procedure TuserForm.resetFilterButtonClick(Sender: TObject);
begin
  Self.idBox.Text := '';
  Self.firstNameBox.Text := '';
  Self.lastNameBox.Text := '';
  Self.departmentBox.Text := '';
  userForm.fillTable(dbConnection.dbForm.employeesTableQ);
end;
procedure TuserForm.showRequestsButtonClick(Sender: TObject);
var
    lcontrolRequests :TcontrolRequestsForm;
    begin
      lcontrolRequests := TcontrolRequestsForm.Create(Self);
      lcontrolRequests.BringToFront;
      lcontrolRequests.Name := 'control_requests_form';
      lcontrolRequests.Show;
end;
procedure TuserForm.updateButtonClick(Sender: TObject);
  var
    j: integer;
begin
     userForm.employeesTable.RowCount := 2;
     for j := 0 to 5 do
       begin
         userForm.employeesTable.Cells[j,1] := '';
       end;
     userForm.fillTable(dbConnection.dbForm.employeesTableQ);
end;
procedure TuserForm.createNewUserButtonClick(Sender: TObject);
  var
    lAddUserForm :TcreateNewUser;
    begin
      lAddUserForm := TcreateNewUser.Create(Self);
      lAddUserForm.BringToFront;
      lAddUserForm.Name := 'add_user_form';
      lAddUserForm.Show;
    end;
procedure TuserForm.deleteUserButtonClick(Sender: TObject);
  var
    lDeleteUserForm : TdeleteUser;
  begin
    lDeleteUserForm := TdeleteUser.Create(Self);
    lDeleteUserForm.BringToFront;
    lDeleteUserForm.Name := 'delete_user_form';
    lDeleteUserForm.Show;
  end;

procedure TuserForm.editUserButtonClick(Sender: TObject);
var
  lEditUserForm: TeditUser;
begin
    lEditUserForm := TeditUser.Create(Self);
    lEditUserForm.BringToFront;
    lEditUserForm.Name := 'editUserForm';
    lEditUserForm.Show;
end;
function TuserForm.fillTable(tableQuery: TOracleQuery): boolean;
  var
    i : integer;
    j: integer;
  begin
    try
      with tableQuery do
        begin
           Execute;
        end;
      except
        ShowMessage('Error occured while filling table.');
    end;
    columnNames[0]:='id';
    columnNames[1]:='firstname';
    columnNames[2]:='lastname';
    columnNames[3]:='phone';
    columnNames[4]:='department';
    columnNames[5]:='email';
    userForm.employeesTable.RowCount := 1;
    i := 1;
    while not tableQuery.Eof do
      begin
          userForm.employeesTable.RowCount := i+1;
          for j := 0 to 5 do
          begin
              userForm.employeesTable.Cells[j,i]  := tableQuery.Field(columnNames[j]);
          end;
          i := i+1;
          tableQuery.Next;
      end;
  fillTable := True;
  tableQuery.Close;
  end;


function BuyukHarf(Harf: Char): Char;
begin
  case Harf of
    'ı': Result:='I';
    'ğ': Result:='Ğ';
    'ü': Result:='Ü';
    'ş': Result:='Ş';
    'i': Result:='İ';
    'ö': Result:='Ö';
    'ç': Result:='Ç';
    'İ': Result:='İ';
  else
    Result:=UpCase(Harf);
  end;
end;




function StringUpperTurkish(s:String):String;
var
i:byte;
begin
  for i:=1 to length(s) do s[i]:=BuyukHarf(s[i]);
  StringUpperTurkish := s;
end;


function StringUpper(s:String):String;
var
i:byte;
begin
  for i:=1 to length(s) do s[i]:=UpCase(s[i]);
  StringUpper := s;
end;

procedure TuserForm.filterButtonClick(Sender: TObject);
begin
      if Self.checkEmptyBox(idBox) then
        begin
          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('id', StrToInt('-1'));

        end
      else
        begin
          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('id', StrToInt(Self.idBox.Text));
        end;



       if Self.checkEmptyBox(firstNameBox) then
        begin
          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('firstname', 'None');

        end
       else
        begin
           dbConnection.dbForm.getEmployeeFilterQ.SetVariable('firstname', StringUpperTurkish(Self.firstNameBox.Text));
        end;

       if Self.checkEmptyBox(lastNameBox) then

        begin

          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('lastname', 'None');
        end
       else
        begin
          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('lastname', StringUpperTurkish(Self.lastNameBox.Text));
        end;

       if Self.checkEmptyBox(departmentBox) then
        begin
          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('department', 'None');

        end
       else
        begin
          dbConnection.dbForm.getEmployeeFilterQ.SetVariable('department', StringUpper(Self.departmentBox.Text));
        end;
         
        fillTable(dbConnection.dbForm.getEmployeeFilterQ);
end;
function TuserForm.checkEmptyBox(filterBox : TEdit): boolean;
begin
    if filterBox.Text = '' then
      begin
        checkEmptyBox := True;
      end
     else
      begin
        checkEmptyBox := False;
      end;
end;
end.
