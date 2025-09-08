# Decidim Proposal Moderation

Il componente aggiunge la possibilità di rinviare la pubblicazione di proposte, emendamenti e commenti a seguito di una revisione del contenuto da parte di un amministratore.
Dipende dalle gemme [decidim](https://github.com/decidim/decidim/tree/v0.25.2) e [deface](https://github.com/spree/deface#readme).

Attenzione: questo modulo sovrascrive alcune dell funzionalità di decidim-proposals e decidim-comments.

## Come usare

Nel backoffice, l'admin può scegliere nelle configurazioni del componente proposte di un processo partecipativo (Processi, Assemblee o Conferenze) se aggiungere l'abilità di rinviare preventivamente la pubblicazione mediante:
1. Flag "Moderazione Abilitata" per abilitare la moderazione di una proposta.
2. Flag "Moderazione emendamenti abilitata" per abilitare la moderazione degli emendamenti qualora ne sia stata abilitata la creazione.

Nel backoffice, l'admin può scegliere nelle configurazioni di un componente commentabile (Accountability, Blog, Budget, Debate, Meeting, Proposal, Sortation) di un processo partecipativo (Processi, Assemblee o Conferenze) se aggiungere l'abilità di rinviare preventivamente la pubblicazione mediante:
1. Flag "Moderazione commenti abilitata" per abilitare la moderazione di tutti commenti al controllo di un admin.

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

## Contributori
Gem sviluppata da [Kapusons](https://www.kapusons.it) per [Formez PA](https://www.formez.it). Per contatti scrivere a partecipa@governo.it .

## Segnalazioni sulla sicurezza
Per segnalazioni su possibili falle nella sicurezza del software riscontrate durante l'utilizzo preghiamo di usare il canale di comunicazione confidenziale attraverso l'indirizzo email partecipa@governo.it e non aprire segnalazioni pubbliche. E' indispensabile contestualizzare e dettagliare con la massima precisione le segnalazioni. Le segnalazioni anonime o non sufficientemente dettagliate non potranno essere verificate.

## Licenza
Vedi [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).