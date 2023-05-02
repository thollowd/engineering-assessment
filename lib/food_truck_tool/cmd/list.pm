package food_truck_tool::cmd::list;

use strict;
use warnings;

use Cpanel::JSON::XS    ();
use Getopt::Param::Tiny ();

use food_truck_tool::utils;

sub dispatch_cmd_hr {
    return {
        clue     => 'list [--city=<CITY>] [--city=<CITY2>]',
        abstract => 'list food trucks located in the given city',
        help     => "list food trucks located in the given city\n"
          . "\tNOTE: Currently, San Francisco is the only supported city so we default to it",
        code    => \&run,
    };
}

sub run {
    my ( $app, @args ) = @_;

    my $prm = Getopt::Param::Tiny->new(
        {
            array_ref    => \@args,
            help_coderef => sub { $app->help() },
            known_only   => [ 'city' ],
        }
    );

    my @cities = $prm->param('city');

    # Default to san francisco for now since it is the only supported city
    # This line should be removed once we support more cities
    push @cities, 'san francisco' unless @cities;

    my $cities_to_list = _get_cities_to_list(\@cities);

    my $joined_cities = join ", ", @cities;
    my $die_string    = $joined_cities ? "None of the given cities are currently supported: $joined_cities\n" : "No cities were given\n";
    die $die_string unless @$cities_to_list;

    _list_cities($cities_to_list);

    return;
}

#############################
########## HELPERS ##########
#############################

=head1 ADDING SUPPORT FOR NEW CITIES

=over

=item Add the city to the $supported_cities href.  The value should be a coderef to handle listing the city

=item Add any aliases for the city to the aliases href

=cut

our $supported_cities = {
    'san francisco' => \&_list_sf,
};

our $aliases = {
    'sf' => 'san francisco'
};

sub _get_cities_to_list {
    my ($cities) = @_;

    # lowercase all entries in the array
    @$cities = map { lc $_ } @$cities;

    my $cities_to_list = [];
    foreach my $city (@$cities) {
        $city = $aliases->{$city}    if $aliases->{$city};
        push @$cities_to_list, $city if $supported_cities->{$city};
    }

    $cities_to_list = _make_uniq($cities_to_list);

    return $cities_to_list;
}

sub _make_uniq {
    my ($list) = @_;

    my %count;
    foreach ( @$list) {
        $count{$_}++;
    }

    my @uniq_list = keys %count;
    return \@uniq_list;
}

sub _list_cities {
    my ($cities) = @_;

    my $city_data = {};
    foreach my $city (@$cities) {
        $city_data->{$city} = $supported_cities->{$city}->();
    }

    my $json = Cpanel::JSON::XS::encode_json($city_data);
    print $json;

    return;
}

sub _list_sf {

    my $end_point      = 'https://data.sfgov.org/api/views/rqzj-sfat/rows.csv';
    my $local_filename = 'sf.csv';

    my $raw_data  = food_truck_tool::utils::get_data( $end_point, $local_filename );
    my $data      = food_truck_tool::utils::decode_csv($raw_data);

    my $organized_data = food_truck_tool::utils::get_csv_data_by_header($data);
    return $organized_data;
}

1;
