%{
Copyright 2018 Jeremy Marcus
This is distributed under the terms of the GNU General Public License.

This file is part of LilyPond Barbershop Template.

LilyPond Barbershop Template is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LilyPond Barbershop Template is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LilyPond Barbershop Template.  If not, see <http://www.gnu.org/licenses/>.
%}

%{ bhs-markup.ily
Methods for modifying music / lyric definitions during the notation process, in BHS-specific manners.
All of these methods can be used independently from the rest of the template.

To use, simply add the following line to the top of the .ly file:
  \include "bhs-markup.ily"
%}

%{ contestSuitability
Standard boilerplate text included at the end of the Performance Notes for nearly all BHS-released sheet music.

Example usage:
  PerformanceNotes = \markuplist {
    \wordwrap-string "Lorem ipsum"
    \contestSuitability
  }
%}
contestSuitability = \markup {
  \wordwrap {
    As a final note: Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask \italic before you sing.
  }
}

%{ voiceCross
Add a voice crossing mark to a note.

@Section B.14.a
If the lower voice on a staff crosses over the top voice on the same staff, place a lower-case x in 10-point fixed size Arial type, above the staff where the first note of the chord occurs.

Example usage:
  LeadMusic = \relative c' {
    f1\voiceCross |
  }
%}
voiceCross=#(define-event-function () ()
             #{
             ^\markup { \abs-fontsize #10 { \sans x } }
             #}
           )


%{ voiceCrosses
Mark the given set notes as crossed.
TODO: Does this even work right now? If it does, start using it! If it doesn't, either fix it or remove it.
TODO: Can this operate in a similar fashion to the \spoken markup?
%}
%{
voiceCrosses =
#(define-music-function
  (parser location music)
  (ly:music?)
  (map-some-music voiceCross music)
)
%}

%{ optionalNotes
Given a chord, makes the first note normal size and the remaining notes a smaller size.

@Section B.16
Indicate an optional note by using a 70%-sized note head.

Reference: http://lsr.di.unimi.it/LSR/Item?id=538

TODO: Refactor; not sure if this works, or how it was supposed to work in the first place...
%}
%{
optionalNotes =
#(define-music-function (parser location x) (ly:music?)
  (music-map (lambda (x)
              (if (eq? (ly:music-property x 'name) 'EventChord)
               (let ((copy (ly:music-deep-copy x)))
                (let ((elements (cdr (ly:music-property copy 'elements))))
                 (while (pair? elements)
                  (ly:music-set-property! (first elements) 'tweaks
                   (acons 'font-size -3 (ly:music-property (car elements)
                                         'tweaks)))
                  (set! elements (cdr elements))))
                copy) x))
   x))
%}

% TODO: Right now, (\set autoExtenders = ##t) is broken when \skips is used. Is that because of a mistake I've made?
%{ skips
Insert a given number of lyric skips, making it easier and more concise to add lyrics to harmony parts

Reference: http://lilypond.1069038.n5.nabble.com/Add-lyrics-after-n-measures-td165881.html

Example usage:
  TenorLyrics = \lyricmode {
    \skips 7 last, __ to the last __ good -- bye. __
  }
%}
skips =
#(define-music-function
  (parser location nskips)
  (integer?)
  "Insert a given number of lyric skips, accounting appropriately for terminating lyric extenders."
  (if (= nskips 1)
   #{ 
  \lyricmode {
   ""
 }
   #}
   #{ 
   \lyricmode {
   ""
   \repeat unfold $(- nskips 1) { \skip 1 }
 }
   #}
 ))

%{ melodyTransfer
Indicate a melody transfer between voices.

@Section B.10.a
Indicate when the melody is transferred from the lead to another part, or vice versa, by placing a dashed line from the last melody note in that part to the first melody note in the other part.

Arguments:
  angle: angle at which to draw the line (in degrees)
  length: length of the line (in unknown units)
  xoffset: horizontal displacement of the line start (in unknown units)
  yoffset: vertical displacement of the line start (in unknown units)

Reference: adapted from http://lsr.di.unimi.it/LSR/Snippet?id=961

TODO: I need a better solution for this. First of all, the fact that it's completely manual makes it difficult to use. It should somehow be able to determine placement automatically. Second, these take up no actual space, as far as I can tell? So they get kind of clobbered by other grobs.

Example usage:
  TenorMusic = \relative c' {
    f2-\markup { \melodyTransfer #70 #8 #2.5 #-1 } g2 |
  }
  
%}
#(define-markup-command (melodyTransfer layout props angle length xoffset yoffset) 
  (number? number? number? number?)
  (interpret-markup layout props
   #{
   \markup {
   \with-dimensions #'(0 . 0) #'(0 . 0)
   \translate #(cons xoffset yoffset)
   \rotate #angle
   \with-dimensions #'(0 . 0) #'(0 . 0)
   \translate #(cons 0 (- 0 length))
   \draw-dashed-line #(cons 0 length)
 }
   #}))


%{ spoken
Changes note heads to denote spoken words (also can be used for clapping or other percussive parts).

@Section B.2.b
To indicate a speaking part, use an x-head note. 

Example usage:
  LeadMusic = \relative c' {
    f4 f4 \spoken { e8 e8 e4 } |
  }
%}
spoken =
#(define-music-function
  (parser location music)
  (ly:music?)
  #{ \override NoteHead.style = #'cross $music \revert NoteHead.style #})

%{ keychange
Format a keychange correctly, placing double barlines and adding courtesey key signatures where necessary. Use as a direct replacement for the standard \key music function within scores. Works mid-measure.

@Section B.4.b
Indicate a change in key by placing a double bar line prior to the indication of the new key. If a key change occurs at the start of a new system, place a double bar line followed by a courtesy key signature at the end of the preceding system.

Example usage:
  LeadMusic = \relative c' {
    f4 f4 \keychange e \major e8 e8 e4 |
  }
%}
keychange =
#(define-music-function 
  (tonic pitch-alist)
  ((ly:pitch? '()) (number-pair-list? '()))
  #{ \section \key $tonic $pitch-alist #})