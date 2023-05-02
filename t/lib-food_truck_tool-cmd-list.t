#!/usr/bin/perl

use strict;
use warnings;

use Test::Spec;

use FindBin;
use lib "$FindBin::Bin/../lib";

require "$FindBin::Bin/../bin/food_truck_tool";

describe "food_truck_finder's list subcommand" => sub {

    my $test_data = q[locationid
735318
];

    it "should default to San Francisco" => sub {
        my $cities;
        local *food_truck_tool::cmd::list::_list_cities = sub { $cities = shift; };

        food_truck_tool::script::run('list');

        is_deeply( $cities, [ 'san francisco' ] ) or diag explain $cities;
    };

    it "should die if given only unsupported cities" => sub {
        trap { food_truck_tool::script::run( 'list', '--city=foo', '--city=bar' ); };

        is( $trap->leaveby, 'die' );
    };

    it "should only list supported cities if given a list of containing supported and unsupported cities" => sub {
        my $cities;
        local *food_truck_tool::cmd::list::_list_cities = sub { $cities = shift; };

        food_truck_tool::script::run( 'list', '--city=sf', '--city=bar' );

        is_deeply( $cities, [ 'san francisco' ] ) or diag explain $cities;
    };

    it "should return the data for each requested city as json to STDOUT" => sub {
        local *food_truck_tool::utils::get_data = sub { return $test_data; };

        trap { food_truck_tool::script::run('list'); };

        is(
            $trap->stdout,
            '{"san francisco":[{"locationid":"735318"}]}'
        ) or diag explain $trap->stdout;
    };
};


runtests unless caller;
