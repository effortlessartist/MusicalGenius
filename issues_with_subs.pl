#!/usr/bin/perl

use MIDI::Simple;
use MusicGen::Scale;
use strict;
use warnings;
use Data::Dumper;

#new_score;
#patch_change 1, 33;
#patch_change 2, 46; set_tempo 600000;
#my @subs = (\&keys, \&piano, \&bass, \&low_wood_block, \&low_bongo, \&high_bongo, \&snare, \&kick );
#foreach ( 1 .. 64 ) { synch(@subs) }
#write_score("test.mid");
#system("timidity -A100 -EF reverb=g,100 test.mid");
#exit;

sub kick {
    my $it = shift;
    $it->n(qw(c9 ff n45 n43 n35 n36 hn)); $it->n(qw(ff hn));
}

sub snare {
    my $it = shift;
    $it->r("hn");
    $it->n(qw(c9 ff n38 hn)); 
}

sub low_wood_block {
   my $it = shift;
   my $pattern = pattern_gen(1); 
   $it->noop(qw(c9 mf n77 sn));
   foreach (split('', $pattern)) {
       if ($_ eq '1') { $it->n }
       else { $it->r }
   }   
}

sub high_bongo {
    my $it = shift;
    my $pattern = pattern_gen(10);
    $it->noop(qw(c9 f n60 sn));
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n }
        else { $it->r }
    }
}

sub low_bongo {
    my $it = shift;
    my $pattern = pattern_gen(5);
    $it->noop(qw(c9 f n61 sn));
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n }
        else { $it->r }
    }
}

{
my @scale = MusicGen::Scale::scale_gen('G','hminor');

sub bass{
    my $it = shift;
    my $pattern = pattern_gen(8,4);
    $it->noop(qw(c1 f o2 qn));
    foreach (split('', $pattern)) {
        print Dumper \@scale;
        if ($_ eq '1') { $it->n($scale[0])}
        elsif ( $_ eq '2') { $it->n($scale[1])}
        elsif ( $_ eq '3') { $it->n($scale[2])}
        elsif ( $_ eq '4') { $it->n($scale[3])}
        elsif ( $_ eq '5') { $it->n($scale[4])}
        elsif ( $_ eq '6') { $it->n($scale[5])}
        elsif ( $_ eq '7') { $it->n($scale[6])}
        else { $it->r }
    }
}

sub keys {
    my $it = shift;
    my $pattern = pattern_gen(8,8);
   # my @scale = MusicGen::Scale::scale_gen('G','hminor');
    $it->noop(qw(c2 f o4 en));
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n($scale[0])}
        elsif ( $_ eq '2') { $it->n($scale[1])}
        elsif ( $_ eq '3') { $it->n($scale[2])}
        elsif ( $_ eq '4') { $it->n($scale[3])}
        elsif ( $_ eq '5') { $it->n($scale[4])}
        elsif ( $_ eq '6') { $it->n($scale[5])}
        elsif ( $_ eq '7') { $it->n($scale[6])}
        else { $it->r }
    }
}

sub piano {
    my $it = shift;
    my $pattern = pattern_gen(10);
   # my @scale = MusicGen::Scale::scale_gen('G','hminor');
    $it->noop(qw(c3 mezzo o4 sn));
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n($scale[0])}
        elsif ( $_ eq '2') { $it->n($scale[1])}
        elsif ( $_ eq '3') { $it->n($scale[2])}
        elsif ( $_ eq '4') { $it->n($scale[3])}
        elsif ( $_ eq '5') { $it->n($scale[4])}
        elsif ( $_ eq '6') { $it->n($scale[5])}
        elsif ( $_ eq '7') { $it->n($scale[6])}
        else { $it->r }
    }
}
}
sub pattern_gen {
    my ($frequency, $notes_per_measure) = @_;
    if ( $frequency < 2 ) { $frequency = 2 }else{ $frequency = $_[0] }
    $notes_per_measure //= 16;
    my $str = "";
    foreach my $i (1 .. $notes_per_measure){

        my $random_number = int(rand($frequency));
        $str = $str . $random_number;

    }
    return $str;
}

