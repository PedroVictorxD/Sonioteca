# Sonioteca

App Flutter estilo Spotify para ouvir e organizar arquivos MP3 locais.

## Features

- Leitura de arquivos MP3 do dispositivo
- Player de música com controles (play, pause, next, previous, seek)
- Interface com tema dark
- Mini player e página de player completa
- Estrutura Clean Architecture
- Testes unitários

## Tecnologias

- Flutter
- Provider (state management)
- just_audio (reprodução de áudio)
- permission_handler (permissões)
- Clean Architecture

## Estrutura

```
lib/
├── domain/        # Camada de domínio (entities, repositories interfaces)
├── data/          # Camada de dados (repositories implementations, datasources)
└── presentation/  # Camada de apresentação (pages, widgets, providers)
```

## Como executar

```bash
flutter pub get
flutter run
```

## GitFlow

- `main` - Branch de produção
- `develop` - Branch de integração
- `feature/*` - Features em desenvolvimento