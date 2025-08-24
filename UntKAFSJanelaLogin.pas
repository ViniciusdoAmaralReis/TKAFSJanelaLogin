unit UntKAFSJanelaLogin;

interface

uses
  System.Classes, System.SysUtils, System.Threading, System.UITypes,
  FMX.Forms, FMX.Graphics, FMX.Layouts, FMX.Objects, FMX.StdCtrls, FMX.Types,
  UntKAFSJanelaModal, UntKAFSLoginGoogle, UntKAFSTelaProgresso;

type
  TKAFSJanelaLogin = class(TKAFSJanelaModal)
    ScbCorpo: TScrollBox;
    ImgUsuario: TImage;
    LabEmail: TLabel;
  public
    TelaProgresso: TKAFSTelaProgresso;
    LoginGoogle: TKAFSLoginGoogle;
    ClientIDGoogle: String;
    ClientSecretGoogle: String;
    Dados: TNotifyEvent;
    AposLogin: TNotifyEvent;
    Finalizar: Boolean;

    constructor Create(AOwner: TComponent); override;
    procedure KAFSJanelaLoginConfig(const _cortema1, _cortema2: TAlphaColor; _imgusuario: TBitmap; _clientidgoogle, _clientsecretgoogle: String; _aposlogin: TNotifyEvent);
    procedure Retornar(Sender: TObject);
    procedure Logar(Sender: TObject);
    procedure CancelarLogar(Sender: TObject);
    procedure ConfirmarDeslogar(Sender: TObject);
    procedure Deslogar(Sender: TObject);
    destructor Destroy; override;
  end;

implementation

uses
  UntKAFSFuncoes, UntKAFSTelaMensagem;

constructor TKAFSJanelaLogin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ScbCorpo := TScrollBox.Create(Self);
  with ScbCorpo do
  begin
    Align := TAlignLayout.Client;
    Parent := RecCorpo;
  end;

  ImgUsuario := TImage.Create(Self);
  with ImgUsuario do
  begin
    Align := TAlignLayout.VertCenter;
    Height := 300;
    Parent := ScbCorpo;
    WrapMode := TImageWrapMode.Center;
  end;

  LabEmail := TLabel.Create(Self);
  with LabEmail do
  begin
    Align := TAlignLayout.Client;
    Font.Family := 'Segoe UI Emoji';
    Font.Size := 24;
    Font.Style := [];
    Parent := ImgUsuario;
    StyledSettings := [];
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Trailing;
  end;
end;

procedure TKAFSJanelaLogin.KAFSJanelaLoginConfig(const _cortema1, _cortema2: TAlphaColor; _imgusuario: TBitmap; _clientidgoogle, _clientsecretgoogle: String; _aposlogin: TNotifyEvent);
begin
  // Configura propriedades da tela padrão
  KAFSJanelaModalConfig(_cortema1, _cortema2, 'Usuário', 'Entrar com Google ❯');

  // Associa procedures aos botões
  BtnVoltar.OnClick := Retornar;

  // Texto e cor da fonte
  LabEmail.TextSettings.FontColor := _cortema1;

  // Alimenta variáveis da classe com as chaves fornecidas
  ClientIDGoogle := _clientidgoogle;
  ClientSecretGoogle := _clientsecretgoogle;

  // Assonia o evento que será executado depois do login
  AposLogin := _aposlogin;

  // Se a tela for finalizada, finaliza todo o sistema
  Finalizar := True;

  // Verifica se existe histórico
  var _email := LerIni('cache', 'login', 'email');
  if _email <> '' then
  begin
    // Indica que é uma abertura inicial
    if _imgusuario = nil then
    begin
      AposLogin(nil);

      Free;
    end
    else
    begin
      // Quando a tela for finalizada, finaliza apenas a tela
      Finalizar := False;

      TThread.Synchronize(nil, procedure
      begin
        // Busca o caminho no histórico e converte a imagem da web para bitmap
        ImgUsuario.Bitmap := URLParaBmp(LerIni('cache', 'login', 'imagem'));

        // Busca referência no histórico
        LabEmail.Text := LerIni('cache', 'login', 'email');

        // Muda descrição do botão
        BtnConfirmar.LabDescricao.Text := 'Deslogar ❯';
        BtnConfirmar.OnClick := ConfirmarDeslogar;

        // Torna a tela visível
        Visible := True;
      end);
    end;
  end
  // Não existe um histórico
  else
    TThread.Synchronize(nil, procedure
    begin
      // Configura elementos padrões
      {$IFDEF ANDROID}
      BtnVoltar.Visible := False;
      {$ENDIF}
      ImgUsuario.Bitmap := URLParaBmp('https://imagepng.org/wp-content/uploads/2019/08/google-icon-4.png');
      BtnConfirmar.OnClick := Logar;

      Visible := True;
    end);
