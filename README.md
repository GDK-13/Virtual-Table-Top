# 🎲 Virtual Tabletop (VTT) - Godot 4.5

## ⚠️ Status do Projeto: Alpha Inicial (WIP)
**Atenção:** Este projeto está em fase de **desenvolvimento inicial**. Atualmente, ele consiste na estrutura de pastas e no esqueleto das cenas principais. **Ainda não existe uma versão funcional para jogo.**

---

## 🛠️ Peculiaridades da Rede: O Fator Hamachi
Para superar as barreiras de NAT e evitar a configuração manual de portas (*Port Forwarding*) em roteadores, este VTT foi projetado para rodar sobre o **LogMeIn Hamachi**.

* **Como funciona:** O projeto trata a conexão como uma **LAN Virtual**.
* **Protocolo:** Utiliza a arquitetura P2P (Peer-to-Peer) da Godot sobre o endereço IPv4 fornecido pelo Hamachi.
* **Requisito:** O Mestre (Host) e os Jogadores devem estar na mesma rede virtual do Hamachi para que a conexão seja estabelecida.

---

## 🏗️ Estrutura do Projeto
```text
├── 📁 Assets               # Arquivos brutos (não editáveis no Godot)
│   ├── 📁 Textures         # Imagens de mapas e tokens padrão
│   │   ├── 📁 Tokens
│   │   └── 📁 Maps
│   ├── 📁 Audio            # Musicas (BGM) e Efeitos (SFX)
│   └── 📁 Fonts            # Fontes personalizadas para a UI
├── 📁 Resources            # Temas (.tres) e definições de dados
│   ├── 📁 Themes           # Estilos visuais dos botões e painéis
│   └── 📁 Data_types       # Scripts de Resource para fichas de personagem
├── 📁 Scenes               # Cenas do Godot (.tscn)
│   ├── 📁 Core             # Main.tscn, Gerenciadores Globais
│   ├── 📁 UI               # Menus, Lobby, Chat, HUD
│   │   └── 📁 Components   # Botões customizados, itens de lista
│   └── 📁 World            # MapLayer.tscn, Token.tscn
├── 📁 Scripts              # Lógica pura (.gd)
│   ├── 📁 Autoloads        # NetworkManager, GameManager, DataManager
│   ├── 📁 UI               # Scripts de controle de interface
│   ├── 📁 World            # Lógica de movimentação e grid
│   └── 📁 Utils            # Scripts auxiliares (ex: DiceRoller, JSONParser)
├── 📁 UserData            # Onde o sistema buscará os assets do usuário
│   └── 📁 Campaigns        # Arquivos .json salvos
├── project.godot
└── .gitignore              # Essencial para ignorar a pasta .godot/
