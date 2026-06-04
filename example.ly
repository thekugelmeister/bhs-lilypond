\version "2.26"
\include "bhs-markup.ily"

                                % TODO: Optional notes
                                % TODO: Expressive text markups
                                % TODO: Melody transfers
                                % TODO: No-breath marks

\header {
  title = "Shine On, Harvest Moon"
  date = "1908"
  composer = "Nora Bayes-Norworth"
  lyricist = "Jack Norworth"
  arranger = "Val Hicks and Earl Moon"
}

Key = {
  \key bes \major
}

Time = {
  \time 2/2
  \tempo 4=80
  % \tempo 4=40
}

ScoreSpec = "bhs-ttbb"
PerformanceNotes = \markuplist {
  \wordwrap-string "This arrangement was selected as the example due to its use as the example in the reference document, \"Notating Barbershop Arrangements\" from 2015. It does a fairly decent job at showing off the formatting specification, and allows a direct comparison to the official documentation. Note that I am not the copyright holder; contact the BHS for details on this arrangement."
  \contestSuitability
}
Copyright = \markuplist {
  \concat { "This Arrangement " \char ##x00A9 " 1985 by Barbershop Harmony Society" }
  "International Copyright Secured    All Rights Reserved"
}


TenorMusic = \relative c'' {
  |
  \section \sectionLabel "Intro"
  g2( fis2 |
  g1~ |
  g1 |
  fis2.) r4 |

  \section \sectionLabel "Verse"
  d8. r16 d8. r16 c8. r16 c8. r16 |
  d8. r16 d8. r16 d4 r4 |
  d4 d4 des4. r8 |
  r4 b4 c4 r4 |
  d8. r16 d8. r16 c8. r16 c8. r16 |
  d8. r16 d8. r16 d2 |
  r4 e4 e4 e4 |
  ees2~ ees4 r4 |
  f8. r16 fis8. r16 g8. r16 ges8. r16 |
  f8 ees4 e8~ e4 ees4 |
  d2 r8 f,8 bes8. d16 |
  d1 |
  e8 f8 g8 e8 f2 |
  e8 f8 g8 e8 f4( fis4\fermata) |
  f8 e8 f8 fis8 \tuplet 3/2 { g8 fis8 g8~ } g8 e8 |
  ees4\fermata f8. fes16 ees8. d16 ees8. f16 |

  \section \sectionLabel "Chorus 1"
  g2 f2 |
  g4 f4 f4 f4 |
  c2~ c8. b16 c8. f16 |
  e4( dis4 e4) r4 |
  f2 ees2 |
  f4 ees8 ees8~ ees8. f16 ees4 |
  d4 ees4 e4 f4 |
  g4 f4 e4 f4 |
  r4 g2 f4 |
  g4 f4 f4 f4 |
  c2~ c8. b16 c8. f16 |
  e2 r4 e4 |
  f2 ees4 r4 |
  f4 ees8 ees8~ ees4 f4 |
  d4~ d8. d16 cis8. cis16 cis4 |
  d4( f4 fis4) r4 |

  \section \sectionLabel "Chorus 2"
  g4 f8. f16 g4 f8. f16 |
  g8. g16 f8. f16 f4 f4 |
  c4 e4 e4 e8. e16 |
  e8. e16 e8. e16 e4 r4 |
  f4 ees4 f4 ees4 |
  f8 ees4 ees8~ ees4 r4 |
  d2( cis4) r4 |
  d8. d16 cis8. cis16 d2\glissando |
  g8 g4 g8 f4 f4 |
  g4 g8 f8~ f4 r8 f8 |
  e8 e4 e8 e4 e4 |
  e4 e8 e8~ e4 e4 |
  f2 ees2 |
  r8 f4 ees8 ees4 f4 |
  d4~ d8. d16 cis8. cis16 cis4 |
  d2( f2) |

  \section \sectionLabel "Tag"
  r4 e8. e16 e8. e16 e4 |
  f4 f8. f16 f8. g16 a4 |
  bes4~ bes8. bes16 bes8. bes 16 bes4 |
  bes1 |
}

LeadMusic = \relative c' {
  |
  \section \sectionLabel "Intro"
  d1~( |
  d1 |
  des1 |
  c2.) r4 |

  \section \sectionLabel "Verse"
  bes8. r16 bes8. r16 a8. r16 a8. r16 |
  bes8. r16 bes8. r16 bes4 r4 |
  bes4 bes4 g4. r8 |
  r4 gis4 a4 r4 |
  bes8. r16 bes8. r16 a8. r16 a8. r16 |
  bes8. r16 bes8. r16 bes2 |
  r4 bes4 bes4 bes4 |
  bes2( a4) r4 |
  ees'8. d16 ees8. d16 ees8. d16 ees8. d16 |
  ees8 c4 g8~ g4 a4 |
  bes2 r8 f8 bes8. d16 |
  f1\voiceCross \breathe |
  c8 d8 e8 c8 d4( des4) |
  c8 d8 e8 c8 d2\fermata |
  d8 cis8 d8 dis8 \tuplet 3/2 { e8 dis8 e8~ } e8 c8 |
  f4\voiceCross\fermata f,8. g16 a8. bes16 c8. d16 |

  \section \sectionLabel "Chorus 1"
  ees2 d2 |
  ees4 d4 b4 g4 |
  e2~ e8. dis16 e8. d'16 |
  c2~ c4 r4 |
  d2 c2 |
  d4 c8 f8\voiceCross~ f8. d16 c4 |
  bes8. g16 f8. g16 bes8. g16 f8. g16 |
  bes8. g16 f8 bes8~ bes2 |
  r4 ees2 d4 |
  ees4 d4 b4 g4 |
  e2~ e8. dis16 e8. d'16 |
  c2 r4 cis4 |
  d2 c4 r4 |
  d4 c8 f8\voiceCross~ f4 d4 |
  bes4~ bes8. f16 g8. f16 g4 |
  bes4( d4~ d4) r4 |

  \section \sectionLabel "Chorus 2"
  ees4 d8. d16 ees4 d8. d16 |
  ees8. ees16 d8. d16 b4 g4 |
  e4 g4 bes4 g8. g16 |
  d'8. d16 c8. c16 g4 r4 |
  d'4 c4 d4 c4 |
  d8 c4 f8\voiceCross~ f4 r8 d8 |
  bes8. g16 f8. g16 bes4 g8. f16 |
  bes8. g16 f8. g16 bes2\glissando |
  ees8 ees4 ees8 d4 g,4 |
  ees'4 ees8 d8~ d4 r8 g,8 |
  d'8 d4 d8 c4 g4 |
  d'4 d8 c8~ c4 cis4 |
  d2 c2 |
  r8 d4 c8 f4\voiceCross d4 |
  bes4~ bes8. f16 g8. f16 g4 |
  bes2( b2) |

  \section \sectionLabel "Tag"
  r4 d8. c16 bes8. c16 d4 |
  r4 c8. d16 ees8. ees16 ees4 |
  r4 d8. d16 c8. ees16 ees4 |
  f1 |
}

