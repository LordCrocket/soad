use strict;
use warnings;
use Information;
use Player;
use Citizen;
use Event;
use Data::Dumper;
use Moose::Util::TypeConstraints;

my $diplomat = Citizen->new(
	name => "Harry Gold", 
	age => 56, 
	occupation => "diplomat",
	loyalty => 3,
	financial_status => 9,
	social_life => 3);
my $diplomat2 = Citizen->new(
	name => "Agatha Northwood", 
	age => 39, 
	occupation => "diplomat",
	loyalty => 7,
	financial_status => 5,
	social_life => 5);
my $agent = Citizen->new(
	name => " Northwood", 
	age => 34, 
	occupation => "chef",
	loyalty => 5,
	financial_status => 3,
	social_life => 8);

my $information = Event->new( 
	type => 'event', 
	title => 'Informal dinner', 
	participants => [$diplomat,$diplomat2]);

my $player = Player->new(known_citizen => [$agent]);
$agent->learn($information);
$diplomat->learn($information);
$diplomat2->learn($information);

print Dumper($player);

#print find_type_constraint('Occupation')->{values}};