end;

procedure TKAFSJanelaLogin.Retornar(Sender: TObject);
begin
  // Se a variável for verdadeira, finaliza o sistema
  if Finalizar then
    Application.MainForm.Close
  else
    Free;
end;

procedure TKAFSJanelaLogin.Logar(Sender: TObject);
begin
  TTask.Run(procedure
  begin
    // Criar tela de progresso
    TelaProgresso := TKAFSTelaProgresso.Create(TFmxObject(Parent));

    // Cria a classe logingoogle
    LoginGoogle := TKAFSLoginGoogle.Create;
    try
      // Atualiza o progresso
      TelaProgresso.Progresso(LabTitulo.FontColor, RecCorpo.Fill.Color, 'Aguardando dados do navegador', 1, 1, CancelarLogar);

      // Variável recebe conteúdo de função login
      var _login := LoginGoogle.Login(ClientIDGoogle, ClientSecretGoogle);

      // Salva dados localmente para login rápido futuro
      SalvarIni('cache', 'login', 'imagem', _login[0]);
      SalvarIni('cache', 'login', 'nome', _login[1]);
      SalvarIni('cache', 'login', 'sobrenome', _login[2]);
      SalvarIni('cache', 'login', 'email', _login[3]);

      // Executa evento pré estabelecido
      TThread.Synchronize(nil, procedure begin AposLogin(nil); end);
    finally
      FreeAndNil(TelaProgresso);
      FreeAndNil(LoginGoogle);
      Free;
    end;
  end);
end;
procedure TKAFSJanelaLogin.CancelarLogar(Sender: TObject);
begin
  // Garante que os objetos sejam liberados
  if Assigned(TelaProgresso) then
    FreeAndNil(TelaProgresso);

  if Assigned(LoginGoogle) then
    FreeAndNil(LoginGoogle);
end;

procedure TKAFSJanelaLogin.ConfirmarDeslogar(Sender: TObject);
begin
  var Mensagem := TKAFSTelaMensagem.Create(Parent);
  Mensagem.KAFSTelaMensagemConfig(
    Labtitulo.FontColor,
    RecCorpo.Fill.Color,
    'Confirmar',
    'Deseja deslogar usuário?',
    '✓',
    Deslogar);
end;
procedure TKAFSJanelaLogin.Deslogar(Sender: TObject);
begin
  // Zera histórico
  SalvarIni('cache', 'login', 'imagem', '');
  SalvarIni('cache', 'login', 'nome', '');
  SalvarIni('cache', 'login', 'sobrenome', '');
  SalvarIni('cache', 'login', 'email', '');

  // Se a tela for finalizada, finaliza todo o sistema
  Finalizar := True;

  // Reseta componentes
  {$IFDEF ANDROID}
  BtnVoltar.Visible := False;
  {$ENDIF}
  ImgUsuario.Bitmap := URLParaBmp('https://imagepng.org/wp-content/uploads/2019/08/google-icon-4.png');
  LabEmail.Text := '';

  with BtnConfirmar do
  begin
    LabDescricao.Text := 'Entrar com Google ❯';

    OnClick := Logar;
  end;
end;

destructor TKAFSJanelaLogin.Destroy;
begin
  CancelarLogar(nil);

  inherited;
end;

end.
