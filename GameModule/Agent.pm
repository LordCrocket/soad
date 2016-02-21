package GameModule::Agent;
use Moose;
use namespace::autoclean;

extends 'GameModule';

my $logger = Log::Log4perl->get_logger('agent');


sub _generate_set_agent_callback {
	(my $self, my $game_state, my $player) = @_;
	
	return sub {
		(my $agent) = @_;
		$game_state->set_agent($player,$agent);
	};
}
sub _generate_get_options_callback {
	(my $self, my $game_state, my $player) = @_;
	return sub {
		return $game_state->_get_player($player)->known_citizens();
	};
}

sub _add_agent_choice {
	(my $self,my $game_state) = @_;
	my  $players = $game_state->get_players();
	foreach my $player (@{$players}){
		my $choice = $game_state->generate_choice({
				options => $self->_generate_get_options_callback($game_state,$player),
				callback => $self->_generate_set_agent_callback($game_state,$player),
				description => "Pick agent"
			}
		
		);
		$game_state->add_choice($player,$choice);
	}

}
override 'setup' => sub {
	(my $self, my $game_state) = @_;
	$logger->debug("Adding agent choice");
	$self->_add_agent_choice($game_state);
};


sub _add_all_new_information {
	(my $self,my $game_state,my $player,my $agent) = @_;
	foreach my $information (@{$agent->known_information}){
		if($information->is_new()){
			$logger->debug("Agent:" . $agent ." passed ". $information . " to player " . $player);
			$game_state->player_learn($player,$information);
		}

	}

}

sub _get_information_from_agent {
	(my $self,my $game_state) = @_;
	foreach my $player (@{$game_state->get_players()}){
		if (my $agent = $player->agent()){
			$self->_add_all_new_information($game_state,$player,$agent);
		}

	}

} 

override 'update_game_state' => sub {
	(my $self, my $game_state) = @_;
	$self->_get_information_from_agent($game_state);
};

__PACKAGE__->meta->make_immutable;
1;
