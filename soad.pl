use strict; 
use warnings;
use 5.20.0;
### Custom ###
use GenerateCitizen;
use EventGenerator;
use GameState;
use experimental 'smartmatch';

### Imports ###
use Data::Dumper;
use Moose::Util::TypeConstraints;
use Log::Log4perl;

Log::Log4perl::init_and_watch('log4perl.conf',10);
my $logger = Log::Log4perl->get_logger('soad');

$logger->debug("Seed is: " . srand());

my $game_state = GameState->new();
my $citizen_generator = GenerateCitizen->new(number_of_citizens => 3);
$citizen_generator->setup($game_state);

$game_state->add_player();

my $event_generator = EventGenerator->new();
$event_generator->update_game_state($game_state);
$event_generator->update_game_state($game_state);
$event_generator->update_game_state($game_state);
