require 5;
package MusicGen::Scale;

use MIDI::Simple;
use strict;
use warnings;

my @notes_array = @MIDI::Simple::Note;
my %notes_hash = %MIDI::Simple::Note;

my %Scale = (
    'major' => 2212221,
    'minor' => 2122122,
    'hminor' => 2122131,
);

sub scale_gen {
    my ($key_signature, $scal) = @_;
    my @arr;
    $key_signature //= 'C';
    $scal //= 'major';
    my $current_note = $notes_hash{ $key_signature };    
    foreach my $step (split('',$Scale{ $scal })){
        push( @arr, $notes_array[$current_note] );
        if (( $current_note + $step ) >= scalar( @notes_array )) {
            $current_note = ( $current_note + $step ) - scalar( @notes_array );
        } else {
            $current_note = $current_note + $step;
        }
    }
    return @arr; 
}
