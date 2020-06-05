unit frmGestaoAutores;

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
  Vcl.ExtCtrls, uDataModule, Vcl.Mask, uCAutores, uREDAPP, uCLivros, RLReport;

type
  TFormAutores = class(TForm)

    edtNomeAutor: TEdit;
    Panel1: TPanel;
    btnIncluir: TSpeedButton;
    btnAlterar: TSpeedButton;
    btnExcluir: TSpeedButton;
    Panel2: TPanel;
    btnAnterior: TSpeedButton;
    btnProximo: TSpeedButton;
    Panel3: TPanel;
    StaticText2: TStaticText;
    txtData: TStaticText;
    txtHora: TStaticText;
    edtDataLog: TMaskEdit;
    btnSalvar: TButton;
    btnCancelar: TButton;
    ConnInfo: TStaticText;
    edtHoraLog: TMaskEdit;
    edtIdAutor: TEdit;
    DBGrid1: TDBGrid;
    ScrollBox1: TScrollBox;
    PnlLivro: TPanel;
    btnPAlterar: TButton;
    btnPExcluir: TButton;
    edtPNomeLivro: TEdit;
    btnLoadLivros: TButton;
    btnRelatorio: TButton;
    RLReport: TRLReport;
    bndHeader: TRLBand;
    RLLabel1: TRLLabel;
    bndEspaco: TRLBand;
    bndFooter: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLLabel2: TRLLabel;
    RLSystemInfo3: TRLSystemInfo;
    bndDados: TRLBand;
    rlblDescricao: TRLLabel;
    RLDraw1: TRLDraw;
    rlblIdLivro: TRLLabel;
    rlblAutor: TRLLabel;
    bndHeaderDados: TRLBand;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    bndHeaderEditora: TRLBand;
    lblEditora: TRLLabel;
    lblIdEditora: TRLLabel;
    bndLivrosEditora: TRLBand;
    lblCountLivros: TRLLabel;
    bndResultadosFinais: TRLBand;
    ca: TRLLabel;
    lblTotalLivros: TRLLabel;
    lblMediaLivros: TRLLabel;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnVerLivrosClick(Sender: TObject);
    procedure btnDataAtualClick(Sender: TObject);
    procedure btnHoraAtualClick(Sender: TObject);
    procedure dbGridCellClick(Column: TColumn);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure dbGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadLivrosClick(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure rlReportNeedData(Sender: TObject; var MoreData: Boolean);
    procedure rlblDescricaoBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure rlReportPageStarting(Sender: TObject);
    procedure rlReportPageEnding(Sender: TObject);
    procedure rlblIdLivroBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure rlblAutorBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure lblEditoraBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure lblIdEditoraBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure lblCountLivrosBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure lblTotalLivrosBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure caBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure lblMediaLivrosBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);

  private
    FQryRelatorio: TFDQuery;
    check: Boolean;
    ArrPanelAutores: Array of TPanelAutor;
    FEstado: uREDAPP.TEstado;
    FAutor: TAutor;
    qtdeLivrosEditora, qtdeTotalEditoras, qtdeTotalLivros : Integer;
    procedure OcultarBandas();
    procedure PrintarBanda(ABanda: TRLBand);
    procedure ImprimirRelatorio();
    procedure BtnExcluirLivrosClick(Sender: TObject);
    procedure BtnAlterarLivrosClick(Sender: TObject);
    procedure BtnSalvarLivrosClick(Sender: TObject);
    procedure BtnCancelarLivrosClick(Sender: TObject);
    procedure ExibirDataHora();
    procedure OcultarDataHora();
    procedure DesbloquearAcoes();
    procedure BloquearAcoes();
    procedure CriarFormLivros();
    procedure LimparEdits();
    procedure PreencherEditsDAO();
    Function CriarDataModule(): Boolean;
    Function ContarLivros(AIdAutor: Integer): Integer;
    Function CriarQueryRelatorio(): TFDQuery;
  public
    procedure Consultar;

  end;

var
  FormAutores: TFormAutores;

implementation

uses
  frmGestaoLivros, UITypes;
{$R *.dfm}

procedure TFormAutores.btnAlterarClick(Sender: TObject);
begin
  FEstado := Alteracao;
  edtNomeAutor.SetFocus;
  Caption := 'Alterando Autores';
  OcultarDataHora();
  DesbloquearAcoes();
end;

