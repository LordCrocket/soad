use strict; 
use warnings;
use Test::More tests => 7;
use Test::Exception;
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
use Scalar::Util 'refaddr';
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

############


subtest 'Citizens added to gamestate' => sub {
      plan tests => 5;
	is(@{$game_state->_citizens},@$citizens,$game_state ." should contain " . @$citizens . " number of citizens");
	ok(contains_citizen($game_state,$agent),$game_state . " should contain " . $agent);
	ok(contains_citizen($game_state,$diplomat),$game_state . " should contain " . $diplomat);
	ok(contains_citizen($game_state,$diplomat2),$game_state . " should contain " . $diplomat2);
	ok(!contains_citizen($game_state,$citizen_not_added),$game_state . " should NOT contain " . $citizen_not_added);
};


my $event = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
my $event2 = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);

my $information = $game_state->_get_information($event);
my $information2 = $game_state->_get_information($event2);
$game_state->add_event('Meeting at hotel',[$agent,$citizen_not_added]);

$game_state->learn($agent,$event);

subtest 'Event participation' => sub {
      plan tests => 4;
	ok(knows_information($game_state,$agent,$information), $agent . " should have leart: " . $information);
	ok(knows_information($game_state,$diplomat,$information),"Participant " . $diplomat . " should have learnt: " . $information);
	ok(knows_information($game_state,$diplomat2,$information), "Participant " . $diplomat2 . " should  have learnt: " . $information);
	ok(! knows_information($game_state,$agent,$information2), $agent . " should not have learnt " . $information2);
};


my $allegiance1 = $game_state->get_allegiances()->[0];
my $allegiance2 = $game_state->get_allegiances()->[1];

$game_state->add_allegiance($agent,$allegiance1);
$game_state->add_allegiance($agent,$allegiance2);

$game_state->add_allegiance($diplomat,$allegiance2);
subtest 'Loyalty' => sub {
	plan tests => 5;
dies_ok { $game_state->add_allegiance($agent,'No such allegiance')}  'Should not be able to add nonsense allegiance';
	ok(loyal_to($game_state,$agent,$allegiance1), $agent . " should be loyal to " . $allegiance1);
	ok(loyal_to($game_state,$agent,$allegiance2), $agent . " should be loyal to " . $allegiance2);
	ok(!loyal_to($game_state,$diplomat,$allegiance1), $diplomat . " should not be loyal to " . $allegiance1);
	ok(loyal_to($game_state,$diplomat,$allegiance2), $diplomat . " should be loyal to " . $allegiance2);
};

$agent->learn($event2);
$diplomat2->add_allegiance($allegiance1);

subtest 'Citizen direct manipulation' => sub {
	plan tests => 2;
	ok(! knows_information($game_state,$agent,$information2), $agent . " should not have learnt " . $information2);
	ok(! loyal_to($game_state,$diplomat2,$allegiance1), $diplomat2 . " should not be loyal to " . $allegiance1);

};


$game_state->add_player();
$game_state->add_player();
my $player = $game_state->get_players()->[0];
my $player2 = $game_state->get_players()->[1];
$game_state->add_known_citizen($player,$agent);

subtest 'Players' => sub {
	plan tests => 5;
	is(@{$game_state->get_players()}, 2 , "Game " . $game_state . " should contain 2 players");
	ok(knows_citizen($game_state,$player,$agent), "Player " . $player . " should know of " . $agent);
	ok(! knows_citizen($game_state,$player2,$agent), "Player " . $player2 . " should not know of " . $agent);
	ok(! knows_citizen($game_state,$player,$diplomat), "Player " . $player . " should not know of " . $diplomat);
	ok(! knows_citizen($game_state,$player2,$diplomat), "Player " . $player2 . " should not know of " . $diplomat);

};


subtest 'Player direct manipulation' => sub {
	plan tests => 1;
	ok(! knows_citizen($game_state,$player2,$diplomat), "Player " . $player2 . " should not know of " . $diplomat);
};

subtest 'Object cloning direct manipulation' => sub {
	plan tests => 4;
	isnt( refaddr($player),refaddr($game_state->_players->[0]), "Cloned player should be returned from the game state");
	isnt( refaddr($agent),refaddr($game_state->_players->[0]->known_citizens->[0]), "Cloned citizen should be returned from the game state");
	isnt( refaddr($agent),refaddr($game_state->_citizens->[0]), "Cloned citizen should be returned from the game state");
	isnt( refaddr($information),refaddr($event), "Cloned event should be returned from the game state");
};


### Help functions ###

sub knows_information {
	(my $game_state,my $citizen_clone,my $information) = @_;
	my $citizen = $game_state->_get_citizen($citizen_clone);
	return grep($_->id eq $information->id,@{$citizen->_known_information})

}
sub loyal_to {
	(my $game_state,my $citizen_clone,my $allegiance) = @_;
	my $citizen = $game_state->_get_citizen($citizen_clone);
	return grep($_ eq $allegiance,@{$citizen->allegiances})

}
sub contains_citizen {
	(my $game_state,my $citizen) = @_;
	return grep($_->name eq $citizen->name,@{$game_state->_citizens})
}
sub knows_citizen {
	(my $game_state,my $player_clone, my $citizen) = @_;
	my $player = $game_state->_get_player($player_clone);
	return grep($_->name eq $citizen->name,@{$player->known_citizens})
}
sub generate_citizen {
	(my $citizen_hash) = @_;
	return GameState::Citizen->new($citizen_hash);	
}
