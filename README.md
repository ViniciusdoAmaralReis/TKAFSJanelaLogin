# 🚀 TKAFSJanelaLogin

Componente Delphi/FireMonkey para autenticação de usuários com suporte a login via Google OAuth em aplicações multiplataforma.

## 📋 Descrição

Componente especializado em gerenciar autenticação de usuários em aplicações Delphi/FireMonkey, com integração nativa ao Google OAuth 2.0, interface personalizável e persistência de sessão.

## ✨ Características

- ✅ Autenticação integrada com Google OAuth 2.0
- ✅ Interface responsiva adaptada para Windows e Android
- ✅ Persistência de sessão com cache local
- ✅ Tela de progresso durante o processo de login
- ✅ Suporte multiplataforma (Windows, Android)
- ✅ Cores totalmente personalizáveis
- ✅ Imagem de perfil do usuário
- ✅ Logout com limpeza de dados sensíveis

## 🛠️ Configuração

### Parâmetros Padrão

```
Layout: Modal centralizado com imagem de usuário e email
Autenticação: Integração com Google OAuth 2.0
Persistência: Armazenamento local de dados de sessão
Fonte do email: Segoe UI Emoji 24px
```

## 📦 Como Usar

### Instanciação e Configuração

```pascal
var
  JanelaLogin: TKAFSJanelaLogin;
begin
  JanelaLogin := TKAFSJanelaLogin.Create(Self);
  try
    JanelaLogin.KAFSJanelaLoginConfig(
      TAlphaColors.White,           // Cor do texto
      TAlphaColors.Blue,            // Cor de fundo
      nil,                          // Bitmap do usuário (opcional)
      'seu-client-id-google',       // Client ID do Google
      'seu-client-secret-google',   // Client Secret do Google
      MeuEventoAposLogin            // Evento pós-login
    );
  finally
    // Liberação automática pelo componente
  end;
end;
```

### Métodos Principais

| Método | Descrição |
|--------|-----------|
| `Create` | Construtor com criação dos componentes visuais |
| `KAFSJanelaLoginConfig` | Configura a autenticação e aparência da janela |
| `Logar` | Inicia o processo de autenticação com Google |
| `Sair` | Realiza logout e limpa dados da sessão |
| `Retornar` | Fecha a janela ou finaliza a aplicação |

### Parâmetros do Método KAFSJanelaLoginConfig

```pascal
procedure KAFSJanelaLoginConfig(
  const _cortema1: TAlphaColor;        // Cor dos elementos e texto
  const _cortema2: TAlphaColor;        // Cor de fundo
  _imgusuario: TBitmap;                // Imagem do usuário (opcional)
  _clientidgoogle: String;             // Client ID do Google OAuth
  _clientsecretgoogle: String;         // Client Secret do Google OAuth
  _aposlogin: TNotifyEvent             // Evento executado após login bem-sucedido
);
```

## 🔧 Dependências

- `System.Classes`
- `System.SysUtils`
- `System.Threading`
- `System.UITypes`
- `FMX.Forms`
- `FMX.Graphics`
- `FMX.Layouts`
- `FMX.Objects`
- `FMX.StdCtrls`
- `FMX.Types`
- `UntKAFSJanelaModal` (componente base modal)
- `UntKAFSLoginGoogle` (gerenciador de login Google)
- `UntKAFSTelaProgresso` (tela de progresso)
- `UntKAFSFuncoes` (funções utilitárias)

## 🎨 Personalização

### Cores
- Fundo do modal (`_cortema2`)
- Elementos visuais e texto (`_cortema1`)

### Conteúdo
- Imagem do usuário (URL ou bitmap local)
- Client ID e Secret do Google OAuth
- Comportamento pós-login personalizável

### Comportamento
- Persistência automática de sessão
- Login automático se dados existirem em cache
- Finalização da aplicação ou apenas da janela

## ⚠️ Comportamento Multiplataforma

- **Windows**: Janela modal centralizada com autenticação via navegador
- **Android**: Experiência de autenticação nativa do dispositivo

## 🔐 Fluxo de Autenticação

1. **Primeiro Uso**: Exibe botão "Entrar com Google"
2. **Autenticação**: Redireciona para OAuth do Google
3. **Sucesso**: Salva dados localmente e executa callback
4. **Próximos Acessos**: Login automático com dados em cache
5. **Logout**: Limpa dados locais e retorna ao estado inicial

## 🎯 Funcionalidades

- Autenticação transparente com Google OAuth 2.0
- Cache de dados de usuário (imagem, nome, email)
- Tela de progresso durante autenticação
- Cancelamento de processo de login
- Logout com remoção segura de dados
- Interface adaptativa baseada no estado de login

---

**Nota:** Este componente é ideal para aplicações que requerem autenticação de usuários com Google OAuth, oferecendo experiência consistente entre plataformas e persistência de sessão.