procedure TFormAutores.btnAnteriorClick(Sender: TObject);
begin
  Datamodule1.QueryAutores.Prior;
  PreencherEditsDAO();
end;

procedure TFormAutores.btnCancelarClick(Sender: TObject);
begin
  FEstado := Leitura;
  Caption := 'Gest�o de Autores e Livros';
  BloquearAcoes;
  ExibirDataHora();
  PreencherEditsDAO();
end;

procedure TFormAutores.Consultar();
begin
  try
    Datamodule1.QueryAutores.Active := False;
    Datamodule1.QueryAutores.SQL.Text := 'SELECT * FROM Autores';
    Datamodule1.QueryAutores.Open;
    PreencherEditsDAO();
  except
    MessageDlg('Falha ao consultar o Banco!', mtError, [mbOk], 0);
  end;
  Datamodule1.QueryAutores.FetchAll;
  Datamodule1.QueryAutores.First;
end;

Function TFormAutores.CriarQueryRelatorio(): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Datamodule1.FDConnection1;
  Result.SQL.Text :=
  ' SELECT ' +
    ' * ' +
  ' FROM ' +
   ' Livros ' +
  ' LEFT JOIN ' +
    ' Editoras ON Livros.IdEditora = Editoras.IdEditora ' +
  ' LEFT JOIN ' +
    ' Autores ON Livros.IdAutor = Autores.IdAutor ' +
  ' ORDER BY ' +
    ' Editoras.IdEditora ';
  Result.Open;
  Result.FetchAll;
end;

procedure TFormAutores.btnExcluirClick(Sender: TObject);
var
  _confirmacao, _MsgDlgPositivo: Integer;
begin
  _MsgDlgPositivo := 6;
  try
    _confirmacao := MessageDlg('Deseja realmente EXCLUIR?', mtWarning,
      [mbYes, mbNo], 0);

    if _confirmacao = _MsgDlgPositivo then
    begin
      TAutor.Apagar(StrToInt(edtIdAutor.Text));
      PreencherEditsDAO();
      ShowMessage('Exclu�do com sucesso!');
    end;
  finally
    Datamodule1.QueryAutores.Refresh;
  end;
end;

procedure TFormAutores.btnHoraAtualClick(Sender: TObject);
begin
  edtHoraLog.Text := TimeToStr(Time());
end;

procedure TFormAutores.btnDataAtualClick(Sender: TObject);
begin
  edtDataLog.Text := DateToStr(Date());
end;

procedure TFormAutores.btnIncluirClick(Sender: TObject);
begin
  FEstado := Inclusao;
  edtNomeAutor.SetFocus;
  Caption := 'Incluindo Autores';
  DesbloquearAcoes();
  LimparEdits();
  OcultarDataHora();
end;

procedure TFormAutores.btnProximoClick(Sender: TObject);
begin
  Datamodule1.QueryAutores.Next;
  PreencherEditsDAO();
end;

procedure TFormAutores.btnSalvarClick(Sender: TObject);
begin
  try
    if FEstado = Inclusao then
    begin
      FAutor := nil;
      FAutor := TAutor.Create();
    end;
    FAutor.NomeAutor := edtNomeAutor.Text;
    FAutor.DataLog := Date;
    FAutor.HoraLog := Time;
    TAutor.Gravar(FAutor);

    Caption := 'Gest�o de Autores e Livros';
    BloquearAcoes();
    ExibirDataHora();
  finally
    Datamodule1.QueryAutores.Refresh;
    ShowMessage('Opera��o conclu�da com sucesso!');
  end;
end;

procedure TFormAutores.btnVerLivrosClick(Sender: TObject);
begin
  frmGestaoLivros.idAutorLivro := edtIdAutor.Text;
  CriarFormLivros;
end;

procedure TFormAutores.caBeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin
  AText := 'Total de editoras: ' + qtdeTotalEditoras.ToString;
end;

procedure TFormAutores.DesbloquearAcoes();
begin
  edtNomeAutor.ReadOnly := False;
  edtDataLog.ReadOnly := False;
  edtHoraLog.ReadOnly := False;
  btnSalvar.Enabled := True;
  btnCancelar.Enabled := True;
end;

procedure TFormAutores.FormActivate(Sender: TObject);
begin
  PnlLivro.Free;
  CriarDataModule;
  try
    Datamodule1.FDConnection1.Connected := False;
    ConnInfo.Caption := 'Conectado';
    Consultar();
  except
    raise Exception.Create('[frmAutores]: Erro na conex�o com o banco!');
  end;
