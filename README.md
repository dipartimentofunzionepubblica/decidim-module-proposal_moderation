# Decidim::ProposalModeration

Il componente aggiunge la possibilità di rinviare la pubblicazione di proposte, emendamenti e commenti a seguito di una revisione del contenuto da parte di un amministratore.
Dipende dalle gemme [decidim](https://github.com/decidim/decidim/tree/v0.25.2) e [deface](https://github.com/spree/deface#readme).

## Usage

ProposalModeration will be available as a Component for a Participatory
Space.

## Installazione

Aggiungi questa linea al Gemfile

```ruby
gem "decidim-proposal_moderation"
```

Ed esegui:

```bash
bundle install
bundle exec rails decidim_proposal_moderation_engine:install:migrations
bundle exec rails db:migrate
```

Di default tutte le configurazioni hanno valore `false` e quindi il comportamento di decidim non cambia.

## Contributori
Gem sviluppata da [Kapusons](https://www.kapusons.it) per [Formez PA](https://www.formez.it). Per contatti scrivere a maintainer-partecipa@formez.it.

## Segnalazioni sulla sicurezza
Per segnalazioni su possibili falle nella sicurezza del software riscontrate durante l'utilizzo preghiamo di usare il canale di comunicazione confidenziale attraverso l'indirizzo email security-partecipa@formez.it e non aprire segnalazioni pubbliche. E' indispensabile contestualizzare e dettagliare con la massima precisione le segnalazioni. Le segnalazioni anonime o non sufficientemente dettagliate non potranno essere verificate.

## Licenza
Vedi [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).