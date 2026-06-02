%{ bhs-init.ily
%}
%{ Debugging methods
TODO: Consider moving these to a separate file
TODO: Turn these on conditionally, maybe using the BHSDebug flag?
%}
#(begin
  (define (debug-error-print msg)
    (format (current-error-port) "\n~a: ~a" (current-module) msg))
)
\include "base-tkit.ly"

#(debug-error-print "defining utility methods...")
%{ utility methods
TODO: Consider moving these to a separate file
%}
%{ 
  (first-bar-number-visible-and-no-parenthesized-bar-numbers): Bar number visibility settings for this template. Not intended to be called directly; see LilyPond documentation on bar number visibility for details. Enables display of first measure bar number and suppresses parenthesization of bar numbers for partial measures.
 %}
%{ 
  (zip-flatten LIST_A LIST_B): zips elements of LIST_A and LIST_B, then flattens the result into a single list
  (define (zip-flatten a b)
        (reduce-right append! '() (zip a b)))
  %}
#(begin
  (define-markup-command (fromproperty-apply layout props symbol proc) (symbol? procedure?)
    "Identical to fromproperty, but applies the given scheme procedure to the markup prior to interpretation."
    (let ((m (chain-assoc-get symbol props)))
      (if (markup? m)
        ;; prevent infinite loops by clearing the interpreted property:
        (interpret-markup layout (cons (list (cons symbol `(,property-recursive-markup ,symbol))) props)
          (proc m))
        empty-stencil)))
  
  (define (first-bar-number-visible-and-no-parenthesized-bar-numbers barnum mp)
    (= (ly:moment-main-numerator mp) 0))
  
  (define default-lyricist-composer-arranger "UNKNOWN")

  (define-markup-command (lyricist-composer-arranger layout props) ()
    "
TODO: I'm pretty sure that this relies on the user only setting these header variables as strings, not as other valid markups. This is undesirable. Refactor to allow arbitrary markup if possible.
TODO: Is there any way to do this more efficiently using first-visible, and/or other builtin markup commands?

This function is designed to provide the logic for displaying the lyricist, composer, and arranger name sections correctly based on their inclusion in the header block. See sections A.6-8 in the BHS Notation Manual for further documentation.

This information is displayed on a maximum of two lines, each with a left-aligned component and a right-aligned component, making a total of four 'quadrants' to fill.

Taking 'unset' variables into account leads to redundancy in the mapping for no good reason. Therefore, the mappings are defined assuming that any unset variables are already set to the placeholder 'UNKNOWN' value. This leaves us with only five cases to consider:
  0: All three are the same (@Section A.8.b)
  1: Lyricist and Composer are the same (@Section A.7.a)
  2: Lyricist and Arranger are the same (NOT COVERED IN SPEC)
  3: Composer and Arranger are the same (NOT COVERED IN SPEC)
  4: All three are different (@Sections A.6, A.7.b, A.8.a)
NOTE: Some of these cases are not explicitly covered in the manual, so I made educated guesses...
"
    (let* ((lyricist (string-upcase (chain-assoc-get 'header:lyricist props default-lyricist-composer-arranger)))
           (composer (string-upcase (chain-assoc-get 'header:composer props default-lyricist-composer-arranger)))
           (arranger (string-upcase (chain-assoc-get 'header:arranger props default-lyricist-composer-arranger)))
           (lyco (string-ci= lyricist composer))
           (lyar (string-ci= lyricist arranger))
           (coar (string-ci= composer arranger)))
      (cond
        ((and lyco coar)
          (interpret-markup layout props 
            #{ 
              \markup \column {
                \fill-line { \null "Words, Music, and Arrangement by" }
                \fill-line { \null #lyricist }
              }
            #}))
        (lyco
          (interpret-markup layout props 
            #{ 
              \markup {
                \fill-line { #(string-append "Words and Music by " lyricist) #(string-append "Arrangement by " arranger) }
              }
            #}))
        (lyar
          (interpret-markup layout props 
            #{ 
              \markup {
                \fill-line { #(string-append "Music by " composer) #(string-append "Words and Arrangement by " lyricist) }
              }
            #}))
        (coar
          (interpret-markup layout props 
            #{ 
              \markup {
                \fill-line { #(string-append "Words by " lyricist) #(string-append "Music and Arrangement by " composer) }
              }
            #}))
        (else
          (interpret-markup layout props 
            #{ 
              \markup \column {
                \fill-line { #(string-append "Words by " lyricist) #(string-append "Music by " composer) }
                \fill-line { \null #(string-append "Arrangement by " arranger) }
              }
            #})))))
  
  (define-markup-command (generate-perf-notes layout props) ()
    "TODO: Document this and why it needs to be a function and why PerformanceNotes can be null.
TODO: Document the fact that the two baseline-skip settings refer to different skips; between paragraphs vs. lines within paragraphs; can these be set dynamically or do they have to be set explicitly to these values?"
    (let ((perfnotes (ly:parser-lookup 'PerformanceNotes)))
      (cond
        ((null? perfnotes)
          empty-stencil)
        ((markup-list? perfnotes)
          (interpret-markup layout props
            #{
              \markup \column {
                \override #'(thickness . 4) \draw-hline
                \vspace #0.5
                \bold \italic \abs-fontsize #18 "Performance Notes"
                \override #'(baseline-skip . 6) \column-lines \override #'(baseline-skip . 3) \abs-fontsize #10 \PerformanceNotes
              }
            #}))
          (else
            (error (format #f "ERROR: PerformanceNotes must be defined as a markuplist; got ~a" (class-of perfnotes)))))))
  
  (define-markup-command (generate-copyright layout props) ()
    "TODO: Document this and why it needs to be a function and why Copyright can be null.
TODO: Honestly should combine functionality between this and generate-perf-notes"
    (let ((copyright (ly:parser-lookup 'Copyright)))
      (cond
        ((null? copyright)
          empty-stencil)
        ((markup-list? copyright)
          (interpret-markup layout props
            #{
              \markup \fill-line {
                \center-column {
                  \abs-fontsize #9 {
                    \strut
                    \Copyright
                  }
                }
              }
            #}))
          (else
            (error (format #f "ERROR: Copyright must be defined as a markuplist; got ~a" (class-of copyright)))))))
)

#(debug-error-print "performing top level initializations...")
% TODO: I need to find somewhere to document these
% The following are useful functions for tweaking in scheme
% (grob::display-objects grob)
% (grob::all-objects grob)

%%% @Section B.9.a
%% An accidental affects only one voice part for one measure, unless the pitch is tied over the bar line, in which case the accidental is in force only for the duration of the tied note. If the tied pitch is repeated in the new measure, then another accidental is required. Accidentals include the flat, sharp, natural, double flat and double sharp. To cancel a double sharp in a measure, simply use a single sharp. Likewise, to cancel a double flat, use a single flat.
%%% @Section B.9.c
%% Use courtesy accidentals, which are given in parentheses, only if the first note of a given measure is a chromatic version of the last note in the preceding measure in the same part.

%% From music-functions.scm:
%% - accidental-styles alist:
%%   "Each accidental style needs three entries for the context properties extraNatural, autoAccidentals and autoCautionaries. An optional fourth entry may specify a default context for the accidental style, for use with the piano styles."
%% - (make-accidental-rule octaveness laziness):
%%     "Create an accidental rule that makes its decision based on the octave of the note and a laziness value.
%%      octaveness is either 'same-octave or 'any-octave and defines whether the rule should respond to accidental changes in other octaves than the current.  'same-octave is the normal way to typeset accidentals -- an accidental is made if the alteration is different from the last active pitch in the same octave.  'any-octave looks at the last active pitch in any octave.
%%      laziness states over how many bars an accidental should be remembered. 0 is the default -- accidental lasts over 0 bar lines, that is, to the end of current measure.  A positive integer means that the accidental lasts over that many bar lines.  -1 is `forget immediately', that is, only look at key signature.  #t is `forever'."

%% The following defines a new accidental style called "bhs-voice-cautionary", which is based on the built-in "voice" and "modern-cautionary" accidental styles:
%% - Sets extraNatural to #f
%% - All rules apply to the Voice context, rather than the Staff context
%% - autoAccidentals: Accidentals are remembered to the end of the measure in which they occur and only in their own octave
                                % TODO: Technically, this implementation is incorrect, but I like it better in most cases.
%% - autoCautionaries: After temporary accidentals, cautionary cancellation marks are printed also in the following measure (for notes in the same octave) and, in the same measure, for notes in other octaves.
#(set! accidental-styles 
  (append accidental-styles
    `(
      (bhs-voice-cautionary
        #f
        (Voice ,(make-accidental-rule 'same-octave 0))
        (Voice ,(make-accidental-rule 'any-octave 0)
               ,(make-accidental-rule 'same-octave 1))))))


%% Generic Settings and Initialization: All of these default to #f
% BHSDebug: When set to #t, enables some useful debug output.
% TagPage: When set to #t, formats the page layout for tags; rather than having multiple pages, lays out a single auto-sized page that fits the tag.
% ShowTempo: When set to #t, displays the tempo on the first page.
%   Note that setting tempo to an explicit \rhythm markup will override the setting of this variable.
% TODO: Maybe make a "final" option that automatically sets this, to enable point-and-click while working?
\pointAndClickOff
#(begin
  (define other-settings
    '("BHSDebug"
      "TagPage"
      "ShowTempo"))
  (define-missing-variables! other-settings)

  (cond
    (BHSDebug
      (ly:set-option 'debug-skylines)))
)

%{ Define the default directory in which to search for score specs
 %}
#(define score-spec-dir "score-specs")

%{ ScoreSpec: 
  REQUIRED: Set this to the basename of the score spec to use. Searches in the default score spec directory for matching files.

  The following dynamically loads the requested score spec from the default location. Provide only the basename (e.g. no file extention)
  Raises an error if score spec is undefined, passed as a non-string, or a score spec matching the requested name is not found.
  %}
#(let ((spec-name (ly:parser-lookup 'ScoreSpec)))
  (cond
    ((null? spec-name)
      (error "ERROR: score spec not defined"))
    ((string? spec-name)
      (let ((score-spec-file-path (string-append score-spec-dir file-name-separator-string spec-name ".ily")))
        (if (file-exists? score-spec-file-path)
          #{ \include #score-spec-file-path #}
          (error (format #f "ERROR: score spec not found: ~a" score-spec-file-path)))))
    (else
      (error "ERROR: ScoreSpec must be defined as a string"))))

%% BHS Settings
%%% @Section A.1.a
%% For men’s voices, each music system consists of two staves, one for treble clef with an 8 beneath it (to be read an octave lower than written, for the lead and tenor parts) and one for bass clef (baritone and bass parts). For women’s voices, each music system consists of two staves, one for treble clef (for the lead and tenor parts) and one for bass clef with an 8 above it (to be read an octave higher than written, for the baritone and bass parts). Indicate each music system by using a choral bracket to connect the two staves.
                                % TODO: Maybe put this documentation in the relevant score-spec files?

%%% @Section A.10
                                % TODO: Medley spec is currently unimplemented.

%%% @Section A.15
%% Place optional passages of songs on a new system following the conclusion of the song. Use the label Optional tag, Optional key change, etc. as needed using 12-point fixed size Times New Roman Italic type.
                                % TODO: Optional tag/etc. spec is currently unimplemented

%%% @Section B.4.b
%% Indicate a change in key by placing a double bar line prior to the indication of the new key. If a key change occurs at the start of a new system, place a double bar line followed by a courtesy key signature at the end of the preceding system.
                                % TODO: Key change bar line spec is currently unimplemented

%%% @Section B.5.b
%% Indicate a change in meter by placing a double bar line prior to the indication of the new meter.
%%% @Section B.5.c
%% Indicate a meter change that preserves the time value of the basic beat
                                % TODO: Time signature change spec is currently unimplemented
#(debug-error-print "changing paper settings...")
\paper {
  annotate-spacing = #BHSDebug
  
  page-breaking = #(if TagPage
                    ly:one-page-breaking
                    ly:optimal-breaking)

  %%% @Section A.2
  %% Use 1/2” to 5/8” margins at the top, bottom and sides of all pages. The ends of each music system, including the choral bracket, sit within and abut the side margins.
  #(set-paper-size "letter")
  bottom-margin = 0.50\in
  top-margin = 0.50\in
  inner-margin = 0.50\in
  outer-margin= 0.625\in % 5/8 inch
  line-width = 7.375\in % 8.5 inch page width - ( inner-margin + outer-margin )
  ragged-last-bottom = ##t

  %%% @Section A.1.d
  %% The standard format is three or four systems on the first page, and four or five systems on the other pages.  Use good judgment.  Avoid crowding too many systems on a page.  On the first page, save room above the first system for song title, writers and arrangers.
                                % TODO: This does not do a great job. Fix it.
  %% NOTE: This still seems to be pretty much impossible in LilyPond. The current setting is kind of "good enough". It combines max-systems-per-page with flexible vertical spacing settings to make things look good, while hoping that we never hit a scenario where too few systems end up on a page.
                                % min-systems-per-page = 4
  max-systems-per-page = 5
  system-system-spacing.padding = #4 % ensure there is a little space between systems
  top-system-spacing.padding = #3 % ensure there is a little space between the page header and the top system on each page
  top-markup-spacing.padding = #4 % ensure there is a nice amount of space above the title markup
  markup-system-spacing.padding = #4 % ensure there is a nice amount of space below the title markup
  % page-breaking-system-system-spacing.basic-distance = #5 % trick the page breaker into thinking there needs to be a sufficiently large gap between systems, such that the first page will not have 5 systems on it

  % Times New Roman on Macs is currently broken: N becomes a different glyph (I with dot underneath)
  % References:
  % https://lists.gnu.org/archive/html/lilypond-user/2022-12/msg00349.html
  % https://gitlab.com/lilypond/lilypond/-/issues/6508
  % https://discussions.apple.com/thread/254519584
  % In the short term, use Times instead of Times New Roman. Times is from the Linotype lineage, which is subtly different, but it will be basically impossible to tell.
  % In the long term, consider bundling an open source variant of Times New Roman to ensure cross-platform compatibility.
  #(define fonts
    (if (string-ci= (utsname:sysname (uname)) "Darwin")
      (set-global-fonts
        #:roman "Times"
        #:sans "Arial"
        #:factor (/ staff-height pt 20) ; unnecessary if the staff size is default
      )
      (set-global-fonts
        #:roman "Times New Roman,"
        #:sans "Arial"
        #:factor (/ staff-height pt 20) ; unnecessary if the staff size is default
      )))
  
  % Reference for the following markups: https://lilypond.org/doc/Documentation/notation/custom-titles-headers-and-footers
  bookTitleMarkup = \markup {
    \column {
      %%% @Section A.4.a
      %% Center the song title at the top of the first page. Use all capital letters in 22 point fixed size ARIAL BOLD type.
      \fill-line { \abs-fontsize #22 { \sans \bold \fromproperty-apply #'header:title #(lambda (x) (string-upcase x))} }
      %%% @Section A.4.b
      %% If the song title includes a parenthetical phrase or word, center the parenthetical expression and use capital letters, 12-point fixed size ARIAL BOLD type.
      \fill-line { \abs-fontsize #12 { \sans \bold \fromproperty-apply #'header:subtitle #(lambda (x) (string-append "(" (string-upcase x) ")"))} }
      %%% @Section A.5
      %% If the song is in public domain, center the year it was written in parentheses directly below the title, in 12-point fixed size Arial Bold.
      \fill-line { \abs-fontsize #12 { \sans \bold \fromproperty-apply #'header:date #(lambda (x) (string-append "(" x ")"))} }
      %%% @Section A.9
      %% Center under the title any acknowledgment or indication of the group that popularized the arrangement. Use 10-point fixed size Times New Roman Italictype
      \fill-line { \abs-fontsize #10 { \italic \fromproperty #'header:addinfo } }
      %%% @Section A.6-8
      %% See documentation for lyricist-composer-arranger in utilities.
                                % TODO: When there are multiple people, apparently the "and" between names should not be capitalized.
                                % TODO: Is there any way to make this functionality work using the new markup conditionals? Not sure it's necessarily a better option, but look into it.
      \abs-fontsize #12 {
        \strut
        \lyricist-composer-arranger
        \strut
      }
    }
  }

  oddFooterMarkup = \markup {
    %%% @Section A.14.a
    %% Center the copyright notice at the bottom of the first page of music. Include, at a minimum, the date of the copyright and the name of the copyright owner. Use 9-point regular fixed size Times New Roman type. The copyright owner will specify the form and content of the copyright notice.
    %%% @Section A.14.b-g
    % TODO: Copyright stuff is complicated. It seems reasonable to me to leave copyright formatting as an exercise for the user, but I can see the utility of having pre-formatted inclusions available for the ones given in the spec.
    \if \on-first-page-of-part 
    \generate-copyright
    %%% @Section C.5.a
    %% Place Performance Notes after the music in 18-point fixed size Times New Roman bold italic type, with a solid horizontal line separating the last music system from the Performance Notes in Arial 18-point fixed size bold.
    %%% @Section C.5.b
    %% Performance notes indicate possible performance options for the music, are in 10-point regular fixed size Times New Roman type, and may include historical information about the song and its author and composer, the arranger, and any artist who popularized the song.
    % TODO: This section is sometimes way too close to the final staff. Especially true for TagPage layout. Find a way to ensure space is left between them.
    % TODO: Collides with copyright if both are defined and performance notes go on first page. Is this worth trying to fix?
    % TODO: Because of using baseline-skip rather than explicit vspaces, there's too much space on the top and bottom of each paragraph. Minor annoyance.
    % TODO: I still don't like having to call a markup command to generate this. Is it possible to dynamically check for the contents of the relevant variable in lilypond syntax, rather than scheme?
    \if \on-last-page
    \generate-perf-notes
  }

%%% @Section A.3
  %% Use the title of the song as a header for each page except page one.
  %% Position the header in the middle at the top of the page in 12-point fixed size Times New Roman Italic type. Use first letter caps except for articles.
  %% Position even page numbers on the left side of the page, and odd pages on the right side in 12-point fixed size Times New Roman Italic type
  oddHeaderMarkup = \markup {
    \fill-line {
      \null
      \abs-fontsize #12 { \unless \on-first-page-of-part \italic \fromproperty #'header:title }
      \abs-fontsize #12 { \if \should-print-page-number \italic \fromproperty #'page:page-number-string }
    }
  }
  evenHeaderMarkup = \markup {
    \fill-line {
      \abs-fontsize #12 { \if \should-print-page-number \italic \fromproperty #'page:page-number-string }
      \abs-fontsize #12 { \unless \on-first-page-of-part \italic \fromproperty #'header:title }
      \null
    }
  }
}

#(debug-error-print "changing layout settings...")
Layout = \layout {
  %%% @Section B.13.a:
  %% A caesura marks a break in the sound. The two slanted lines should go through the top space of the staff and rest on the fourth line.
  % TODO: Document that \breathe is how to add caesuras.
  \set breathMarkType = #'caesura
  \context {
    \Score
%%% @Section A.1.b
    %% Indent the first music system so that the names of the four parts (Tenor, Lead, Bari, and Bass), with only the first letter capitalized, can be printed immediately to the left of the system. Left justify the part names flush with the left margin, and in Times New Roman type 10-point fixed size.
    %% NOTE: The following doesn't work, because the staff-tkit hard-codes the instrument name to be in a right-aligned column. Kept here for documentation.
    %% \override InstrumentName.self-alignment-X = #LEFT
    %% NOTE: This is silly, but it works. The staff-tkit hard-codes a lot of things, so I had to overwrite them. Could be avoided by replacing the staff-tkit, but I set out to make use of the pre-built lilypond funcitonality, and I am sticking to my guns. This function extracts the instrument names from the hard-coded markups, then re-packages them with the desired formatting. It also overwrites the short instrument names to force them to be empty.
    %% Based on http://lsr.di.unimi.it/LSR/Item?id=1046
    \override InstrumentName.after-line-breaking = 
    #(lambda (grob)
      (let* ((orig (ly:grob-original grob))
             (siblings (if (ly:grob? orig)
                        (ly:spanner-broken-into orig)
                        '())))
        (if (pair? siblings)
          (let* ((old-inst-name-markup (ly:grob-property grob 'long-text))
                 (inst-names (map (lambda (proc) (cadr proc)) (cadr old-inst-name-markup)))
                 (inst-markups (map (lambda (name) (markup name)) inst-names))
                 (m (markup #:abs-fontsize 10 (make-left-column-markup inst-markups))))
            (ly:grob-set-property! (car siblings) 'long-text m)
            (for-each
              (lambda (g) (ly:grob-set-property! g 'text ""))
              (cdr siblings))))))
    
%%% @Section A.11.a
    %% Place names of sections (such as Intro, Verse, Chorus, Reprise, Interlude, or Tag) in 12-point fixed size Times New Roman Bold type, with the first letter aligned with the first note of the section. Capitalize only the first letter of the word.
                                % TODO: Right now this only covers the alignment issue; the rest is part of a function in bhs-markup.ily. If possible, condense things so that it's more standardized.
                                % TODO: Right now this is technically incorrect, as it always aligns to the double bar line, not the first note of the section. Fix this if it is possible to do so in an easy-to-use way.
    \override RehearsalMark.self-alignment-X = #LEFT

%%% @Section B.18
    %% Indicate a vocal glissando, which is a continuous slide in pitch from one note to another, by placing a wavy line from one note head to the next note head.
    %% Glissando style
    \override Glissando.style = #'trill

                                %% Optionally display tempo marking; spec calls for no tempo marking, so default is to hide it.
    tempoHideNote = #(not ShowTempo)

                                % Change context to staff: http://lilypond.1069038.n5.nabble.com/Consistent-bar-number-positioning-td26017.html
    \remove Bar_number_engraver

    %% Limit how close together notes can be, for readibility
    \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/16)

%%% @Section A.11
    %% Place names of sections, such as Intro, Verse, Chorus, Reprise, Interlude, or Tag, in 12-point fixed size Times New Roman Bold type, with the first letter aligned with the first note of the section. Capitalize only the first letter of the word.
    %% TODO: Technically, this may be incorrect. Font size should be set explicitly to 12, but there is no way to set abs-fontsize in overrides. This gets close, but try to find a way to make it explicit.
    %% TODO: This aligns incorrectly. It is supposed to align to the first note in the section. However, the break-align interface does not seem to have a valid option available.
    \override SectionLabel.font-size = 1
    \override SectionLabel.font-series = #'bold
    \override SectionLabel.break-align-symbols = #'(time-signature key-signature clef staff-bar)
  }
  \context {
    \Staff
    \consists Bar_number_engraver
%%% @Section A.12.a
    %% Number every measure, starting with the first full measure. Place the measure number above the treble staff and immediately following the bar line, except for the first measure of each system, where the measure number is placed above the treble staff and immediately after the key signature.
%%% @Section A.12.c
    %% Use 10-point regular fixed size Times New Roman type for all measure numbers.
    \override BarNumber.break-visibility = #end-of-line-invisible
                                % TODO: This relies on the assumption that the top staff will always be index 0 or 1 in the vertical axis group, and the lower staves will always be of index > 2. Thus far, this assumption has held for all test cases. However, I am uncomfortable with this assumption. Consider robustly checking it, or finding a better way to do it.
    %% NOTE: This also handles the requirement for setting the absolute font size
    \override BarNumber.stencil = 
    #(grob-transformer 'stencil
      (lambda (grob default)
        (if (member (ly:grob-get-vertical-axis-group-index grob) '(0 1))
          (grob-interpret-markup grob (markup (make-abs-fontsize-markup 10 (ly:grob-property grob 'text))))
          #f)))
    \override BarNumber.extra-spacing-width = #'(0 . 1)
    %% NOTE: For the following to work, it requires forcibly adding a blank bar in front of the music, so that LilyPond figures out there's a bar there in the first place. This is handled elsewhere in this template.
    barNumberVisibility = #first-bar-number-visible-and-no-parenthesized-bar-numbers
    \override BarNumber.self-alignment-X = #LEFT
    \override BarNumber.break-align-symbols = #'(time-signature key-signature staff-bar)
    \override BarNumber.avoid-slur = #'inside
    \override BarNumber.outside-staff-priority = ##f
%%% @Section A.12.b
    %% For the first measure, or any measure with a key signature and/or meter signature, place the number of the measure above the treble staff immediately after the meter signature.
    \override TimeSignature.break-align-anchor-alignment = #RIGHT
%%% @Section A.12.d (from old version of the spec)
    %% If the last measure of a system must be split to start a new section on the next system with a pickup note(s), take care not to assign a measure number to the pickup portion of the split measure.
                                % TODO: Implement this spec; this might be the automatic functionality, but this needs verification.

    \accidentalStyle bhs-voice-cautionary

%%% @Section A.1.d (continued)
    %% If there is a lot of blank space on a page, let there be some more space between grouped staves in a system, rather than just having more space between systems. This makes things look more comfortable, in most cases
    %% NOTE: This also helps cover up some imperfections in the current solution for sytems-per-page.
    \override VerticalAxisGroup.staff-staff-spacing.stretchability = #60
  }
  \context {
    \Lyrics
%%% @Section C.4
    %% Lyrics are set in 11-point regular fixed size Times New Roman type in the middle of the two staves and wherever a harmony part sings different words or the same words at different times. If the baritone and bass parts have the same set of words but different from the lead, and are singing the same rhythmic notation, simply place the words above the baritone part. If the tenor, baritone, and bass all have the same words, then place the words above the baritone and the tenor lines. If the lead and baritone are the same, but the tenor and bass are different, place words in the middle of the two staves for the lead and baritone, and above the tenor part and below the bass part. If the words are different for each part, however, then each part should be given its own set of words.
                                % TODO: This does not really do what it needs to. Fix it.
    % \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.stretchability = #10
    % \override VerticalAxisGroup.nonstaff-unrelatedstaff-spacing.stretchability = #30
  }
}

#(debug-error-print "laying out the score...")
\include "vocal-tkit.ly"

% TODO: This is no longer a sandwich, thanks to changes to first-bar-number visibility settings. Also the name is silly. Consider changing it. Or is there some other builtin way to automatically add final bar?
BHSBarSandwich =
#(define-music-function (music) (scheme?)
  (_i "Sandwich the given music between a blank bar line and a closing bar line")
  (if music
    #{{#music \bar "|."}#}
    (make-music 'SequentialMusic 'void #t)))

% Uses builtin LilyPond base-tkit.ily functionality to register the prefixes defined by the score spec; hard-codes lyric postfix; no additional lyric-only verses enabled
#(set-music-definitions!
  (staves-voice-prefixes)
  '("Lyrics")
  '())

% Automatically wraps each music definition in a BHSBarSandwich (blank bar line and closing bar line).
% This is done by redefining each music definition as itself surrounded by the sandwich, at the module level.
% This implementation is required thanks to the utilization of the builtin LilyPond vocal-tkit.ly \make-N-voice-vocal-staff functionality, which automatically retrieves music definitions based on voice names.
% TODO: This appears to be functional, but is clunky. Are there any strange side effects? Are there other ways to do this? Maybe this is a convincing argument for not relying on the builtin functionality, or at least copying it over and modifying it.
#(for-each 
  (lambda (name)
    (module-define! (current-module)
     (string->symbol name) (BHSBarSandwich (get-id name))))
  all-music-names)

                                % TODO: Always having this be a chorus staff is convenient for the BHS usecase, but isn't necessarily the desired option for all cases. For example, with a solo 5th part, it might be nice for the solo line to be a member of its own staff. I think this would require a new outer-most class for score specification that defines what type of staff you want. Even better would be a version of generate-staff-definition for choir-staff-spec objects, so this line would barely change.
BHSLyStaff = << \new ChoirStaff << #(make-simultaneous-music (map generate-staff-definition staves)) >> >>

\tagGroup #'(print play)

% TODO: If this should be re-included, move it to bhs-init.ily. Also consider the updated interface here: https://lilypond.org/doc/Documentation/notation/context-modification-identifiers
% \layout {
%   \context {
%     \Staff
%     \override VerticalAxisGroup.remove-empty = ##t
%     \override VerticalAxisGroup.remove-first = ##t
%   }
% }

% TODO: The chord display functionality could be useful in the future; should it be reenabled?
\score {
  \keepWithTag #'print
  % #(if have-music
  %      #{ << \Chords \BHSLyStaff >> #}
  %      #{ { } #} )
  #(if have-music
       #{ << \BHSLyStaff >> #}
       #{ { } #} )
  \layout { $(if Layout Layout) }
}

%% To avoid note collisions for multiple voices voices on one staff, assign the midi performer to the Voice context.
\score {
  \keepWithTag #'play
  % #(if have-music
  %      #{ << \Chords \BHSLyStaff >> #}
  %      #{ { } #} )
  #(if have-music
       #{ << \BHSLyStaff >> #}
       #{ { } #} )
  \midi {
    \context {
      \Staff
      \remove "Staff_performer"
    }
    \context {
      \Voice
      \consists "Staff_performer"
    }
    % \context {
    %   \ChordNames
    %   midiInstrument = #"voice oohs"
    % }
  }
}