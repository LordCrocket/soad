package GameModule::EventGenerator;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use Readonly;
extends 'GameModule';

my $logger = Log::Log4perl->get_logger('eventgenerator');

Readonly::Array1 my @event_titles => ("Informal dinner","Meeting at hotel");

sub _get_random_event_title {
	return $event_titles[rand(scalar @event_titles)];
}

sub _get_two_random_citizens {
	(my $self, my $citizens) = @_;
	my $number_of_citizens = scalar @{$citizens};

	if ($number_of_citizens < 2){
		die "Need at least two citizens to be able to generate an event";
	}	

	my $first_citizen = int(rand($number_of_citizens));
	my $second_citizen;
	do {
		$second_citizen = int(rand(scalar @$citizens));
	} while ($first_citizen == $second_citizen);

	return ($citizens->[$first_citizen],$citizens->[$second_citizen]);	

}

sub _generate_event {
	(my $self, my $game_state) = @_;

	my $citizens = $game_state->get_citizens();	
	(my $citizen1, my $citizen2) = $self->_get_two_random_citizens($citizens);
	my $title = $self->_get_random_event_title(); 
	$game_state->add_event($title,[$citizen1,$citizen2]);

}

override 'update_game_state' => sub {
	(my $self, my $game_state) = @_;
	$self->_generate_event($game_state);
};

__PACKAGE__->meta->make_immutable;

1;
