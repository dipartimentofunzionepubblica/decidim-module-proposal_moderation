# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Processore del testo di un commento che assegna una prioritò

# frozen_string_literal: true

module Decidim

  module ProposalModeration

    module ContentProcessor
      extend ActionView::Helpers::SanitizeHelper
      extend ActionView::Helpers::TagHelper
      extend ActionView::Helpers::TextHelper

      def self.parse_priority(content, locale)
        words[locale].any?{ |s| content.match(/#{s}/i) } ? :high : :low
      end

      def self.words
        {
          en: [
          "abortion",
          "anal",
          "anus",
          "arse",
          "ass",
          "ass-fucker",
          "asses",
          "asshole",
          "assholes",
          "ballbag",
          "balls",
          "bastard",
          "bellend",
          "bestial",
          "bestiality",
          "bitch",
          "bitches",
          "bitching",
          "bloody",
          "blowjob",
          "bollok",
          "boob",
          "boobs",
          "breasts",
          "buceta",
          "bum",
          "butt",
          "carpet muncher",
          "chink",
          "cipa",
          "clitoris",
          "cock",
          "cock-sucker",
          "cocks",
          "coon",
          "crap",
          "cum",
          "cumshot",
          "cunillingus",
          "cunt",
          "damn",
          "dick",
          "dildo",
          "dildos",
          "dink",
          "dog-fucker",
          "duche",
          "dyke",
          "ejaculate",
          "ejaculated",
          "ejaculates",
          "ejaculating",
          "ejaculation",
          "fag",
          "fagging",
          "faggot",
          "fagot",
          "fagots",
          "fanny",
          "felching",
          "fellatio",
          "flange",
          "fuck",
          "fucked",
          "fucker",
          "fuckers",
          "fucking",
          "fuckings",
          "fucks",
          "fudge packer",
          "god-damned",
          "goddamn",
          "hell",
          "hore",
          "horny",
          "jerk-off",
          "kock",
          "labia",
          "lust",
          "lusting",
          "masochist",
          "masturbate",
          "mother fucker",
          "nazi",
          "nigger",
          "niggers",
          "orgasim",
          "orgasm",
          "orgasms",
          "pecker",
          "penis",
          "piss",
          "pissed",
          "pisser",
          "pisses",
          "pissing",
          "pissoff",
          "poop",
          "porn",
          "porno",
          "pornography",
          "prick",
          "pricks",
          "pube",
          "pussies",
          "pussy",
          "rape",
          "rapist",
          "rectum",
          "retard",
          "rimming",
          "sadist",
          "screwing",
          "scrotum",
          "semen",
          "sex",
          "shag",
          "shagging",
          "shemale",
          "shit",
          "shite",
          "shits",
          "shitted",
          "shitting",
          "shitty",
          "skank",
          "slut",
          "sluts",
          "smegma",
          "smut",
          "snatch",
          "son-of-a-bitch",
          "spac",
          "spunk",
          "testicle",
          "tit",
          "tits",
          "titt",
          "turd",
          "vagina",
          "viagra",
          "vulva",
          "wang",
          "wank",
          "whore",
          "x rated",
          "xxx"
        ],
          it: [
            "aborto",
            "anale",
            "ano",
            "culo",
            "ass-stronzo",
            "asini",
            "stronzo",
            "stronzi",
            "ballbag",
            "palle",
            "bastardo",
            "bellend",
            "bestiale",
            "brutalità",
            "cagna",
            "bitches",
            "bitching",
            "sanguinoso",
            "pompino",
            "bollok",
            "tetta",
            "tette",
            "seni",
            "buceta",
            "muncher di tappeti",
            "spiraglio",
            "cipa",
            "clitoride",
            "cazzo",
            "pompinara",
            "cazzi",
            "procione lavatore",
            "una schifezza",
            "cum",
            "eiaculazione",
            "cunillingus",
            "fica",
            "dannazione",
            "dildo",
            "dink",
            "dog-stronzo",
            "duche",
            "diga",
            "eiaculare",
            "eiaculato",
            "eiacula",
            "sigaretta",
            "fagging",
            "fascina",
            "fascine",
            "figa",
            "felching",
            "fellatio",
            "flangia",
            "fanculo",
            "scopata",
            "coglione",
            "fuckers",
            "fuckings",
            "scopa",
            "fudge packer",
            "god-dannato",
            "inferno",
            "hore",
            "corneo",
            "kock",
            "labbra",
            "lussuria",
            "lusting",
            "masochista",
            "masturbarsi",
            "madre stronza",
            "nazista",
            "negro",
            "negri",
            "orgasim",
            "orgasmo",
            "orgasmi",
            "pene",
            "pisciare",
            "incazzata",
            "pisser",
            "piscia",
            "pissing",
            "pissoff",
            "cacca",
            "porno",
            "pornografia",
            "puntura",
            "pube",
            "fighe",
            "micio",
            "stupro",
            "stupratore",
            "retto",
            "ritardare",
            "rimming",
            "sadico",
            "avvitamento",
            "scroto",
            "sperma",
            "sesso",
            "scopare",
            "shagging",
            "transessuali",
            "merda",
            "shite",
            "merde",
            "shitted",
            "cacare",
            "merdoso",
            "skank",
            "slut",
            "troie",
            "smegma",
            "oscenità",
            "strappare",
            "figlio di puttana",
            "spac",
            "audacia",
            "testicolo",
            "titt",
            "escremento",
            "vagina",
            "viagra",
            "vulva",
            "wang",
            "wank",
            "puttana",
            "x valutato",
            "xxx"
          ]
        }
      end

    end

  end
end