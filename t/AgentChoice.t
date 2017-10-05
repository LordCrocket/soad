use strict; 
use warnings;
use FindBin;
use lib "$FindBin::Bin/../";
use Test::More tests => 1;
use 5.18.0;
use Log::Log4perl;
Log::Log4perl::init_and_watch('t/log4perl.conf',10);
### Custom ###
use GameState;
use GameModule::Agent;
use GameModule::GenerateCitizen;

### Setup ###
my $game_state = GameState->new();

my $citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 3);
my $agent_choice = GameModule::Agent->new();

$citizen_generator = $citizen_generator->setup($game_state);
$agent_choice->setup($game_state);

my $player = $game_state->add_player();

my ($agent,$diplomat,$diplomat2) = @{$game_state->get_citizens()};

my $event = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
my $event2 = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
my $event3 = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);

my $information2 = $game_state->_get_information($event2);
$information2->is_new(0);

$game_state->learn($agent,$event);
$game_state->learn($agent,$event2);

$game_state->set_agent($player,$agent);

$agent_choice->update_game_state($game_state);

subtest 'Citizens added to gamestate' => sub {
      plan tests => 3;
	ok(player_knows_information($game_state,$player,$event), "Player " . $player . " should have leart: " . $event);
	ok(! player_knows_information($game_state,$player,$event2), "Player " . $player . " should not have leart: " . $event2);
	ok(! player_knows_information($game_state,$player,$event3), "Player " . $player . " should not have leart: " . $event3);
};

sub player_knows_information {
	(my $game_state,my $player_clone,my $information) = @_;
	my $player = $game_state->_get_player($player_clone);
	return grep($_->id eq $information->id,@{$player->known_information})

}