BariMusic = \relative c' {
  |
  \section \sectionLabel "Intro"
  bes2( c2 |
  bes1~ |
  bes1 |
  a2.) r4 |

  \section \sectionLabel "Verse"
  g8. r16 g8. r16 fis8. r16 fis8. r16 |
  g8. r16 g8. r16 g4 r4 |
  g4 g4 ees4. r8 |
  r4 f4 fis4 r4 |
  g8. r16 g8. r16 fis8. r16 fis8. r16 |
  g8. r16 g8. r16 g2 |
  r4 g4 g4 g4 |
  g8( ges4. f4) r4 |
  a8. r16 aes8. r16 g8. r16 gis8. r16 |
  a8 a4 bes8~ bes4 f4 |
  f2 r8 f8 bes8. bes16 |
  bes4( c4 b2) |
  bes8 bes8 bes8 bes8 a4( ces4) |
  bes8 bes8 bes8 bes8 a4( c4\fermata) |
  b8 ais8 b8 a8 \tuplet 3/2 { bes8 a8 bes8~ } bes8 bes8 |
  a4 r4 r2 |

  \section \sectionLabel "Chorus 1"
  b2 b2 |
  b4 b4 g4 b4 |
  bes2~ bes8. a16 bes8. bes16 |
  bes4( a4 bes4) r4 |
  a2 a2 |
  a4 a8 a8~ a8. a16 a4 |
  f4 a4 g4 bes4 |
  c4 bes4 g4 f4 |
  b4. r8 b2 |
  b4 b4 g4 b4 |
  bes2~ bes8. a16 bes8. bes16 |
  bes2 r4 bes4 |
  a2 a4 r4 |
  a4 a8 a8~ a4 a4 |
  f4~ f8. f16 ees8. g16 ees4 |
  f4( bes4 c4) r4 |

  \section \sectionLabel "Chorus 2"
  b4 b8. b16 b4 b8. b16 |
  b8. b16 b8. b16 g4 b4 |
  bes4 bes4 c4 bes8. bes16 |
  bes8. bes16 bes8. bes16 bes4 r4 |
  a4 a4 a4 a4 |
  a8 a4 a8~ a4 r4 |
  f4( bes4 g4) r4 |
  f8. f16 g8. es16 f2\glissando |
  b8 b4 b8 b4 b4 |
  b4 b8 b8~ b4 r8 b8 |
  bes8 bes4 bes8 bes4 bes4 |
  bes4 bes8 bes8~ bes4 bes4 |
  a2 a2 |
  r8 a4 a8 a4 a4 |
  f4~ f8. f16 ees8. g16 ees4 |
  f2( g2) |

  \section \sectionLabel "Tag"
  r4 bes8. a16 g8. a16 bes4 |
  a4 a8. a16 a8. bes16 c4 |
  r4 f,8. f16 g8. c16 c4 |
  d1 |
}

