unit frmLivros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  Vcl.ExtCtrls, uDataModule, frmAutores, Vcl.Mask, uCLivros, uREDAPP;

type
 // TEstado = (Leitura, Inclusao, Alteracao);

  TFormLivros = class(TForm)
    edtDescricao: TEdit;
    edtIdLivro: TEdit;
    Panel1: TPanel;
    btnIncluir: TSpeedButton;
    btnAlterar: TSpeedButton;
    btnExcluir: TSpeedButton;
    dbGrid: TDBGrid;
    Panel2: TPanel;
    btnAnterior: TSpeedButton;
    btnProximo: TSpeedButton;
    Panel3: TPanel;
    StaticText2: TStaticText;
    txtData: TStaticText;
    txtHora: TStaticText;
    Panel4: TPanel;
    btnMostrarTudo: TSpeedButton;
    edtDataLog: TMaskEdit;
    edtHoraLog: TMaskEdit;
    btnCancelar: TButton;
    btnSalvar: TButton;
    Panel5: TPanel;
    btnMostrarEditoras: TButton;
    edtIDEditora: TEdit;
    StaticText1: TStaticText;
    procedure carregarTabelasDAO;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnMostrarTudoClick(Sender: TObject);
    procedure btnDataAtualClick(Sender: TObject);
    procedure btnHoraAtualClick(Sender: TObject);
    procedure dbGridCellClick(Column: TColumn);
    procedure dbGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnMostrarEditorasClick(Sender: TObject);

  private
    FLivro: TLivro;
    BotaoAtivado: Boolean;
    FEstado: uREDAPP.TEstado;
    procedure DesbloquearAcoes();
    procedure BloquearAcoes();
    procedure LimparEdits();
    procedure ExibirDataHora();
    procedure OcultarDataHora();
    procedure CriarFormEditoras();
    function ValidarNome: Boolean;
  public
    procedure MostrarLivros();
  end;

var
  idAutorLivro: String;
  idEditora: String;

implementation

uses
  frmEditoras;
{$R *.dfm}

procedure TFormLivros.btnAlterarClick(Sender: TObject);
begin
  FEstado := Alteracao;
  edtDescricao.SetFocus;
  OcultarDataHora();
  Caption := 'Alterando Livros';
  DesbloquearAcoes();
end;

procedure TFormLivros.btnAnteriorClick(Sender: TObject);
begin
  Datamodule1.QueryLivros.Prior;
  carregarTabelasDAO;
end;

procedure TFormLivros.btnCancelarClick(Sender: TObject);
begin
  FEstado := Leitura;
  BloquearAcoes();
  ExibirDataHora();
  Caption := 'Gest�o de Autores e Livros';
  carregarTabelasDAO;
end;

procedure TFormLivros.btnDataAtualClick(Sender: TObject);
begin
  edtDataLog.Text := DateToStr(Date());
end;

procedure TFormLivros.btnExcluirClick(Sender: TObject);
var
  _confirmacao: Integer;
  _LivroDAO: TLivroDAO;
begin
  _LivroDAO := TLivroDAO.Create();
  try
    _confirmacao := MessageDlg('Deseja realmente EXCLUIR?', mtWarning,
      [mbYes, mbNo], 0);

    if _confirmacao = 6 then
    begin
      _LivroDAO.Deletar(StrToInt(edtIdLivro.Text));
      carregarTabelasDAO();
      ShowMessage('Exclu�do com sucesso!');
    end;

  finally
    FreeAndNil(_LivroDAO);
    Datamodule1.QueryLivros.Refresh;
  end
end;

procedure TFormLivros.btnHoraAtualClick(Sender: TObject);
begin
  edtHoraLog.Text := TimeToStr(Time());
end;

procedure TFormLivros.btnIncluirClick(Sender: TObject);
begin
  FEstado := Inclusao;
  edtDescricao.SetFocus;
  Caption := 'Incluindo Livros';
  LimparEdits();
  OcultarDataHora();
  DesbloquearAcoes();
end;

procedure TFormLivros.btnProximoClick(Sender: TObject);
begin
  Datamodule1.QueryLivros.Next;
  carregarTabelasDAO;
end;

procedure TFormLivros.btnSalvarClick(Sender: TObject);
var
  _LivroDAO: TLivroDAO;
  _teste: Boolean;
begin
  _teste := ValidarNome();
  if _teste = true then
  begin
    _LivroDAO := TLivroDAO.Create;
    try
      if FEstado = Inclusao then
      begin
        FLivro := nil;
        FLivro := TLivro.Create();
      end;
      FLivro.Descricao := edtDescricao.Text;
      FLivro.idEditora := StrToInt(edtIDEditora.Text);
      _LivroDAO.Salvar(FLivro);
      Caption := 'Gest�o de Autores e Livros';
      BloquearAcoes();
    finally
      FreeAndNil(_LivroDAO);
      Datamodule1.QueryLivros.Refresh;
      ExibirDataHora();
      ShowMessage('Opera��o Conclu�da com Sucesso!');
    end;
  end;
end;

