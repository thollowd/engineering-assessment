package food_truck_tool::utils;

use strict;
use warnings;

use Path::Tiny;

use LWP::UserAgent ();
use Text::CSV      ();

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

sub decode_csv {
    my ($raw_data) = @_;

    die "raw_data arg is required\n" unless $raw_data;

    my $csv = Text::CSV->new( { sep_char => ',' } );

    my $data  = {};
    my $i     = 0;
    my @lines = split /\n/, $raw_data;
    foreach my $line (@lines) {
        $i++;

        $csv->parse($line);
        my @columns = $csv->fields();
        next if _is_blank(\@columns);

        $i == 1 ? $data->{headers} = \@columns : push @{ $data->{data} }, \@columns;
    }

    return $data;
}

sub get_csv_data_by_header {
    my ($data) = @_;

    die "data arg is required\n" unless $data;

    my $organized_data = [];
    foreach my $val ( @{ $data->{data} } ) {

        my %temp_hash;
        my $i = 0;
        foreach my $header ( @{ $data->{headers} } ) {
            $temp_hash{$header} = $val->[$i];
            $i++;
        }

        push @$organized_data, \%temp_hash;
    }

    return $organized_data;
}

sub _ensure_directory {
    my ($dir) = @_;

    die "dir arg is required\n" unless $dir;

    mkdir $dir;
    return;
}

sub _is_blank {
    my ($column) = @_;

    return 1 if !ref $column;

    foreach my $val (@$column) {
        return 0 if $val;
    }

    return 1;
}

1;
