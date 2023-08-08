unit adminRequestControlPage;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, dbConnection, Oracle;
type
  TcontrolRequestsForm = class(TForm)
    requestsTable: TStringGrid;
    filterPanel: TPanel;
    idLabel: TLabel;
    lastNameLabel: TLabel;
    firstNameLabel: TLabel;
    departmentLabel: TLabel;
    filterButton: TButton;
    idBox: TEdit;
    lastNameBox: TEdit;
    firstNameBox: TEdit;
    departmentBox: TEdit;
    resetFilterButton: TButton;
    requestIdBox: TEdit;
    requestIdLabel: TLabel;
    approveRequestPanel: TPanel;
    updateRequestsTableButton: TButton;
    approveRequestButton: TButton;
    denyRequestButton: TButton;
    approveRequestIdBox: TEdit;
    approveByRquestIdLabel: TLabel;
    pendingRequestButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure fillRequestsTable(tableQuery: TOracleQuery);
    procedure filterButtonClick(Sender: TObject);
    procedure resetFilterButtonClick(Sender: TObject);
    procedure approveRequestButtonClick(Sender: TObject);
    procedure denyRequestButtonClick(Sender: TObject);
    procedure updateRequestsTableButtonClick(Sender: TObject);
    procedure pendingRequestButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  controlRequestsForm: TcontrolRequestsForm;
implementation
{$R *.dfm}
procedure TcontrolRequestsForm.filterButtonClick(Sender: TObject);
begin
  if not (Self.idBox.Text = '') then
  begin
    dbConnection.dbForm.requestsFilterQ.SetVariable('id', StrToInt(Self.idBox.Text));
  end
  else
  begin
    dbConnection.dbForm.requestsFilterQ.SetVariable('id', -1);
  end;

  if not (Self.requestIdBox.Text = '') then
  begin
    dbConnection.dbForm.requestsFilterQ.SetVariable('req_id', StrToInt(Self.requestIdBox.Text));
  end
  else
  begin
    dbConnection.dbForm.requestsFilterQ.SetVariable('req_id', -1);
  end;

  if not (Self.departmentBox.Text= '') then
  begin
    dbConnection.dbForm.requestsFilterQ.SetVariable('department', '^' + Self.departmentBox.Text);
  end
  else
  begin
    dbConnection.dbForm.requestsFilterQ.SetVariable('department', '');
  end;

  dbConnection.dbForm.requestsFilterQ.SetVariable('firstname', Self.firstNameBox.Text);
  dbConnection.dbForm.requestsFilterQ.SetVariable('lastname', Self.lastNameBox.Text);
  Self.fillRequestsTable(dbConnection.dbForm.requestsFilterQ);
end;
procedure TcontrolRequestsForm.FormCreate(Sender: TObject);
begin
  Self.requestsTable.Cells[0,0] := 'Request ID';
  Self.requestsTable.Cells[1,0] := 'First Name';
  Self.requestsTable.Cells[2,0] := 'Last Name';
  Self.requestsTable.Cells[3,0] := 'ID';
  Self.requestsTable.Cells[4,0] := 'Department';
  Self.requestsTable.Cells[5,0] := 'Start Date';
  Self.requestsTable.Cells[6,0] := 'End Date';
  Self.requestsTable.Cells[7,0] := 'Priority';
  Self.requestsTable.Cells[8,0] := 'Status';
  Self.requestsTable.ColWidths[0] := 70;
  Self.requestsTable.ColWidths[3] := 60;
  Self.requestsTable.ColWidths[4] := 105;
  Self.requestsTable.ColWidths[5] := 75;
  Self.requestsTable.ColWidths[6] := 75;
  Self.requestsTable.ColWidths[7] := 60;
  Self.fillRequestsTable(dbConnection.dbForm.getRequestsTableQ);
end;

procedure TcontrolRequestsForm.pendingRequestButtonClick(Sender: TObject);
begin
   dbConnection.dbForm.setPendingRequestQ.SetVariable('req_id', StrToInt(Self.approveRequestIdBox.Text));
   dbConnection.dbForm.setPendingRequestQ.Execute;
   dbConnection.dbForm.setPendingRequestQ.Close;
end;
procedure TcontrolRequestsForm.resetFilterButtonClick(Sender: TObject);
begin
   Self.idBox.Text  := '';
   Self.requestIdBox.Text := '';
   Self.firstNameBox.Text := '';
   Self.lastNameBox.Text  := '';
   Self.departmentBox.Text  := '';
   Self.fillRequestsTable(dbConnection.dbForm.getRequestsTableQ);
end;
procedure TcontrolRequestsForm.updateRequestsTableButtonClick(Sender: TObject);
begin
    Self.fillRequestsTable(dbConnection.dbForm.getRequestsTableQ);
end;
procedure TcontrolRequestsForm.approveRequestButtonClick(Sender: TObject);
begin
  dbConnection.dbForm.approveRequestQ.SetVariable('req_id', StrToInt(Self.approveRequestIdBox.Text));
  dbConnection.dbForm.approveRequestQ.Execute;
  dbConnection.dbForm.approveRequestQ.Close;
end;
procedure TcontrolRequestsForm.denyRequestButtonClick(Sender: TObject);
begin
  dbConnection.dbForm.denyRequestQ.SetVariable('req_id', StrToInt(Self.approveRequestIdBox.Text));
  dbConnection.dbForm.denyRequestQ.Execute;
  dbConnection.dbForm.denyRequestQ.Close;
end;
procedure TcontrolRequestsForm.fillRequestsTable(tableQuery: TOracleQuery);
var
  lgetRequestsQuery : TOracleQuery;
  j : integer;
  i : integer;
begin
    lgetRequestsQuery :=  tableQuery;
    lgetRequestsQuery.Execute;
    i := 1;
    Self.requestsTable.RowCount := 1;
    while not lgetRequestsQuery.Eof do
    begin
      Self.requestsTable.RowCount := i+1;
      for j := 0 to 8 do
      begin
        Self.requestsTable.Cells[j,i]  := lgetRequestsQuery.Field(j);
      end;
      i := i+1;
      lgetRequestsQuery.Next;
    end;
    lgetRequestsQuery.Close;
end;


procedure TcontrolRequestsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg ('Are you sure you want to exit?', mtConfirmation,
      [mbYes, mbNo], 0) = mrNo then
    CanClose := False;

    Self.Free;
end;
end.
