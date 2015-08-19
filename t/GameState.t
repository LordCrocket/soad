use strict; 
use warnings;
use Test::More tests => 2;
use 5.18.0;
### Custom ###
use Information;
use Player;
use Citizen;
use GenerateCitizen;
use Event;
use GameState;
use experimental 'smartmatch';
use Log::Log4perl;
use Data::Dumper;
Log::Log4perl::init_and_watch('t/log4perl.conf',10);


### Setup ###
my $citizen_generator = GenerateCitizen->new(number_of_citizens => 4);
my $citizens = $citizen_generator->_generate_citizens();
my $diplomat = $citizens->[0];
my $diplomat2 = $citizens->[1];
my $agent = $citizens->[2];
my $citizen_not_added = $citizens->[3];

my $game_state = GameState->new();

my $information = Event->new( 
	title => 'Informal dinner', 
	participants => [$diplomat,$diplomat2]);
my $information2 = Event->new( 
	title => 'Meeting at hotel', 
	participants => [$agent,$citizen_not_added]);

my $player = Player->new();

$game_state->add_player($player);

my @citizens = ($agent,$diplomat,$diplomat2);
foreach my $citizen (@citizens) {
	$game_state->add_citizen($citizen);
}

$game_state->add_information($information);
$game_state->learn($agent,$information);


############


subtest 'Citizens added to gamestate' => sub {
      plan tests => 5;
	is(@{$game_state->_citizens},@citizens,$game_state ." should contain " . @citizens . " number of citizens");
	ok(contains_citizen($game_state,$agent),$game_state . " should contain " . $agent);
	ok(contains_citizen($game_state,$diplomat),$game_state . " should contain " . $diplomat);
	ok(contains_citizen($game_state,$diplomat2),$game_state . " should contain " . $diplomat2);
	ok(!contains_citizen($game_state,$citizen_not_added),$game_state . " should NOT contain " . $citizen_not_added);
};



subtest 'Event participation' => sub {
      plan tests => 3;
	ok(knows_information($agent,$information), $agent . " should have leart: " . $information);
	ok(knows_information($diplomat,$information),"Participant " . $diplomat . " should have learnt: " . $information);
	ok(knows_information($diplomat2,$information), "Participant " . $diplomat2 . " should  have learnt: " . $information);
};



### Help functions ###

sub knows_information {
	(my $citizen,my $information) = @_;
	return grep($_->id eq $information->id,@{$citizen->_known_information})

}
sub contains_citizen {
	(my $game_state,my $citizen) = @_;
	return grep($_->name eq $citizen->name,@{$game_state->_citizens})
}