BassMusic = \relative c' {
  |
  \section \sectionLabel "Intro"
  g2( a2 |
  g2 f2 |
  ees2~ ees8 f8 ees4 |
  d2.) r8 d8 |

  \section \sectionLabel "Verse"
  d8. cis16 d8. cis16 d8. cis16 d8. cis16 |
  d8 bes4 g8~ g4 g8. a16 |
  bes4 d4 bes4. g8 |
  d'2~ d4 r4 |
  d8. cis16 d8. cis16 d8. cis16 d8. cis16 |
  d8 bes4 g8~ g4 d'4 |
  c2~ c4 d4 |
  c2~ c4 r4 |
  c8. r16 c8. r16 c8. r16 c8. r16 |
  c8 f4 c8~ c4 c4 |
  bes2 r8 f'8 f8. f16 |
  bes4( aes4 g2) \breathe |
  g8 g8 c,8 g'8 f4( aes4) |
  g8 g8 c,8 g'8 f4( a4\fermata) |
  g8 fis8 g8 b,8 \tuplet 3/2 { c8 b8 c8~ } c8 g'8 |
  c,4\fermata r4 r2 |

  \section \sectionLabel "Chorus 1"
  g'2 g2 |
  g4 g4 d4 d4 |
  g,2~ g8. fis16 g8. g16 |
  g'4( fis4 g4) r4 |
  f2 f2 |
  f4 f8 c8~ c8. f16 f4 |
  bes,4 c4 cis4 d4 |
  ees4 d4 cis4 d4 |
  g4. r8 g2 |
  g4 g4 d4 d4 |
  g,2~ g8. fis16 g8. g16 |
  g'2 r4 ges4 |
  f2 f4 r4 |
  f4 f8 c8~ c4 f4 |
  bes,4~ bes8. bes16 bes8. bes16 bes4 |
  bes4( bes'4 a4) r4 |

  \section \sectionLabel "Chorus 2"
  g4 g8. g16 g4 g8. g16 |
  g8. g16 g8. g16 d4 d4 |
  g,4 c4 g'4 c,8. c16 |
  g'8. g16 g8. g16 c,4 r4 |
  f4 f4 f4 f4 |
  f8 f4 c8~ c4 r4 |
  bes2( ees4) r4 |
  bes8. bes16 bes8. bes16 bes2\glissando |
  g'8 g4 g8 g4 d4 |
  g4 g8 g8~ g4 r8 d8 |
  g8 g4 g8 g4 c,4 |
  g'4 g8 g8~ g4 ges4 |
  f2 f2 |
  r8 f4 f8 c4 f4 |
  bes,4~ bes8. bes16 bes8. bes16 bes4 |
  bes2( d2) |

  \section \sectionLabel "Tag"
  c4~ c8. c16 c8. c16 c4 |
  r4 ees8. d16 c8. c16 f4 |
  r4 bes,8. bes16 ees8. g16 ges4 |
  bes1 |
}