end;

procedure TFormAutores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAutor.Free;
end;

procedure TFormAutores.FormDeactivate(Sender: TObject);
begin
  Datamodule1.FDConnection1.Connected := False;
end;

procedure TFormAutores.BloquearAcoes;
begin
  edtIdAutor.ReadOnly := True;
  edtNomeAutor.ReadOnly := True;
  edtDataLog.ReadOnly := True;
  edtHoraLog.ReadOnly := True;
  btnSalvar.Enabled := False;
  btnCancelar.Enabled := False;
end;

procedure TFormAutores.CriarFormLivros;
var
  _CriarForm: TFormLivros;
begin
  _CriarForm := TFormLivros.Create(nil);
  try
    _CriarForm.mostrarLivros;
    _CriarForm.ShowModal;

  finally
    _CriarForm.Free;
  end;
end;

procedure TFormAutores.dbGridCellClick(Column: TColumn);
var
  _idAutor: Integer;
begin
  _idAutor := Datamodule1.QueryAutores.FieldByName('IdAutor').AsInteger;
  FAutor := TAutorDAO.Carregar(_idAutor);
  edtIdAutor.Text := IntToStr(FAutor.id);
  edtNomeAutor.Text := FAutor.NomeAutor;
  edtDataLog.Text := DateToStr(FAutor.DataLog);
  edtHoraLog.Text := TimeToStr(FAutor.HoraLog);
end;

procedure TFormAutores.dbGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_delete then
    Abort;
end;

function TFormAutores.CriarDataModule: Boolean;
begin
  if Datamodule1 = nil then
    Datamodule1 := TDataModule1.Create(application);
  Result := True;
end;

procedure TFormAutores.BtnAlterarLivrosClick(Sender: TObject);
var
  _nomeEdit: String;
  _edit: TEdit;

begin
  FEstado := Alteracao;

  // Foco no edit:
  _nomeEdit := 'edtDescLivro' + TButton(Sender).Tag.ToString;
  _edit := TEdit(ArrPanelAutores[TButton(Sender).Tag].FindComponent(_nomeEdit));
  _edit.SetFocus;

end;

procedure TFormAutores.BtnCancelarLivrosClick(Sender: TObject);
var
  _nomeEdit: String;
  _edit: TEdit;
begin
  FEstado := Leitura;

  // Restaurando edits:
  _nomeEdit := 'edtDescLivro' + TButton(Sender).Tag.ToString;
  _edit := TEdit(ArrPanelAutores[TButton(Sender).Tag].FindComponent(_nomeEdit));
  _edit.Text := ArrPanelAutores[TButton(Sender).Tag].Livro.Descricao;

end;

procedure TFormAutores.BtnExcluirLivrosClick(Sender: TObject);
begin
  ArrPanelAutores[TButton(Sender).Tag].Livro.Apagar();
  ArrPanelAutores[TButton(Sender).Tag].Free;
  ArrPanelAutores[TButton(Sender).Tag] := nil;
end;

procedure TFormAutores.BtnSalvarLivrosClick(Sender: TObject);
var
  _nomeEdit: String;
  _livro: TLivro;
  _edit: TEdit;

begin
  _nomeEdit := 'edtDescLivro' + TButton(Sender).Tag.ToString;
  _edit := TEdit(ArrPanelAutores[TButton(Sender).Tag].FindComponent(_nomeEdit));
  _livro := ArrPanelAutores[TButton(Sender).Tag].Livro;

  _livro.Descricao := _edit.Text;
  _livro.Gravar();

  Caption := 'Gest�o de Autores e Livros';
  ShowMessage('Opera��o Conclu�da com Sucesso!');
end;

procedure TFormAutores.LimparEdits;
begin
  edtIdAutor.Clear;
  edtNomeAutor.Clear;
  edtDataLog.Clear;
  edtHoraLog.Clear;
end;

procedure TFormAutores.ExibirDataHora;
begin
  edtDataLog.Visible := True;
  edtHoraLog.Visible := True;
  txtHora.Visible := True;
  txtData.Visible := True;
end;

procedure TFormAutores.OcultarDataHora;
begin
  edtDataLog.Visible := False;
  edtHoraLog.Visible := False;
  txtHora.Visible := False;
  txtData.Visible := False;
end;

procedure TFormAutores.PreencherEditsDAO();
var
  _idAutor: Integer;
