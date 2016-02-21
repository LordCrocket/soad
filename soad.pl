use strict; 
use warnings;
use 5.20.0;
### Custom ###
use GameModule::GenerateCitizen;
use GameModule::GenerateAllegiance;
use GameModule::Agent;
use GameModule::LearnCitizen;
use GameModule::LearnInformation;
use GameModule::EventGenerator;
use GameModule::DoubleAgentGuess;
use GameState;
use experimental 'smartmatch';

### Imports ###
use Data::Dumper;
use Moose::Util::TypeConstraints;
use Log::Log4perl;
use List::Util qw(first);

Log::Log4perl::init_and_watch('log4perl.conf',10);
my $logger = Log::Log4perl->get_logger('soad');


sub get_user_input {
	print "Make choice: ";
	my $input = <STDIN>;
	chomp $input;
	return $input;
}

sub list_choices {
	say "1. List known citizens";
	say "2. List known information";
	say "3. Pick agent";
	say "4. Guess double agent";
	say "5. End turn";
}

sub list_citizens {
	(my $text,my $citizens) = @_;
	say "";
	say "$text:";
	while((my $pos, my $citizen) = each @{$citizens}){
		say "$pos: $citizen";
	}
	say "";
	say "===============";
}
sub list_known_information {
	(my $player) = @_;
	say "";
	say "Known information:";
	foreach my $information (@{$player->known_information()}){
		say $information;
	}
	say "===============";
	say "";
}
sub pick_agent {
	(my $game_state, my $player) = @_;
	(my $agent_choice) = @{$player->choices};
	my $known_citizens = $agent_choice->get_options();
	list_citizens($agent_choice->description,$known_citizens);
	my $choice = get_user_input();
	my $agent = $known_citizens->[$choice];
	$agent_choice->make_choice($agent);
}

sub guess_double_agent {
	(my $game_state, my $player) = @_;
	my $agent_choice = $player->choices->[1];
	my $known_citizens = $agent_choice->get_options();
	list_citizens($agent_choice->description,$known_citizens);
	my $choice = get_user_input();
	my $agent = $known_citizens->[$choice];
	$agent_choice->make_choice($agent);
}

sub make_choice {
	(my $game_state, my $player, my $choice) = @_;
	no warnings;
        for ($choice)
        {
            when (/1/)    { list_citizens("Known citizens",$player->known_citizens) };
            when (/2/)     { list_known_information($player)  };
            when (/3/) { pick_agent($game_state,$player)};
            when (/4/) { guess_double_agent($game_state,$player) };
            when (/5/) { return 0 };
            default           { say "No such option"  };
        }
	use warnings;
	return 1;

}

$logger->debug("Seed is: " . srand());

my $game_state = GameState->new();
my $citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 13);
my $allegiance_generator = GameModule::GenerateAllegiance->new();
my $information_learn = GameModule::LearnInformation->new();
my $citizen_learn = GameModule::LearnCitizen->new();
my $agent_choice = GameModule::Agent->new();
my $event_generator = GameModule::EventGenerator->new();
my $double_agent_guess = GameModule::DoubleAgentGuess->new();

$game_state->add_game_module($citizen_generator);
$game_state->add_game_module($allegiance_generator);
$game_state->add_game_module($event_generator);
$game_state->add_game_module($information_learn);
$game_state->add_game_module($citizen_learn);
$game_state->add_game_module($agent_choice);
$game_state->add_game_module($double_agent_guess);

$game_state->add_player();
$game_state->add_player();

$game_state->setup();

while(! $game_state->ended ) {
	$game_state->tick();
	foreach my $player (@{$game_state->get_players}){
		say "Player: " . $player;
		if(my $agent = $player->agent() ){
			say "Agent:  $agent";
		}
		do {
			list_choices();
		}while(make_choice($game_state,$player,get_user_input()));
		say "";
		say "";
	}
	$game_state->clean_up();
}



my $player = $game_state->get_players()->[0];
my $double_agent = first { scalar(@{$_->allegiances}) > 1} @{$game_state->get_citizens()};

$game_state->add_known_citizen($player,$double_agent);


my $choice = $player->choices->[0];
my $choice2 = $player->choices->[1];

$choice2->make_choice($double_agent);
