#!/usr/bin/perl
#
# read hex file from picoblaze assembler and output picoblaze boot loader file
# Each output line is four characters, with a function code in the first column
# followed by a uuencoded 16 or 18 bit binary word.
#
# +zzz    specify load address for subsequent data
# =zzz    specify data to load starting at address
#         (usually repeated)
# $zzz    jump to specified address (marks end of file)
#
open HEX, "< $ARGV[0]" or die "Opening $ARGV[0]";
# open UUE, "< $ARGV[1]" or die "Opening $ARGV[1]";

my $fill= "00000";		# fill word

# uuencode a binary value up to 18 bits
# first output char is MSB
sub uue {
    my $bin = shift(@_);
    $uu1 = chr( 32 + (($bin >> 12) & 0x3f));
    $uu2 = chr( 32 + (($bin >> 6) & 0x3f));
    $uu3 = chr( 32 + ($bin & 0x3f));
    return $uu1 . $uu2 . $uu3;
}

my @words;

while( $line = <HEX>) {		# read the hex file
    $line =~ s/[[:cntrl:]]//g;	# clean crud from line
    push @words, $line;
}
$nwords = $#words;
$nwords-- while( $words[$nwords] == $fill); # find last non-zero word
$nwords += 2;			# add a couple for safety

print "+" . uue( 0) . "\n";	# default load address = 0

for( $i=0; $i<$nwords; $i++) {
    print "=" . uue( $words[$i]) . "\n";
}

print "\$" . uue( 0) . "\n";


