use strict; 
use warnings;
use Test::More tests => 2;
use 5.18.0;
### Custom ###
use GameState::Information;
use GameState::Player;
use GameState::Citizen;
use GameState::Event;
use GenerateCitizen;
use GameState;
use experimental 'smartmatch';
use Log::Log4perl;
use Data::Dumper;
Log::Log4perl::init_and_watch('t/log4perl.conf',10);

### Setup ###

my $game_state = GameState->new();
my $occupations = $game_state->get_occupations();

my $citizen_generator = GenerateCitizen->new(number_of_citizens => 3);
$citizen_generator = $citizen_generator->setup($game_state);
my $citizens = $game_state->get_citizens();
my $diplomat = $citizens->[0];
my $diplomat2 = $citizens->[1];
my $agent = $citizens->[2];
my $citizen_not_added = GameState::Citizen->new( name => "Kalle Kula"
						 , age  => 8
						 , occupation  => 'chef'
						 , loyalty  => 5
						 , financial_status  => 5
						 , social_life  => 5
					    );


my $event = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
my $event2 = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);

my $information = $game_state->get_information($event);
$game_state->add_event('Meeting at hotel',[$agent,$citizen_not_added]);

$game_state->learn($agent,$event);


############


subtest 'Citizens added to gamestate' => sub {
      plan tests => 5;
	is(@{$game_state->_citizens},@$citizens,$game_state ." should contain " . @$citizens . " number of citizens");
	ok(contains_citizen($game_state,$agent),$game_state . " should contain " . $agent);
	ok(contains_citizen($game_state,$diplomat),$game_state . " should contain " . $diplomat);
	ok(contains_citizen($game_state,$diplomat2),$game_state . " should contain " . $diplomat2);
	ok(!contains_citizen($game_state,$citizen_not_added),$game_state . " should NOT contain " . $citizen_not_added);
};



subtest 'Event participation' => sub {
      plan tests => 3;
	ok(knows_information($game_state,$agent,$information), $agent . " should have leart: " . $information);
	ok(knows_information($game_state,$diplomat,$information),"Participant " . $diplomat . " should have learnt: " . $information);
	ok(knows_information($game_state,$diplomat2,$information), "Participant " . $diplomat2 . " should  have learnt: " . $information);
};



### Help functions ###

sub knows_information {
	(my $game_state,my $citizen_clone,my $information) = @_;
	my $citizen = $game_state->_get_citizen($citizen_clone);
	return grep($_->id eq $information->id,@{$citizen->_known_information})

}
sub contains_citizen {
	(my $game_state,my $citizen) = @_;
	return grep($_->name eq $citizen->name,@{$game_state->_citizens})
}
sub generate_citizen {
	(my $citizen_hash) = @_;
	return GameState::Citizen->new($citizen_hash);	
}
