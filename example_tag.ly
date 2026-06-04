\version "2.26"
\include "bhs-markup.ily"

\header {
  title = "From The First Hello"
  subtitle = "To The Last Goodbye"
  date = "1956"
  addinfo = "as sung by The Boston Common"
  composer = "Johnny Burke"
  lyricist = "Johnny Burke"
  arranger = "Lou Perry"
}

Key = {
  \key f \major
}

Time = {
  \time 3/4
  \tempo 4=80
}

ScoreSpec = "bhs-ttbb"
TagPage = ##t
PerformanceNotes = \markuplist {
  \wordwrap-string "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.  Donec hendrerit tempor tellus.  Donec pretium posuere tellus.  Proin quam nisl, tincidunt et, mattis eget, convallis nec, purus.  Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.  Nulla posuere.  Donec vitae dolor.  Nullam tristique diam non turpis.  Cras placerat accumsan nulla.  Nullam rutrum.  Nam vestibulum accumsan nisl."
  \contestSuitability
}


TenorMusic = \relative c' {
  \partial 4 fis8 fis8 |
  f2.( |
  e2) e4 |
  f2.( |
  fis2) eis8 fis8 |
  f2.( |
  e2)\fermata r4 |
  r4 a,4 bes4 |
  c4( bes4) g4 |
  a2.~ |
  a2. |
}

LeadMusic = \relative c' {
  \partial 4 bes8 a8 |
  g2.( |
  d'2) d4 |
  c2.~ |
  c2 b8 c8 |
  d2.~ |
  d2\fermata e,4 |
  f2.~ |
  f2.~ |
  f2.~ |
  f2. |
}

BariMusic = \relative c' {
  \partial 4 d8 c8 |
  d2.( |
  gis,2) gis4 |
  a2.~ |
  a2 gis8 a8 |
  bes4( a4 g4 |
  bes2)\fermata r4 |
  r4 c,4 d4 |
  ees4( d4) des4 |
  c2.~ |
  c2. |
}

BassMusic = \relative c {
  \partial 4 d8 d8 |
  bes2.( |
  b2) b4 |
  c2.( |
  d2) cis8 d8 |
  g4( a4 bes4\voiceCross |
  c,2)\fermata r4 |
  r4 f,4 g4 |
  a4( g4) bes4 |
  f2.~ |
  f2. |
}

%% Layout lyrics
TenorLyrics = \lyricmode {
  \skips 7 last, __ to the last __ good -- bye. __
}

LeadLyrics = \lyricmode {
  From the first __ hel -- lo __ to the last __ good -- bye. __
}

BariLyrics = \TenorLyrics
BassLyrics = \TenorLyrics

%% Synthesis lyrics
% TenorLyrics = \lyricmode {
%   From the first __ hel -- lo __ to the last, __ to the last __ good -- bye. __
% }

% LeadLyrics = \lyricmode {
%   From the first __ hel -- lo __ to the last __ good -- bye. __
% }

% BariLyrics = \TenorLyrics
% BassLyrics = \TenorLyrics

\include "bhs-lilypond.ily"