%% Layout lyrics
TenorLyrics = \lyricmode {
  \skips 1

  \skips 12
  \skips 11
  Maid was 'fraid of \skips 9
  \skips 19

  \skips 17
  \skips 7 A -- pril, May or June or Ju -- ly.
  \skips 11
  \skips 13

  \skips 22
  \skips 7 loo __ \skips 5
  \skips 17
  \skips 13

  \skips 5 Shine \skips 5
  Shine __
}

LeadLyrics = \lyricmode {
  oo __

  Night was dark you could not see, moon re -- fused to shine
  Cou -- ple un -- der wil -- low tree, for love they pine. __
  Lit -- tle maid was kind -- a 'fraid of dark -- ness, so __ she said, "\"I" guess I'll "go.\"" __
  Boy be -- gan to sigh, __ looked up at the sky, __ told the moon his lit -- tle tale __ of woe:

  "\"Give" a guy a break and shine on, shine on, har -- vest moon __ up in the sky. __
  I ain't had no lov -- in' since Jan -- u -- ar -- y, Feb -- ru -- ar -- y, June or Ju -- ly. __
  Snow time ain't no time to stay __ out -- doors and spoon.
  So shine on, shine on har -- vest moon, __ for me and my gal. __

  Oh, Mis -- ter Moon, won't you shine a lit -- tle light right down on us while we cud -- dle in the night?
  I love her, and me, oh, my, __ we have -- n't e -- ven kissed since the mid -- dle of Ju -- ly.
  Snow time, it ain't no time to spoon, __ and who wants to wait un -- til next June? __
  So, shine on, oh, you har -- vest moon, __ for me and my gal. __

  Shine on, har -- vest moon. ev -- 'ry night in June.
  Shine for me and my "gal!\""
}

BariLyrics = \lyricmode {
  \skips 1

  \skips 12
  \skips 11
  Maid was 'fraid of \skips 9
  \skips 19

  \skips 11
  \skips 7 A -- pril, May or June or Ju -- ly.
  Snow time \skips 9
  \skips 13

  \skips 22
  \skips 7 loo __ \skips 5
  \skips 17
  \skips 13

  \skips 5
  Shine
}

BassLyrics = \lyricmode {
  \skips 1

  The night was migh -- ty dark so you could hard -- ly see, __ for the moon re -- fused to shine. __
  Cou -- ple sit -- tin' un -- der -- neath a wil -- low tree, __ for love __ they pine. __
  \skips 13
  \skips 19

  \skips 11
  \skips 15
  \skips 11
  \skips 13

  \skips 22
  \skips 13
  \skips 17
  \skips 13

  Shine __
}


%% Synthesis lyrics
%% TODO: Lyrics were changed for compatibility with legacy synthesis scheme; consider updating to match new scheme
%% TODO: Synthesizing this file crashes OpenUtau right now.
% TenorLyrics = \lyricmode {
%   oo __
  
%   Night was dark you could not see, moon re -- fused to shine
%   da da da da da da tree, for love they pine. __
%   Maid was 'fraid of dark -- ness, so __ she said, I guess I'll go __
%   Boy be -- gan to sigh, __ looked up at the sky, __ told the moon his lit -- tle tale __ of woe

%   Give a guy a break and shine on, shine on, har -- vest moon __ up in the sky. __
%   I ain't had no lov -- ing since A -- pril, May or June or Ju -- ly.
%   Snow time ain't no time to stay __ out -- doors and spoon.
%   So shine on, shine on har -- vest moon, __ for me and my gal. __

%   Oh, Mis -- ter Moon, won't you shine a lit -- tle light right down on us while we cud -- dle in the night?
%   I love her, and me, oh, my, __ loo __  mid -- dle of Ju -- ly.
%   Snow time, it ain't no time to spoon, __ and who wants to wait un -- til next June? __
%   So, shine on, oh, you har -- vest moon, __ for me and my gal. __

%   Shine on, har -- vest moon. Shine ev -- 'ry night in June.
%   Shine for me and my gal!
% }

