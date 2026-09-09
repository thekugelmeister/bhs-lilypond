import argparse
from pathlib import Path
from collections import defaultdict
import string
import logging

import mido
import ly.document
import ly.music
import ly.lex


logger = logging.getLogger(__name__)


# TODO: Handle other phonemizers?
# This appears to be the correct character to set as lyrics to get openutau to respect slurs for ARPAsing voices
slur_string = '+'
strip_punctuation_table = str.maketrans({key: None for key in string.punctuation.replace(slur_string, "")})

def flatten_part(
        base_file: mido.MidiFile,
        part_name: str
) -> mido.MidiTrack:
    """
    Find all tracks that match the part name.
    Return a midi track containing just those tracks flattened into a single track.
    """
    flat_file = mido.MidiFile()
    # add part tracks
    for track in base_file.tracks:
        if part_name in track.name:
            flat_file.tracks.append(track)
    # flatten file
    return flat_file.merged_track


def openutauify(flat_track: mido.MidiTrack) -> mido.MidiTrack:
    """
    Modify flattened midi track to make sure openutau is able to synthesize without added effort, by doing the following:
    * Add lyric events to get openutau to respect slurs
    """
    openutau_track = mido.MidiTrack()
    seen_lyric = False
    for message in flat_track:
        match message:
            case mido.MetaMessage(type='lyrics'):
                if not message.text:
                    raise RuntimeError("For synthesis, all voices must have lyrics")
                seen_lyric = True
            case mido.Message(type='note_on', velocity=0):
                if not seen_lyric:
                    openutau_track.append(mido.MetaMessage(type='lyrics', text=slur_string))
                seen_lyric = False
            case _:
                pass
        openutau_track.append(message)
    return openutau_track


def openutauify_with_target(flat_track: mido.MidiTrack, target_lyrics: list[str]) -> mido.MidiTrack:
    """
    Modify flattened midi track to make sure openutau is able to synthesize without added effort, by doing the following:
    * Add lyric events to get openutau to respect slurs
    """
    if len(target_lyrics) == 0:
        raise ValueError("target_lyrics must not be empty")
    openutau_track = mido.MidiTrack()
    seen_lyric = False
    # TODO: Is it a problem that I'm destructively removing items from this list? It should only be used once so it should be fine, right?
    # TODO: Is it a problem that I'm modifying the text of the original message? It should only be used once so it should be fine, right?
    current_word = target_lyrics.pop(0)
    middle_of_word = False
    for message in flat_track:
        match message:
            case mido.MetaMessage(type='lyrics'):
                # print(message, current_word)
                if not message.text:
                    raise RuntimeError("For synthesis, all voices must have lyrics")
                elif message.text == current_word:
                    current_word = ""
                    if middle_of_word:
                        # This is the end of a word; assign the message to be the slur string
                        message.text = slur_string
                elif message.text == current_word[:len(message.text)]:
                    current_message_length = len(message.text)
                    if not middle_of_word:
                        # This is the beginning of a word; assign the message to be the entire word
                        message.text = current_word
                        middle_of_word = True
                    else:
                        # This is the middle of a word; assign the message to be the slur string
                        message.text = slur_string
                    current_word = current_word[current_message_length:]                  
                else:
                    raise RuntimeError(f"Midi lyrics do not all match lilypond file lyrics")
                seen_lyric = True
                # strip out punctuation
                message.text = message.text.translate(strip_punctuation_table)
            case mido.Message(type='note_on', velocity=0):
                if not seen_lyric:
                    openutau_track.append(mido.MetaMessage(type='lyrics', text=slur_string))
                seen_lyric = False
            case _:
                pass
        openutau_track.append(message)
        if not current_word:
            try:
                current_word = target_lyrics.pop(0)
                middle_of_word = False
            except IndexError:
                # We should be at the end of the lyrics. Do nothing. If we get more lyric messages, it should trigger the ValueError for non-matching lyrics.
                middle_of_word = False
    return openutau_track


def lyrics_from_ly_file(ly_file: Path, part_names: list) -> dict[str, list[str]]:
    """
    TODO: Document this
    """
    music_doc = ly.music.document(ly.document.Document.load(ly_file))
    lyric_assignments = {item.name(): item for item in music_doc.find(ly.music.items.Assignment, depth=1) if "Lyrics" in item.name()}
    parsed_lyrics = defaultdict(list)
    for part_name in part_names:
        # Get lyric assignment for this part
        try:
            lyric_assignment = lyric_assignments[f"{part_name}Lyrics"]
        except KeyError as e:
            raise ValueError(f"Lyrics for {part_name} not found in {ly_file.name}") from e
        # Reassign the lyric assignment if the lyrics are defined as a reference to a different part (e.g. "BassLyrics = \LeadLyrics")
        match lyric_assignment.value():
            case ly.music.items.LyricMode():
                # This is the default case, where the lyric assignment is a part-specific lyric definition.
                lyric_mode = lyric_assignment.value()
            case ly.music.items.UserCommand():
                # Lyrics are defined in reference to a different part; find the referenced definition.
                # TODO: This might catch UserCommands of a different type; consider adding validation logic.
                lyric_mode = lyric_assignment.value().value()
            case _:
                raise NotImplementedError()
        # TODO: Is it worth storing the music items and dealing with durations? Right now I'm claiming no.
        seen_hyphen = False
        for x in lyric_mode.find(ly.music.items.LyricText | ly.music.items.LyricItem):
            match x.token:
                case ly.lex.lilypond.LyricText():
                    if seen_hyphen:
                        parsed_lyrics[part_name][-1] += x.token
                        seen_hyphen = False
                    else:
                        parsed_lyrics[part_name].append(str(x.token))
                case ly.lex.lilypond.LyricHyphen():
                    seen_hyphen = True
                case ly.lex.lilypond.LyricExtender():
                    # Ignore extenders
                    pass
                case _:
                    raise NotImplementedError(f"Unhandled token type {x.token} in lyrics for {part_name}")
    return parsed_lyrics

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('ly_midi_file', type=Path, help="for most accurate results, matching .ly file should be in the same location")
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument('part_names', nargs='+')

    cmd_args = parser.parse_args()

    if cmd_args.verbose:
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO
    logging.basicConfig(level=log_level)
    
    ly_file = cmd_args.ly_midi_file.with_suffix(".ly")
    ly_file_exists = ly_file.exists()

    if ly_file_exists:
        part_lyrics = lyrics_from_ly_file(ly_file, cmd_args.part_names)
        logging.info("Matching .ly file found. Outputting with corrected lyric assignments.")
    else:
        logging.info("No matching .ly file found. Outputting with raw LilyPond lyric assighments.")

    in_file = mido.MidiFile(cmd_args.ly_midi_file)
    out_file = mido.MidiFile()
    # add metadata track (assumed to always be track 0)
    out_file.tracks.append(in_file.tracks[0])
    for part_name in cmd_args.part_names:
        logging.debug(f"Processing {part_name}")
        flat_track = flatten_part(in_file, part_name)
        if ly_file_exists:
            openutau_track = openutauify_with_target(flat_track, part_lyrics[part_name])
        else:
            openutau_track = openutauify(flat_track)
        out_file.tracks.append(openutau_track)
    logging.debug("Saving output file")
    out_name = f'{cmd_args.ly_midi_file.stem}_openutau{cmd_args.ly_midi_file.suffix}'
    out_file.save(out_name)
    logging.debug("Done")