begin
  _idAutor := (Datamodule1.QueryAutores.FieldByName('IdAutor').AsInteger);
  FAutor := TAutorDAO.Carregar(_idAutor);
  edtIdAutor.Text := IntToStr(FAutor.id);
  edtNomeAutor.Text := FAutor.NomeAutor;
  edtDataLog.Text := DateToStr(FAutor.DataLog);
  edtHoraLog.Text := TimeToStr(FAutor.HoraLog);
end;

procedure TFormAutores.btnLoadLivrosClick(Sender: TObject);
var
  _qtdeLivros, I: Integer;
  _btnExcluir, _btnAlterar, _btnSalvar, _btnCancelar: TButton;
  _edt: TEdit;
  _Qry: TFDQuery;

begin
  _Qry := TFDQuery.Create(nil);

  try
    _Qry.Connection := Datamodule1.FDConnection1;
  except
    raise Exception.Create('[FormAutores]: Erro ao se conectar com o Banco!');
  end;

  _Qry.SQL.Text := ('SELECT * FROM Livros Where Livros.IdAutor = ' +
    edtIdAutor.Text);
  _Qry.Open();

  try
    if StrToIntDef(edtIdAutor.Text, 0) <= 0 then
      Exit;

    for I := Low(ArrPanelAutores) to High(ArrPanelAutores) do
    begin
      ArrPanelAutores[I].Free;
    end;
    finalize(ArrPanelAutores);

    _qtdeLivros := ContarLivros(StrToInt(edtIdAutor.Text));
    SetLength(ArrPanelAutores, (_qtdeLivros + 1));

    while not _Qry.Eof do
    begin
      FLivro := TLivroDAO.Carregar(_Qry.FieldByName('IdLivro')
        .Text.ToInteger());
      ArrPanelAutores[_Qry.RecNo] := TPanelAutor.Create(nil);
      ArrPanelAutores[_Qry.RecNo].Livro := FLivro;
      ArrPanelAutores[_Qry.RecNo].Caption := '';
      ArrPanelAutores[_Qry.RecNo].Parent := ScrollBox1;
      ArrPanelAutores[_Qry.RecNo].Height := 50;
      ArrPanelAutores[_Qry.RecNo].Align := alTop;

      with TPanel.Create(ArrPanelAutores[_Qry.RecNo]) do
      begin
        Parent := ArrPanelAutores[_Qry.RecNo];
        Height := 26;
        Caption := '';
        Align := alTop;
      end;

      _edt := TEdit.Create(ArrPanelAutores[_Qry.RecNo]);
      _edt.Parent := ArrPanelAutores[_Qry.RecNo];
      _edt.Name := 'edtDescLivro' + _Qry.RecNo.ToString;
      _edt.Text := _Qry.FieldByName('Descricao').Text;
      _edt.Left := 8;
      _edt.Top := 6;
      _edt.Width := 250;
      _edt.Height := 20;

      _btnExcluir := TButton.Create(ArrPanelAutores[_Qry.RecNo]);
      _btnExcluir.Parent := ArrPanelAutores[_Qry.RecNo];
      _btnExcluir.Caption := 'Excluir';
      _btnExcluir.Align := alRight;
      _btnExcluir.Width := 50;
      _btnExcluir.Height := 10;
      _btnExcluir.Tag := _Qry.RecNo;
      _btnExcluir.OnClick := BtnExcluirLivrosClick;

      _btnAlterar := TButton.Create(ArrPanelAutores[_Qry.RecNo]);
      _btnAlterar.Parent := ArrPanelAutores[_Qry.RecNo];
      _btnAlterar.Caption := 'Alterar';
      _btnAlterar.Align := alRight;
      _btnAlterar.Width := 50;
      _btnAlterar.Height := 10;
      _btnAlterar.Tag := _Qry.RecNo;
      _btnAlterar.OnClick := BtnAlterarLivrosClick;

      _btnSalvar := TButton.Create(ArrPanelAutores[_Qry.RecNo]);
      _btnSalvar.Parent := ArrPanelAutores[_Qry.RecNo];
      _btnSalvar.Caption := 'Salvar';
      _btnSalvar.Align := alRight;
      _btnSalvar.Width := 50;
      _btnSalvar.Height := 10;
      _btnSalvar.Tag := _Qry.RecNo;
      _btnSalvar.OnClick := BtnSalvarLivrosClick;

      _btnCancelar := TButton.Create(ArrPanelAutores[_Qry.RecNo]);
      _btnCancelar.Parent := ArrPanelAutores[_Qry.RecNo];
      _btnCancelar.Caption := 'Cancelar';
      _btnCancelar.Align := alRight;
      _btnCancelar.Width := 50;
      _btnCancelar.Height := 10;
      _btnCancelar.Tag := _Qry.RecNo;
      _btnCancelar.OnClick := BtnCancelarLivrosClick;

      _Qry.Next;
    end;

  finally
    _Qry.Free;
  end;