procedure TFormLivros.DesbloquearAcoes();
begin
  edtIDEditora.ReadOnly := false;
  edtDescricao.ReadOnly := false;
  edtDataLog.ReadOnly := false;
  edtHoraLog.ReadOnly := false;
  btnSalvar.Enabled := true;
  btnCancelar.Enabled := true;
end;

procedure TFormLivros.BloquearAcoes();
begin
  edtIDEditora.ReadOnly := true;
  edtIdLivro.ReadOnly := true;
  edtDescricao.ReadOnly := true;
  edtDataLog.ReadOnly := true;
  edtHoraLog.ReadOnly := true;
  btnSalvar.Enabled := false;
  btnCancelar.Enabled := false;
end;

procedure TFormLivros.ExibirDataHora;
begin
  edtDataLog.Visible := true;
  edtHoraLog.Visible := true;
  txtHora.Visible := true;
  txtData.Visible := true;
end;

procedure TFormLivros.OcultarDataHora;
begin
  edtDataLog.Visible := false;
  edtHoraLog.Visible := false;
  txtHora.Visible := false;
  txtData.Visible := false;
end;

function TFormLivros.ValidarNome: Boolean;
begin
  Result := false;
  if Trim(edtDescricao.Text) = EmptyStr then
  begin
    ShowMessage('Nome do autor est� em branco');
    if edtDescricao.CanFocus then
      edtDescricao.SetFocus;
    Exit;
  end;
  Result := true;
end;

procedure TFormLivros.carregarTabelasDAO;
var
  _idLivro: Integer;
begin
  _idLivro := (Datamodule1.QueryLivros.FieldByName('IdLivro').AsInteger);
  FLivro := TLivroDAO.Carregar(_idLivro);
  edtIdLivro.Text := IntToStr(FLivro.ID);
  edtDescricao.Text := FLivro.Descricao;
  edtDataLog.Text := DateToStr(FLivro.LDataLog);
  edtHoraLog.Text := TimeToStr(FLivro.LHoraLog);
  edtIDEditora.Text := IntToStr(FLivro.idEditora);
end;

procedure TFormLivros.CriarFormEditoras;
var
  _CriarForm: TFormEditoras;
begin
  _CriarForm := TFormEditoras.Create(nil);
  try
    idEditora := edtIDEditora.Text;
    _CriarForm.mostrarEditoras;
    _CriarForm.ShowModal;

  finally
    _CriarForm.Free;
  end;
end;

procedure TFormLivros.dbGridCellClick(Column: TColumn);
var
  _idLivro: Integer;
begin
  _idLivro := Datamodule1.QueryLivros.FieldByName('IdLivro').AsInteger;
  FLivro := TLivroDAO.Carregar(_idLivro);
  edtIdLivro.Text := IntToStr(FLivro.ID);
  edtDescricao.Text := FLivro.Descricao;
  edtDataLog.Text := DateToStr(FLivro.LDataLog);
  edtHoraLog.Text := TimeToStr(FLivro.LHoraLog);
end;

procedure TFormLivros.dbGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_delete then
    Abort;
end;

procedure TFormLivros.btnMostrarEditorasClick(Sender: TObject);
var
  _qry: TFDQuery;
begin
  _qry := TFDQuery.Create(nil);
  _qry.Connection := Datamodule1.FDConnection1;
  try
    CriarFormEditoras;
  finally
    _qry.Free;
  end;

end;

procedure TFormLivros.btnMostrarTudoClick(Sender: TObject);
begin
  if BotaoAtivado = false then
  begin
    Caption := ('Todos os livros');
    btnMostrarTudo.Caption := 'Mostrar Autor';
    Datamodule1.QueryLivros.Active := false;
    Datamodule1.QueryLivros.SQL.Text := 'SELECT * FROM Livros';
    try
      Datamodule1.QueryLivros.Open;
      carregarTabelasDAO;
    except
      MessageDlg('Falha ao consultar o Banco!', mtError, [mbOk], 0);
    end;
    Datamodule1.QueryLivros.FetchAll;
    Datamodule1.QueryLivros.First;
    BotaoAtivado := true;
  end
  else
  begin
    btnMostrarTudo.Caption := 'Mostrar Tudo';
    Caption := ('Livros do Autor');
    MostrarLivros;
    BotaoAtivado := false;
  end;
end;

procedure TFormLivros.MostrarLivros;
begin
  Datamodule1.QueryLivros.Active := false;
  Datamodule1.QueryLivros.SQL.Text :=
    'SELECT * FROM Livros WHERE Livros.idAutor = ' + idAutorLivro;
  try
    Datamodule1.QueryLivros.Open;
    carregarTabelasDAO;
  except
    MessageDlg('Falha ao consultar o Banco!', mtError, [mbOk], 0);
  end;
  Datamodule1.QueryLivros.FetchAll;
  Datamodule1.QueryLivros.First;
end;

procedure TFormLivros.LimparEdits;
begin
  edtIDEditora.Clear;
  edtDescricao.Clear;
  edtIdLivro.Clear;
  edtDataLog.Clear;
  edtHoraLog.Clear;
end;

end.
