import argparse
from pathlib import Path

import mido


# This appears to be the correct character to set as lyrics to get openutau to respect slurs
slur_string = '+'
# For whatever reason openutau refuses to synthesize if the first word does not start with a vowel. Add this character to enable easy synthesis.
start_vowel = 'a'


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
    * Ensure the first lyric event starts with a vowel
    """
    openutau_track = mido.MidiTrack()
    past_first_lyric = False
    seen_lyric = False
    for message in flat_track:
        match message:
            case mido.MetaMessage(type='lyrics'):
                if not message.text:
                    raise RuntimeError("For synthesis, all voices must have lyrics")
                # Ensure first lyric starts with a vowel
                if not past_first_lyric:
                    if not message.text[0].lower() in 'aeiou':
                        message.text = f'{start_vowel}{message.text}'
                    past_first_lyric = True
                seen_lyric = True
            case mido.Message(type='note_on', velocity=0):
                if not seen_lyric:
                    openutau_track.append(mido.MetaMessage(type='lyrics', text=slur_string))
                seen_lyric = False
            case _:
                pass
        openutau_track.append(message)
    return openutau_track

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('ly_midi_file', type=Path)
    parser.add_argument('part_names', nargs='+')

    cmd_args = parser.parse_args()
    in_file = mido.MidiFile(cmd_args.ly_midi_file)
    out_file = mido.MidiFile()
    # add metadata track (assumed to always be track 0)
    out_file.tracks.append(in_file.tracks[0])
    for part_name in cmd_args.part_names:
        flat_track = flatten_part(in_file, part_name)
        openutau_track = openutauify(flat_track)
        out_file.tracks.append(openutau_track)
    out_name = f'{cmd_args.ly_midi_file.stem}_openutau{cmd_args.ly_midi_file.suffix}'
    out_file.save(out_name)
