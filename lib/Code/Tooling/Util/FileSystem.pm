package Code::Tooling::Util::FileSystem;

use v5.22;
use warnings;
use experimental qw[
    signatures
    current_sub
];

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';
our $DEBUG     = 0;

our @EXPORT_OK = qw[
    &traverse_filesystem
];

sub traverse_filesystem ($dir, $v, $acc, %opts) {

    # when it's not a dir, it's a file

    if ( -f $dir ) {
        $v->( $dir, $acc );
    } elsif  ( -d $dir ) {
        my @children = $dir->children( no_hidden => 1 );

        if ( my $exclude = $opts{exclude} ) {
            @children = grep $_->stringify !~ /$exclude/, @children;
        }

        if ( my $include = $opts{include} ) {
            @children = grep $_->stringify =~ /$include/, @children;
        }

        map __SUB__->( $_, $v, $acc, %opts ), @children;
    } elsif ( -l $dir ) {
        warn "symlink found" if $DEBUG;
    } else {
        warn "unknown file category" if $DEBUG;
    }

    return;
}

1;

__END__
