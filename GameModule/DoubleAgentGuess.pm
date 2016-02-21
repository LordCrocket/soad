package GameModule::DoubleAgentGuess;
use Moose;
use namespace::autoclean;
use List::Util qw(first);
extends 'GameModule';

my $logger = Log::Log4perl->get_logger('doubleagent');

sub _generate_guess_double_agent_callback {
	(my $self, my $game_state, my $player) = @_;
	
	return sub {
		(my $agent_guess) = @_;
		my $double_agent = first { scalar(@{$_->allegiances}) > 1} @{$game_state->get_citizens()};
		if($agent_guess eq $double_agent){
			$game_state->set_as_winner($player);
		}
		
	};
}

sub _generate_get_options_callback {
	(my $self, my $game_state, my $player) = @_;
	return sub {
		return $game_state->_get_player($player)->known_citizens();
	};
}

sub _add_double_agent_guess {
	(my $self,my $game_state) = @_;
	my  $players = $game_state->get_players();
	foreach my $player (@{$players}){
		my $choice = $game_state->generate_choice({
				options => $self->_generate_get_options_callback($game_state,$player),
				callback => $self->_generate_guess_double_agent_callback($game_state,$player),
				description => "Guess double agent"
			}
		
		);
		$game_state->add_choice($player,$choice);
	}

}
override 'setup' => sub {
	(my $self, my $game_state) = @_;
	$logger->debug("Adding double agent guess");
	$self->_add_double_agent_guess($game_state);
};

__PACKAGE__->meta->make_immutable;
1;
