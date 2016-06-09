#!perl

use v5.22;
use warnings;
use experimental qw[
    signatures
    current_sub
    postderef
    say
];

use lib 'lib';

use Getopt::Long ();

use Importer 'Source::Tooling::Util::JSON' => qw[ decode encode ];

our $DEBUG = 0;

sub main {

    my ($f);
    Getopt::Long::GetOptions(
        'f=s'     => \$f,
        'verbose' => \$DEBUG
    );

    (defined $f)
        || die 'You must pass a function to map';

    my $src = '$f = sub ($e) { '.$f.'; }';

    (eval $src && ref $f eq 'CODE')
        || die 'Unable to compile function: ' . $f . ' because: ' . $@;

    my $input = join '' => <STDIN>;
    my $data  = decode( $input );

    (ref $data eq 'ARRAY')
        || die "Can only collate JSON arrays, not:\n$input";

    my @output = map $f->($_), @$data;

    print encode( \@output );
}

main && exit;

1;
