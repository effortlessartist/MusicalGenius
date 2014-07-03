#!/usr/bin/perl

use MIDI::Simple;
use MusicGen::Scale;
use strict;
use warnings;
use Data::Dumper;


my @scale = MusicGen::Scale::scale_gen('D','hminor');

my $measure;

my $on_off;
my $big_num = 800000;

sub kick {
    my $it = shift;
    my $pattern = pattern_gen(2,8); 
    my $count = 0;
    $it->noop(qw(c9 fff n45 n43 n35 n36 en));
    foreach (split //, $pattern){
        if ($count == 0){$it->n}
        elsif ($count == 4){$it->r}
        elsif ($_ == 1){$it->n}else{$it->r}
        ++$count;
    }
}

sub snare {
    my $it = shift;
    my $pattern = pattern_gen(4); 
    my $count = 0;
    $it->noop(qw(c9 f n38 sn)); 
    foreach (split //, $pattern) {
        if ($count == 0){$it->r}
        elsif ($count == 8 and $_ > 0){$it->n("f")}
        elsif ($_ == 1) {$it->n("p")}else{$it->r}
        ++$count;
    }
}

sub low_wood_block {
   my $it = shift;
   my $pattern = pattern_gen(4); 
   my $count = 0;
   $it->noop(qw(c9 n77 sn));
   foreach (split //, $pattern) {
       if ( $count % 2 == 0 and $_ eq '1') { $it->n("m") }
       elsif ( $count % 2 == 1 and $_ eq '1') { $it->n("p") }
       else { $it->r }
       ++$count;
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



sub bass{
    my $it = shift;
    $on_off = int(rand(6));
    return if $measure % 4 == $on_off; 
    my $pattern = pattern_gen(8,4);
    $it->noop(qw(c1 f o2 qn));
    for my $note (notes($pattern, @scale)) { 
        if (defined $note) {
            $it->channel_after_touch(1, int(rand(127)));
            $it->n($note); 
        } 
        else { 
            $it->r 
        }
    }
}

sub keys {
    my $it = shift;
    $on_off = int(rand(5));
    return if $measure % 4 == $on_off;
    my $pattern = pattern_gen(8,8);
    $it->noop(qw(c2 f o4 en));
    for my $note (notes($pattern, @scale)) { 
        if (defined $note) {
            $it->channel_after_touch(2,int(rand(127)));
            $it->control_change(2, 10, (int(rand(15)) + 45));
            $it->n($note, "V".(int(rand(43)) + 64)); 
        } 
        else { 
            $it->r 
        }
    }
}

sub piano {
    my $it = shift;
    $on_off = int(rand(5));
    return if $measure % 4 == $on_off;
    my $pattern = pattern_gen(10);
    my $count = 0;
    $it->noop(qw(c3 mezzo o5 sn));
    for my $note (notes($pattern, @scale)) { 
        if (defined $note and $count % 2 == 1) {
            $it->channel_after_touch(3, int(rand(127)));
            $it->control_change(3, 10, (int(rand(10)) + 74)); 
            $it->n($note, "V".(int(rand(40)) + 44)); 
        } 
        elsif (defined $note and $count % 2 == 0) {
            my $coin = int(rand(2));
            if ($coin == 0){
                $it->channel_after_touch(3, int(rand(127)));
                $it->control_change(3, 10, (int(rand(10)) + 74));
                $it->n($note, "V".(int(rand(20)) + 24));
            }else{
                $it->r
            }
        }
        else { 
            $it->r 
        }
        ++$count;
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

sub notes { 
  my ($pattern, @scale) = @_; 
 
  return map { $_ < @scale ? $scale[$_] : undef } split //, $pattern;
} 

sub measure_counter {
    my $it = shift;
    $it->r("wn");
    ++$measure;
}


new_score;
patch_change 1, 33; control_change 1, 7, 127;
patch_change 2, 46; control_change 2, 64, 64; 
control_change 3, 64, 64;
set_tempo $big_num; 
my @subs = ( 
    \&measure_counter, 
    \&keys, 
    \&bass, 
    \&piano, 
    \&low_wood_block, 
    \&low_bongo, 
    \&high_bongo, 
    \&snare, 
    \&kick, 
);
foreach ( 1 .. 16 ) { 
    synch(@subs); 
    my $pattern = pattern_gen(2,1);
    my $coin = int(rand(2));
    foreach (split //, $pattern){
        set_tempo $big_num; 
        if ($_ eq '0' and $measure % 4 == 0){
            $big_num = $big_num - int(rand(10000));
        }elsif($_ eq '1' and $measure % 4 == 0) {
            $big_num = $big_num + int(rand(10000));
        }
        print $big_num." "; 
    }
}
write_score("test.mid");
system("timidity -A100 -EF reverb=g,100 test.mid");


