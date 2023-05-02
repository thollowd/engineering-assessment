#!/usr/bin/perl

use strict;
use warnings;

package food_truck_tool;

=head1 ADDING A NEW SUBCOMMAND

=over

=item Add a use statement for the package for the new command (should food_truck_tool::cmd::$SUBCOMMAND)

=item Add the subcommand to the cmds hash

=item Add a sub similar to the following in the pm for the new subcommand

    sub dispatch_cmd_hr {
        return {
            clue     => 'subcommand options',
            abstract => 'hint for what the subcommand does',
            help     => 'full help for the subcommand',
            code     => \&run,
        };
    }

=back

=cut

sub get_dispatch_args {
    use food_truck_tool::cmd::list;

    my $hint_blurb = "This tool supports the following commands (i.e. $0 {command} …):";
    my %opts       = (
        default_commands => 'help',
        'help:pre_hint'  => $hint_blurb,
        'help:pre_help'  => qq{Various food truck finder utilities\n\n$hint_blurb},
    );

    my %cmds = (
        list => scalar food_truck_tool::cmd::list::dispatch_cmd_hr(),
    );

    return ( \%cmds, \%opts );
}

1;
