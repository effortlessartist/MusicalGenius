#!/usr/bin/perl

use MIDI::Simple;

new_score;
patch_change 1, 33;
patch_change 2, 46;
set_tempo 600000;
@subs = (\&keys, \&bass, \&low_wood_block, \&low_bongo, \&high_bongo, \&snare, \&kick );
foreach ( 1 .. 64 ) { synch(@subs) }
write_score("test.mid");
system("timidity -A100 -EF reverb=g,100 test.mid");
exit;

sub kick {
    my $it = shift;
    $it->n(c9, ff, n45, n43, n35, n36, hn); $it->n(ff, hn);
}

sub snare {
    my $it = shift;
    $it->r(hn);
    $it->n(c9, ff, n38, hn); 
}

sub low_wood_block {
   my $it = shift;
   my $pattern = &pattern_gen(1); 
   $it->noop(c9, mf, n77, sn);
   foreach (split('', $pattern)) {
       if ($_ eq '1') { $it->n }
       else { $it->r }
   }   
}

sub high_bongo {
    my $it = shift;
    my $pattern = &pattern_gen(10);
    $it->noop(c9, f, n60, sn);
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n }
        else { $it->r }
    }
}

sub low_bongo {
    my $it = shift;
    my $pattern = &pattern_gen(5);
    $it->noop(c9, f, n61, sn);
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n }
        else { $it->r }
    }
}

sub bass{
    my $it = shift;
    my $pattern = &pattern_gen(8,4);
    $it->noop(c1, f, qn);
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n(C3)}
        elsif ( $_ eq '2') { $it->n(D3)}
        elsif ( $_ eq '3') { $it->n(E2)}
        elsif ( $_ eq '4') { $it->n(F2)}
        elsif ( $_ eq '5') { $it->n(G2)}
        elsif ( $_ eq '6') { $it->n(A2)}
        elsif ( $_ eq '7') { $it->n(B2)}
        else { $it->r }
    }
}

sub keys {
    my $it = shift;
    my $pattern = &pattern_gen(8,8);
    $it->noop(c2, f, en);
    foreach (split('', $pattern)) {
        if ($_ eq '1') { $it->n(C4)}
        elsif ( $_ eq '2') { $it->n(D4)}
        elsif ( $_ eq '3') { $it->n(E4)}
        elsif ( $_ eq '4') { $it->n(F4)}
        elsif ( $_ eq '5') { $it->n(G4)}
        elsif ( $_ eq '6') { $it->n(A4)}
        elsif ( $_ eq '7') { $it->n(B4)}
        else { $it->n(C4) }
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
