unit loginPage;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dbConnection, userPage, leaveRequestPage,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;
type
  TloginForm = class(TForm)
    usernameTextBox: TEdit;
    passwordTextBox: TEdit;
    usernameLabel: TLabel;
    passwordLabel: TLabel;
    loginButton: TButton;
    hititLogoImage: TImage;
    procedure loginButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function checkAdminConnection(username : string): boolean;
  end;
var
  loginForm: TloginForm;
implementation
{$R *.dfm}

procedure TloginForm.loginButtonClick(Sender: TObject);
  var
    control:integer;
    lusername : string;
    lpassword : string;
    lleaveRequestForm : TleaveRequestForm;
  begin
       control:=0;
       //ShowMessage('Click girdi');
       if usernameTextBox.Text <> '' then
       begin
       //ShowMessage('ife girdi');
       //dbConnection.dbForm.OracleSession1.CheckConnection();
       dbConnection.dbForm.userLoginTable.Execute;

       while not dbConnection.dbForm.userLoginTable.Eof do
           begin
              //ShowMessage('While d�ng�ye girdi');
              lusername := dbConnection.dbForm.userLoginTable.Field('username');
              //ShowMessage('username'+lusername);
              lpassword := dbConnection.dbForm.userLoginTable.Field('password');
              if (lusername = usernameTextBox.Text) and (lpassword = passwordTextBox.Text) then
              begin
               control:=1;
               loginPage.loginForm.Hide;
               if Self.checkAdminConnection(lusername) then
                 begin
                   userPage.userForm.Show();
                 end
               else
                 begin
                    lleaveRequestForm := TleaveRequestForm.Create(Self,dbConnection.dbForm.userLoginTable.Field('user_id'));
                    lleaveRequestForm.BringToFront;
                    lleaveRequestForm.Name := 'leave_request_form';
                    lleaveRequestForm.Show;
                 end;
              end;
               dbConnection.dbForm.userLoginTable.Next;
           end;
           if control=0 then
              begin
              ShowMessage('Username or Password is wrong,Please try again!');
              end;


       end;
       dbConnection.dbForm.userLoginTable.Close;
  end;
  function TloginForm.checkAdminConnection(username : string): boolean;
  begin
    if (username = 'admin')  then
    begin
      checkAdminConnection := True;
    end
    else begin
      checkAdminConnection := False;
    end;
  end;

end.