% LeadLyrics = \lyricmode {
%   oo __

%   Night was dark you could not see, moon re -- fused to shine
%   da da da da da da tree, for love they pine. __
%   Lit -- tle maid was kind a -- fraid of dark -- ness, so __ she said, I guess I'll go. __
%   Boy be -- gan to sigh, __ looked up at the sky, __ told the moon his lit -- tle tale __ of woe:

%   Give a guy a break and shine on, shine on, har -- vest moon __ up in the sky. __
%   I ain't had no lov -- ing since Jan -- u -- ar -- y, Feb -- ru -- ar -- y, June or Ju -- ly. __
%   Snow time ain't no time to stay __ out -- doors and spoon.
%   So shine on, shine on har -- vest moon, __ for me and my gal. __

%   Oh, Mis -- ter Moon, won't you shine a lit -- tle light right down on us while we cud -- dle in the night?
%   I love her, and me, oh, my, __ we have not e -- ven kissed since the mid -- dle of Ju -- ly.
%   Snow time, it ain't no time to spoon, __ and who wants to wait un -- til next June? __
%   So, shine on, oh, you har -- vest moon, __ for me and my gal. __

%   Shine on, har -- vest moon. ev -- 'ry night in June.
%   Shine for me and my gal!
% }

% BariLyrics = \lyricmode {
%   oo __
  
%   Night was dark you could not see, moon re -- fused to shine
%   da da da da da da tree, for love they pine. __
%   Maid was 'fraid of dark -- ness, so __ she said, I guess I'll go __
%   Boy be -- gan to sigh, __ looked up at the sky, __ told the moon his lit -- tle tale __ of woe

%   shine on, shine on, har -- vest moon __ up in the sky. __
%   I ain't had no lov -- ing since A -- pril, May or June or Ju -- ly.
%   Snow time ain't no time to stay __ out -- doors and spoon.
%   So shine on, shine on har -- vest moon, __ for me and my gal. __

%   Oh, Mis -- ter Moon, won't you shine a lit -- tle light right down on us while we cud -- dle in the night?
%   I love her, and me, oh, my, __ loo __ mid -- dle of Ju -- ly.
%   Snow time, it ain't no time to spoon, __ and who wants to wait un -- til next June? __
%   So, shine on, oh, you har -- vest moon, __ for me and my gal. __

%   Shine on, har -- vest moon. Shine ev -- 'ry night in June.
%   Shine for me and my gal!
% }

% BassLyrics = \lyricmode {
%   oo __

%   The night was migh -- ty dark so you could hard -- ly see, __ for the moon re -- fused to shine. __
%   Cou -- ple sit -- ting un -- der -- neath a wil -- low tree, __ for love __ they pine. __
%   Maid was 'fraid of dark -- ness, so __ she said, I guess I'll go __
%   Boy be -- gan to sigh, __ looked up at the sky, __ told the moon his lit -- tle tale __ of woe

%   shine on, shine on, har -- vest moon __ up in the sky. __
%   I ain't had no lov -- ing since A -- pril, May or June or Ju -- ly.
%   Snow time ain't no time to stay __ out -- doors and spoon.
%   So shine on, shine on har -- vest moon, __ for me and my gal. __

%   Oh, Mis -- ter Moon, won't you shine a lit -- tle light right down on us while we cud -- dle in the night?
%   I love her, and me, oh, my, __ loo __ mid -- dle of Ju -- ly.
%   Snow time, it ain't no time to spoon, __ and who wants to wait un -- til next June? __
%   So, shine on, oh, you har -- vest moon, __ for me and my gal. __

%   Shine on, har -- vest moon. ev -- 'ry night in June.
%   Shine for me and my gal!
% }

\include "bhs-lilypond.ily"