end;

function TFormAutores.ContarLivros(AIdAutor: Integer): Integer;
var
  _Qry: TFDQuery;
begin
  _Qry := TFDQuery.Create(nil);
  try
    _Qry.Connection := Datamodule1.FDConnection1;
    _Qry.SQL.Text :=
      ('SELECT COUNT(*) AS TOTAL FROM LIVROS WHERE LIVROS.IDAUTOR= ' +
      AIdAutor.ToString);
    _Qry.Open();

    Result := _Qry.FieldByName('TOTAL').Text.ToInteger;

  finally
    _Qry.Free;
  end;

end;

procedure TFormAutores.btnRelatorioClick(Sender: TObject);
begin
  ImprimirRelatorio();
end;

procedure TFormAutores.ImprimirRelatorio;
begin
  check := True;
  RLReport.PreviewModal;
end;

procedure TFormAutores.lblCountLivrosBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := 'Livros da editora: ' + qtdeLivrosEditora.ToString;
end;

procedure TFormAutores.lblEditoraBeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin
  AText := AnsiUppercase(FQryRelatorio.FieldByName('NomeEditora').AsString);
end;

procedure TFormAutores.lblIdEditoraBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := FormatFloat('0##' ,(FQryRelatorio.FieldByName('idEditora').AsInteger)) + ' -';
end;

procedure TFormAutores.lblMediaLivrosBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := 'M�dia de Livros por Editora: ' + (qtdeTotalLivros / qtdeTotalEditoras).ToString;
end;

procedure TFormAutores.lblTotalLivrosBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := 'Total de Livros: ' + qtdeTotalLivros.ToString;;
end;

procedure TFormAutores.rlReportNeedData(Sender: TObject; var MoreData: Boolean);
var
_controleID: Integer;

begin
_controleID := 1;
qtdeLivrosEditora := 0;
qtdeTotalEditoras := 1;
  MoreData := check;
  if MoreData then
  begin
    FQryRelatorio := CriarQueryRelatorio;
    OcultarBandas();
    FQryRelatorio.First;
    PrintarBanda(bndHeaderEditora);
    PrintarBanda(bndHeaderDados);

    while not FQryRelatorio.Eof do
    begin
      if FQryRelatorio.FieldByName('idEditora').AsInteger <> _controleID then
      begin
        PrintarBanda(bndLivrosEditora);
        PrintarBanda(bndEspaco);
        PrintarBanda(bndHeaderEditora);
        PrintarBanda(bndHeaderDados);
        inc(_controleID);
        qtdeLivrosEditora := 0;
        inc(qtdeTotalEditoras);
      end;
      PrintarBanda(bndDados);
      FQryRelatorio.Next;
      inc(qtdeLivrosEditora);
      inc(qtdeTotalLivros);
    end;
     PrintarBanda(bndLivrosEditora);
     PrintarBanda(bndEspaco);
     PrintarBanda(bndResultadosFinais);
  end;

    check := False;
  end;

procedure TFormAutores.rlReportPageEnding(Sender: TObject);
begin
  PrintarBanda(bndFooter);
end;

procedure TFormAutores.rlReportPageStarting(Sender: TObject);
begin
  PrintarBanda(bndHeader);
end;

procedure TFormAutores.rlblAutorBeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin
  AText := AnsiUppercase(FQryRelatorio.FieldByName('NomeAutor').AsString);
end;

procedure TFormAutores.rlblDescricaoBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := AnsiUppercase(FQryRelatorio.FieldByName('Descricao').AsString);
end;

procedure TFormAutores.rlblIdLivroBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := FQryRelatorio.FieldByName('IdLivro').AsString;
end;

procedure TFormAutores.OcultarBandas;
begin
  bndHeader.Visible := False;
  bndHeaderDados.Visible := False;
  bndEspaco.Visible := False;
  bndFooter.Visible := False;
end;

procedure TFormAutores.PrintarBanda(ABanda: TRLBand);
begin
  ABanda.Visible := True;
  RLReport.PrintBand(ABanda);
  ABanda.Visible := False;
end;

end.
