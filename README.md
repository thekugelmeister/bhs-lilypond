# bhs-lilypond
This repository represents a set of utilities for notating and engraving barbershop scores in LilyPond, such that the output meets the [Barbershop Notation Manual][2] specification. Other tools are included to augment the experience of working with or arranging barbershop music in LilyPond.

## Overview
Creating high-quality, beautiful, easy-to-read barbershop music notation can be a difficult task. The [Barbershop Harmony Society][1] provides a [set of notation guidelines][2], intended to ensure uniformity and clarity across all barbershop arrangements. In practice, following these guidelines using modern music engraving software can be a tedious and drawn-out process requiring manual tweaking.

[LilyPond][3] is a free music engraving program designed to automate the process of laying out music. It has all of the necessary functionality to take a score and engrave it as a high-quality, beautiful, and easy-to-read document. Furthermore, its highly-extensible design allows for the addition of new functionality and configuration for specific use cases.

## Requirements
| Software      | Version |
|---------------|---------|
| [LilyPond][3] | 2.26   |

## Usage

### Basic Usage

After cloning this repository, to begin creating a score, create a `.ly` file in the top level `bhs-lilypond` directory.

Creating a barbershop score with this package requires the following basic steps:
* Select a pre-defined score specification that defines the desired voice parts and layout
* Provide music and lyrics that match that score specification
* Include the template at the bottom of the file, to automatically generate PDF and MIDI output with the correct formatting

In practice, this looks something like the following for a TTBB (Tenor, Lead, Baritone, Bass) ensemble:
```LilyPond
% Select score spec
ScoreSpec = "bhs-ttbb"

% Define music and lyrics
TenorMusic = \relative c'' {
    ...
}

TenorLyrics = \lyricmode {
    ...
}

...

% Include template
\include "bhs-lilypond.ily"
```

Music and lyrics for each part are specified as variables. For a voice named `VoiceOne`, music should be assigned to the variable `VoiceOneMusic`, and lyrics should be assigned to the variable `VoiceOneLyrics`. The available voices and their names are defined as part of the score spec, which also handles grouping the voices into staves.

To change to another ensemble type, such as SSAA (Tenor, Lead, Baritone, Bass), simply swap out the score spec:
```LilyPond
ScoreSpec = "bhs-ssaa"
```

All score specs should be stored in the `score-specs` directory. See the [README in that directory](score-specs/README.md) for details on available score specs, as well as instructions on how to make your own.

After your score is put together, simply compile the score with LilyPond:
```bash
$ lilypond FILE_NAME.ly
```
This will generate both `FILE_NAME.pdf` and `FILE_NAME.midi`.

### BHS Markup: `bhs-markup.ily`
Additional functionality for marking up your score in BHS-specific ways can be found in `bhs-markup.ily`. To include these, add the following to the top of your file:
```LilyPond
\include "bhs-markup.ily"
```
<!-- TODO: Document available functions -->

### Singing Synthesis [BETA]
This package provides some utilities for automatic generation of synthetic singing tracks from a score. See the [singing-synthesis](singing-synthesis/README.md) directory for details.

## Examples
See `example_tag.ly` and `example.ly` for full examples of the use of this package.
<!-- TODO: embed picture? -->
<!-- TODO: If I embed a picture, I should probably move this earlier... -->

## Important Notes
<!-- TODO: It looks as if the location of this documentation is changing in v2.25; be on the lookout for where it ends up -->
* LilyPond now provides methods for enhancing MIDI output, most notably by automatically applying swing rhythms. For details, see the relevant [LilyPond documentation][6].
* Starting in [v2.22][7], the `'relative-includes` option is now enabled by default by LilyPond. Included files that contain an `\include` command of their own must account for their own path rather than the main file’s directory. `bhs-lilypond` has been updated to reflect this change. **Setting `'relative-includes` to `#f` will likely break import logic in this template; do so at your own risk.**
    * Scheme files and LilyPond files appear to follow different relative path rules within LilyPond. As a result of this change, to unify interfaces within this template and make life easier, all scheme definitions in this repository have been moved into `.ily` files.

## Project History

### Credits and Inspiration
This project originated as a fork of [tahongawaka/LilyPond-BHS-Template][5]. This repository was an invaluable inspiration and reference for learning how to format LilyPond vocal scores. Over time, as my understanding of the language improved, I began to replace components of the template to better match the notation guidelines and make score building easier. Once I became familiar with the built-in LilyPond choral template system, I decided to implement my own system completely from scratch.

### Core LilyPond Functionality
The core funcitonality of this package is based off of the built-in LilyPond choral templates, as used in `satb.ly` and `ssaattbb.ly`. These templates are designed to be included at the end of an input `.ly` file, and automatically format any music that fits their specification. This drastically simplifies the process of laying out multi-part choral music. See the documentation for the [satb template][4] for more details.

<!-- TODO: Expand on the options this brings to the table; especially Key and Time -->

## LilyPond TODO items
List of relevant LilyPond updates that might simplify / modify / otherwise affect functionality added in this package.
* From https://lilypond.org/doc/v2.25/Documentation/changes/text-and-font-improvements
  * Changes coming to font specification that may break current logic; may also improve some functionality

### General notes

* Music function definitions in this template are inconsistent in their documentation style; consider defaulting to style in https://github.com/lilypond/lilypond/blob/master/ly/music-functions-init.ly


[1]: https://www.barbershop.org/
[2]: http://www.barbershop.org/files/documents/getandmakemusic/Barbershop%20Notation%20Manual.pdf
[3]: http://lilypond.org
[4]: https://lilypond.org/doc/v2.20/Documentation/learning/satb-template
[5]: https://github.com/tahongawaka/LilyPond-BHS-Template
[6]: https://lilypond.org/doc/Documentation/notation/enhancing-midi-output
[7]: http://lilypond.org/doc/v2.22/Documentation/changes/
