package food_truck_tool::utils;

use strict;
use warnings;

use Path::Tiny;

use LWP::UserAgent   ();

sub get_data {
    my ( $end_point, $filename ) = @_;


    die "end_point arg is required\n" unless $end_point;
    die "filename arg is required\n"  unless $filename;

    my $local_directory = "$FindBin::Bin/../cache";
    _ensure_directory($local_directory);

    my $path = "$local_directory/$filename";

    my $http     = LWP::UserAgent->new( timeout => 10 );
    my $response = $http->mirror( $end_point, $path );

    my $data;

    # A 304 status means that the file has not changed since we last downloaded it
    if ( $response->is_success() || $response->code() eq '304' ) {
        $data = Path::Tiny::path($path)->slurp();
    }
    else {
        my $status = $response->status_line();
        die "Failed to download the endpoint: $status\n";
    }

    return $data;
}

sub _ensure_directory {
    my ($dir) = @_;

    die "dir arg is required\n" unless $dir;

    mkdir $dir;
    return;
}

1;
