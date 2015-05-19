use strict;
use warnings;
use Information;
use Player;
use Citizen;
use GenerateCitizen;
use Event;
use Data::Dumper;
use Moose::Util::TypeConstraints;

my $citizens = GenerateCitizen::generate_citizens(3);
my $diplomat = $citizens->[0];
my $diplomat2 = $citizens->[1];
my $agent = $citizens->[2];

my $information = Event->new( 
	type => 'event', 
	title => 'Informal dinner', 
	participants => [$diplomat,$diplomat2]);

my $player = Player->new(known_citizen => [$agent]);
$agent->learn($information);
$diplomat->learn($information);
$diplomat2->learn($information);


print Dumper($player);

#print Dumper(find_type_constraint('Occupation')->{values});
