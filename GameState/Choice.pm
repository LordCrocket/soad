package GameState::Choice;
use Moose;
use MooseX::StrictConstructor;
use MooseX::ClassAttribute;
use namespace::autoclean;


my $logger = Log::Log4perl->get_logger('choice');

use overload '""' => "to_string", fallback => 1;

has 'description' =>( is => 'ro');

class_has 'counter' => (
      traits  => ['Counter'],
      is      => 'ro',
      isa     => 'Int',
      default => 0,
      handles => {
          inc_counter   => 'inc',
          dec_counter   => 'dec',
          reset_counter => 'reset',
      },
);

has 'id' => (is => 'ro', isa => 'Int',required => '0',default => sub { return GameState::Choice->inc_counter;});

has 'options' => (
	is => 'ro',
	isa => 'ArrayRef',
	traits  => ['Array'],
	required => '1',
	default => sub {[]},
);

has 'callback' => (
	traits  => ['Code'],
	is      => 'ro',
	isa     => 'CodeRef',
	required => '1',
	handles => {
		call => 'execute_method',
	},
);

sub to_string {
	(my $self) = @_;
	return $self->description;
}

__PACKAGE__->meta->make_immutable;
1;
